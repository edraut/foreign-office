var PusherBus = Class.extend({
  init: function(config){
    delete config.bus_name
    var key = config.key
    delete config.key
    this.pusher = new Pusher(key, config);
  },
  subscribe: function(subscription){
    this.channel = this.pusher.subscribe(this.get_channel_name(subscription.channel));
    this.channel.bind('publish', function(data){
      subscription.callback(data);
    })
  },
  get_channel_name: function(channel_name){
    return channel_name.replace(/::/g, '.')
  },
  bind_state_change: function(){
    this.pusher.connection.bind( 'error', function( err ) {
      debug_logger.log(err.error)
    })

    this.pusher.connection.bind('state_change', function(states) {
      // states = {previous: 'oldState', current: 'newState'}
      debug_logger.log("Pusher connection current state is " + states.current, 1, 'foreign-office');
      if('unavailable' == states.current){
        reload_page()
      }
    });
  }

});

var reload_page = function(){
  if (
    window.confirm('The pusher connection has been lost. Click ok to refresh the page.')
  ) { window.location.reload()}
};

PusherBus.third_party_library = 'Pusher'