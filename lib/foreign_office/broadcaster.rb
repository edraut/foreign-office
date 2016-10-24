module ForeignOffice
  module Broadcaster

    def self.included(base)
      base.extend ClassMethods
      def handle_broadcast
        self.broadcast_change if self.changed?
      end

      def broadcast_change
        Rails.logger.debug "Broadcasting change for #{self.inspect}..."
        Rails.logger.debug "Class name: #{self.class.name}"
        Rails.logger.debug "ID: #{self.id}"
        Rails.logger.debug "Serialize: #{self.serialize}"
        ForeignOffice.publish(channel: "#{self.class.name}#{self.id}", object: self.serialize)
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
    end
  end
end