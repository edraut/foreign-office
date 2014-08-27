var PubnubBus = Class.extend({
  init: function(config){
    this.pubnub = PUBNUB.init({
      publish_key   : config.publish_key,
      subscribe_key : config.subscribe_key,
      ssl           : config.ssl
    });
  },
  subscribe: function(subscription){
    this.pubnub.subscribe({
      channel : subscription.channel,
      backfill: true,
      message : function(m){subscription.callback(m)}
    });

  }
})
