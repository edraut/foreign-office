var PusherBus = Class.extend({
  init: function(config){
    delete config.bus_name
    var key = config.key
    delete config.key
    this.pusher = new Pusher(key, config);
  },
  subscribe: function(subscription){
    this.channel = this.pusher.subscribe(subscription.channel);
    this.channel.bind('publish', function(data){
      subscription.callback(data);
    })
  }
})
PusherBus.third_party_library = 'Pusher'