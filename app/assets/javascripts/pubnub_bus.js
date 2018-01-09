var PubnubBus = Class.extend({
  init: function(config){
    var pubnubbus = this
    debug_logger.log("initializing pubnub js with client id: " + foreign_office.session_id, 1, 'foreign-office')
    this.pubnub = new PubNub({
      publish_key   : config.publish_key,
      subscribe_key : config.subscribe_key,
      ssl           : config.ssl,
      uuid          : foreign_office.session_id
    });
    window.onbeforeunload = function (e) {
      debug_logger.log("about to unload page", 1, 'foreign-office')
      pubnubbus.unsubscribe()
    };
    this.pubnub.addListener({
      message : function(m){
        foreign_office.handleMessage(m)
      },
      status: function(s){
        debug_logger.log("Foreign Office PubnubBus:", 1, 'foreign-office')
        debug_logger.log(s, 1, 'foreign-office')
        if( s.operation === 'PNUnsubscribeOperation' ||
            s.operation === 'PNSubscribeOperation'){return}

        if( s.category === 'PNTimeoutCategory' ||
            s.category === 'PNUnexpectedDisconnectCategory' ||
            s.category === 'PNNetworkIssuesCategory' ||
            s.category === 'PNNetworkDownCategory'){
          debug_logger.log("Network disconnected.", 1, 'foreign-office')
          foreign_office.disconnection(); debug_logger.log('Lost connection to: ', 1, 'foreign-office'); debug_logger.log(subscription.channel, 1, 'foreign-office')
        }
        if( s.category === 'PNReconnectedCategory' ||
            s.category === 'PNNetworkUpCategory'){
          foreign_office.reconnection(); debug_logger.log('Reestablished connection to: ', 1, 'foreign-office'); debug_logger.log(subscription.channel, 1, 'foreign-office')
        }
        if(s.category === 'PNConnectedCategory'){
          foreign_office.connect(); debug_logger.log("Connected to: ", 1, 'foreign-office'); debug_logger.log(subscription.channel, 1, 'foreign-office')
        }
      }
    });
  },
  subscribe: function(subscription){
    debug_logger.log("subscribing with PubnubBus", 1, 'foreign-office')
    debug_logger.log(subscription, 1, 'foreign-office')
    this.pubnub.subscribe({
      channels : [subscription.channel]
    });
  },
  unsubscribe: function(){
    debug_logger.log("unsubscribing all pubnub channels", 1, 'foreign-office')
    this.pubnub.unsubscribeAll();
  }
})
PubnubBus.third_party_library = 'PubNub'