module ForeignOffice
  module Busses
    class GenericBus
      def self.flush_messages
        @@messages = []
      end

      def self.published_messages
        @@messages
      end
      
      def self.publish(message)
        @@messages << message
      end

      def self.config(config)
      end

      def self.connection
      end
    end
  end
end