module ForeignOffice::Test::FakeForeignOffice
  def self.included base
    base.instance_eval do
      def publish(stuff)
        publish!(stuff)
      end
      def publish!(message)
        File.open(Rails.root + 'tmp/foreign_office_rspec_cache.json','a+') do |file|
          file.write(message.to_json)
          file.write('IH_FO_MESSAGE_SEPARATOR')
        end
      end
      def cache_messages
      end
      def flush_messages
      end
    end
  end
end
