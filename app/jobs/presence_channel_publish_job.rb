class PresenceChannelPublishJob < ApplicationJob
  queue_as :default

  def perform(obj_id, obj_class_name, serialized_state)
    obj_class = obj_class_name.constantize
    serialized_state.symbolize_keys!
    channel_name = "presence-#{obj_class.foreign_office_channel_prefix}#{obj_id}"
    if browser_tab_id = serialized_state[:browser_tab_id]
      channel_name += "@#{browser_tab_id}"
    end
    if (!ForeignOffice.bus.connection.respond_to?(:channel_users) ||
        ForeignOffice.bus.connection.channel_users(channel_name)[:users].any?)

      ForeignOffice.publish(
        channel: channel_name,
        object: serialized_state
      )
    else
      serialized_state[:foreign_office_retries] ||= 0
      if serialized_state[:foreign_office_retries] < 5 # five total tries
        retry_wait = 2**serialized_state[:foreign_office_retries]
        serialized_state[:foreign_office_retries] += 1
        PresenceChannelPublishJob.set(wait: retry_wait).perform_later(obj_id, obj_class_name, serialized_state)
      else
        failure_message = "PresenceChannelPublishJob: client never connected, not able to send"
        dont_raise = StandardError.new(failure_message)
        Bugsnag.notify(dont_raise) do |report|
          report.severity = 'error'
          report.add_tab(:presence_channel, obj_class_name: obj_class_name, obj_id: obj_id, serialized_state: serialized_state)
        end
        Rails.logger.error(failure_message)
        Rails.logger.error("PresenceChannelPublishJob: #{obj_class_name}: #{obj_id}: #{serialized_state}")
      end
    end
  end

end