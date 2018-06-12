class ForeignOffice::Busses::PusherBus < ForeignOffice::Busses::GenericBus
  def self.config(config)
    # Pusher now pulls config directly from the ENV
    Pusher.encrypted = true
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
    @pusher ||= Pusher
  end

  def self.publish(message)
    message.symbolize_keys!
    channel = sanitize_channel(message[:channel])
    
    if browser_tab_id = message[:browser_tab_id]
      channel += "@#{browser_tab_id}"
    end

    self.connection.trigger(
      channel,
      'publish',
      message
    )
  end

  def self.sanitize_channel(channel)
    channel.gsub(/::/,'.')
  end
end