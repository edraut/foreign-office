class ForeignOffice::Busses::PusherBus < ForeignOffice::Busses::GenericBus
  def self.config(config)
    self.app_id = config[:app_id]
    self.key = config[:key]
    self.secret = config[:secret]
  end

  def self.app_id=(app_id)
    @app_id = app_id
  end

  def self.app_id
    @app_id
  end
  
  def self.key=(key)
    @key = key
  end

  def self.key
    @key
  end
  
  def self.secret=(secret)
    @secret = secret
  end

  def self.secret
    @secret
  end
  
  def self.connection
    @pusher ||= Pusher::Client.new({
      app_id: self.app_id,
      key: self.key,
      secret: self.secret
    })
  end

  def self.publish(message)
    message.symbolize_keys!
    self.connection.trigger(
      message[:channel],
      'publish',
      message
    )
  end
end