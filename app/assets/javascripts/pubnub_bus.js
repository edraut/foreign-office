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
      message : function(m){subscription.callback(m)}
    });

  }
})
