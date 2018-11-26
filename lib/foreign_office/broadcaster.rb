module ForeignOffice
  module Broadcaster

    def self.included(base)
      base.extend ClassMethods
      def handle_broadcast
        self.broadcast_change if self.changed?
      end

      def broadcast_change
        Rails.logger.debug "Broadcasting change for #{self.inspect}..."
        Rails.logger.debug "Serialize: #{self.serialize}"
        if self.class.channel_presence_required?
          PresenceChannelPublishJob.set(wait: 1).perform_later(id, self.class.name, self.serialize)
        else
          ForeignOffice.publish(channel: "#{self.class.foreign_office_channel_prefix}#{self.id}", object: self.serialize)
        end
      rescue => e
        Rails.logger.error "Failed to broadcast change: #{e.inspect}"
        Rails.logger.debug e.backtrace.join("\n")
        raise e
      end

      def serialize
        self.attributes
      end
    end

    module ClassMethods
      def broadcast_changes!
        self.send(:after_save, :handle_broadcast, {unless: :skip_all_callbacks})
      end

      def require_channel_presence
        @channel_presence_required = true
      end

      def channel_presence_required?
        @channel_presence_required
      end

      def foreign_office_channel_prefix
        self.name.gsub(/::/,'-')
      end

    end

  end
end
