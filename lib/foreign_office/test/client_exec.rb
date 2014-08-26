module ForeignOffice
  module Test
    module ClientExec
      def fetch_foreign_office_messages
        push_data = File.read(Rails.root + 'tmp/foreign_office_rspec_cache.json')
        push_data = push_data.split('IH_FO_MESSAGE_SEPARATOR')
        push_data.map!{|msg| JSON.parse msg}
        File.delete(Rails.root + 'tmp/foreign_office_rspec_cache.json')
        if page.has_css?('[data-listener]')
          page.all(:css, '[data-listener]').each do |el|
            messages = push_data.select{|msg| msg['channel'] == el[:'data-channel']}
            message = messages.last
            if message
              page.execute_script("foreign_office.channels_by_name['#{el[:'data-channel']}'].handleMessage(#{message.to_json});")
            end
          end
        end
      end
    end
  end
end

RSpec.configure do |config|
  config.include ForeignOffice::Test::ClientExec, type: :feature
end