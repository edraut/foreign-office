var PubnubBus = Class.extend({
  init: function(config){
    debug_logger.log("initializing pubnub js")
    this.pubnub = PUBNUB.init({
      publish_key   : config.publish_key,
      subscribe_key : config.subscribe_key,
      ssl           : config.ssl
    });
  },
  subscribe: function(subscription){
    debug_logger.log("subscribing with PubnubBus")
    debug_logger.log(subscription)
    this.pubnub.subscribe({
      channel : subscription.channel,
      restore : true,
      disconnect : function(){foreign_office.disconnection(); debug_logger.log('Lost connection to: '); debug_logger.log(subscription.channel)},
      reconnect : function(){foreign_office.reconnection(); debug_logger.log('Reestablished connection to: '); debug_logger.log(subscription.channel)},
      connect : function(){foreign_office.connect(); debug_logger.log("Connected to: "); debug_logger.log(subscription.channel)},
      message : function(m,env,channel){subscription.callback(m)}
    });

  }
})
PubnubBus.third_party_library = 'PUBNUB'