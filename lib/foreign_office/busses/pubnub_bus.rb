class ForeignOffice::Busses::PubnubBus < ForeignOffice::Busses::GenericBus

  def self.config(config)
    self.publish_key = config[:publish_key]
    self.subscribe_key = config[:subscribe_key]
    self.secret_key = config[:secret_key]
  end

  def self.publish_key=(publish_key)
    @publish_key = publish_key
  end

  def self.publish_key
    @publish_key
  end

  def self.subscribe_key=(subscribe_key)
    @subscribe_key = subscribe_key
  end

  def self.subscribe_key
    @subscribe_key
  end

  def self.secret_key=(secret_key)
    @secret_key = secret_key
  end

  def self.secret_key
    @secret_key
  end

  def self.connection
    @pubnub ||= ::Pubnub.new(
      publish_key:    self.publish_key, # publish_key only required if publishing.
      subscribe_key:  self.subscribe_key, # required
      secret_key:     self.secret_key,
      error_callback: lambda { |msg| Rails.logger.error( msg.inspect )}
    )
  end

  def self.publish(message)
    message.symbolize_keys!
    self.connection.publish(
      channel:  message[:channel],
      message:  message,
      http_sync: true,
      callback: lambda{|response|
        if 0 == JSON.parse(response.instance_variable_get(:@response)).first #pubnub publishing failed
          if attempts <= 3
            self.publish!(message, attempts) #retry if we failed
          else
            Rails.logger.debug("ForeignOffice#publish! failed after #{attempts} attempts. message: #{message.inspect}")
          end
        end
      }
    )
  end

end