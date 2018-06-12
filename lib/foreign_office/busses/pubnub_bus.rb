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
      ssl:            true
    )
  end

  def self.publish(message)
    message.symbolize_keys!
    channel = message[:channel]

    if browser_tab_id = mesage[:browser_tab_id]
      channel += "@#{browser_tab_id}" 
    end

    self.connection.publish(
      channel:  channel,
      message:  message,
      http_sync: true
    ) do |envelope|
      if '200' != envelope.status_code.to_s
        Rails.logger.error "ForeignOffice error esponse:"
        Rails.logger.error envelope.message
        Rails.logger.error envelope.channel
        Rails.logger.error envelope.status_code
        Rails.logger.error envelope.timetoken
      end
    end
  end

end