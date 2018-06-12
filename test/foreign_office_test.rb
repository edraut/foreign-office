require 'test_helper'

class ForeignOfficeTest < MiniTest::Unit::TestCase
  describe "ForeignOffice" do
    describe "caches messages when asked" do
      before do
        @bus = Minitest::Mock.new
        ForeignOffice.bus = @bus
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
        @bus = Minitest::Mock.new
        ForeignOffice.bus = @bus
      end
      it "publishes messages directly when not caching" do
        ForeignOffice.publish_directly
        @bus.expect :publish, nil, [{channel: 'TestMe', object: {this: 'is a test'}}]
        ForeignOffice.publish({channel: 'TestMe', object: {this: 'is a test'}})
        @bus.verify
      end
    end
    describe "offers custom publishing" do
      before do
        @bus = Minitest::Mock.new
        ForeignOffice.bus = @bus
      end
      it "publishes with a custom method if provided" do
        ForeignOffice.publish_directly
        @bus.expect :custom_publish, nil, [{channel: 'TestMe', object: {this: 'is a test'}}]
        ForeignOffice.set_publish_method { |msg| @bus.custom_publish msg}
        ForeignOffice.publish({channel: 'TestMe', object: {this: 'is a test'}})
        @bus.verify
        ForeignOffice.unset_publish_method
      end
    end
    describe "passing browser tab id to pusher" do
      before do
        ForeignOffice.unset_publish_method
        ForeignOffice.publish_directly
      end

      it "publishes with browser id appended" do
        ForeignOffice.config({bus: {klass: ForeignOffice::Busses::PusherBus}})
        resp = ForeignOffice.publish({channel: "TestMe", object: {this: 'is a test'}, browser_tab_id: 'tab-id-123'})
        resp[:channel].must_equal("TestMe@tab-id-123")
      end

      it "published without browser id appended" do
        ForeignOffice.config({bus: {klass: ForeignOffice::Busses::PusherBus}})
        resp = ForeignOffice.publish({channel: "TestMe", object: {this: 'is a test'}})
        resp[:channel].must_equal("TestMe")
      end
    end
    describe "passing browser tab id to pubnub" do
      before do
        ForeignOffice.unset_publish_method
        ForeignOffice.publish_directly
      end

      it "published with browser id appended" do
        ForeignOffice.config(
          {
            bus: {
              klass: ForeignOffice::Busses::PubnubBus, 
              publish_key: "1234", 
              subscribe_key: '5678', 
              secret_key: '91011'
            }
          }
        )
        resp = ForeignOffice.publish({channel: "TestMe", object: {this: 'is a test'}, browser_tab_id: 'tab-id-123'})
        resp[:channel].must_equal "TestMe@tab-id-123"
      end
      it "published without browser id appended" do
        ForeignOffice.config(
          {
            bus: {
              klass: ForeignOffice::Busses::PubnubBus, 
              publish_key: "1234", 
              subscribe_key: '5678', 
              secret_key: '91011'
            }
          }
        )
        resp = ForeignOffice.publish({channel: "TestMe", object: {this: 'is a test'}})
        resp[:channel].must_equal "TestMe"
      end
    end
  end
end
