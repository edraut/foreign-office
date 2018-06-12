class Pubnub
  def initialize(hash)
    @publish_key   = hash[:publish_key]
    @subscribe_key = hash[:subscribe_key]
    @secret_key    = hash[:secret_key]
    @ssl           = true
  end

  def publish(message)
    return {
      channel: message[:channel],
      message: message[:message]
    }
  end
end