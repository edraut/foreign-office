require 'request_store'
module ForeignOffice

  class Engine < ::Rails::Engine
    isolate_namespace ForeignOffice
  end

  module Test
    autoload :ClientExec,  'foreign_office/test/client_exec'
    autoload :FakeForeignOffice,  'foreign_office/test/fake_foreign_office'
  end

  def self.config(config)
    self.bus = config[:bus][:klass]
    self.bus.config(config[:bus])
    @publish_method = config[:publish_method]
  end

  def self.bus=(bus)
    @bus = bus
  end

  def self.bus
    @bus
  end
  
  def self.set_publish_method(&block)
    @publish_method = block
  end

  def self.publish_method
    @publish_method
  end

  def self.publish(message)
    Rails.logger.debug("ForeignOffice.publish: #{message.inspect}")
    if !!@cache_messages
      RequestStore.store[:foreign_office_messages][message[:channel]] = message
    else
      self.handle_publish_request(message)
    end
  end

  def self.cache_messages
    @cache_messages = true
    RequestStore.store[:foreign_office_messages] = {}
  end

  def self.publish_directly
    @cache_messages = false
  end

  def self.flush_messages
    messages = RequestStore.store[:foreign_office_messages].dup
    RequestStore.store[:foreign_office_messages] = {}
    messages.each do |channel,message|
      self.handle_publish_request(message)
    end
  end

  def self.handle_publish_request(message)
    if self.publish_method
      self.publish_method.call(message)
    else
      self.publish!(message)
    end
  end

  def self.publish!(message, attempts = 0)
    attempts += 1
    Rails.logger.debug("ForeignOffice#publish! attempt: #{attempts} message: #{message.inspect}")
    self.bus.publish(message)
  end

end
require 'foreign_office/busses/generic_bus'
require 'foreign_office/busses/pubnub_bus'