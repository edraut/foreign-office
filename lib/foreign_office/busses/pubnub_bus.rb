class ForeignOffice::Busses::PubnubBus < ForeignOffice::Busses::GenericBus

  def self.settings
    @settings ||= Sekrets.settings_for(Rails.root.join('config', 'pubnub.yml.enc'))
  end

  def self.connection
    @pubnub ||= ::Pubnub.new(
      publish_key:    self.settings['PUBNUB_PUBLISH_KEY'], # publish_key only required if publishing.
      subscribe_key:  self.settings['PUBNUB_SUBSCRIBE_KEY'], # required
      secret_key:     self.settings['PUBNUB_SECRET_KEY'],
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