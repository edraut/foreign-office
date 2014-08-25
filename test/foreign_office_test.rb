require 'test_helper'

class ForeignOfficeTest < MiniTest::Unit::TestCase
  describe "ForeignOffice" do
    before do
      @bus = Minitest::Mock.new
      ForeignOffice.bus = @bus
    end
    describe "caches messages when asked" do
      before do
        ForeignOffice.cache_messages
      end
      it "caches multiple messages" do
        ForeignOffice.publish({channel: 'TestMe', object: {this: 'is a test'}})
        ForeignOffice.publish({channel: 'TestMeAgain', object: {this: 'is another test'}})
        RequestStore.store[:foreign_office_messages].length.must_equal 2
      end
      it "only caches the last message in each channel" do
        ForeignOffice.publish({channel: 'TestMe', object: {this: 'is a test'}})
        ForeignOffice.publish({channel: 'TestMe', object: {this: 'is another test'}})
        RequestStore.store[:foreign_office_messages]['TestMe'][:object][:this].must_equal 'is another test'
      end
      it "sends all cached messages to the bus when flushed" do
        ForeignOffice.publish({channel: 'TestMe', object: {this: 'is a test'}})
        ForeignOffice.publish({channel: 'TestMeAgain', object: {this: 'is another test'}})
        @bus.expect :publish, nil, [{channel: 'TestMe', object: {this: 'is a test'}}]
        @bus.expect :publish, nil, [{channel: 'TestMeAgain', object: {this: 'is another test'}}]
        ForeignOffice.flush_messages
        @bus.verify      
      end
    end
    describe "doesn't have to cache" do
      before do
        ForeignOffice.publish_directly
      end
      it "publishes messages directly when not caching" do
        @bus.expect :publish, nil, [{channel: 'TestMe', object: {this: 'is a test'}}]
        ForeignOffice.publish({channel: 'TestMe', object: {this: 'is a test'}})
        @bus.verify      
      end
    end
    describe "offers custom publishing" do
      it "publishes with a custom method if provided" do
        ForeignOffice.set_publish_method { |msg| p @bus.custom_publish msg }
        @bus.expect :custom_publish, nil, [{channel: 'TestMe', object: {this: 'is a test'}}]
        ForeignOffice.publish({channel: 'TestMe', object: {this: 'is a test'}})
        @bus.verify      
      end
    end
  end
end
