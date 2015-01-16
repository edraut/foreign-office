var PusherBus = Class.extend({
  init: function(config){
    this.pusher = new Pusher(config.key);
  },
  subscribe: function(subscription){
    this.channel = this.pusher.subscribe(subscription.channel);
    this.channel.bind('publish', function(data){
      subscription.callback(data);
    })
  }
})
PusherBus.third_party_library = 'Pusher'