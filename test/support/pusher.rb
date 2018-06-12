class Pusher
  def self.encrypted=(bool)
    @encrypt = bool
  end

  def self.encrypted
    @encrypt
  end

  def self.trigger(channel, command, message)
    return {
      channel: channel,
      command: command,
      message: message,
    }
  end
end