//= require debug_logger
//= require pubnub_bus
//= require pusher_bus
//= require test_bus
//= require anytime_manager

var ForeignOffice = Class.extend({
  init: function(){
    this.channels = [];
    this.channels_by_name = [];
  },
  config: function(config){
    bus_class = eval(config.bus_name);
    try {
      eval(bus_class.third_party_library)
    }
    catch(err){
      bus_class = TestBus
    }
    this.bus = new bus_class(config);
  },
  addListener: function($listener){
    var listener_class = eval(getSubClass($listener.data('listener'),'ForeignOfficeListener'));
    var listener = new listener_class($listener);
    var this_channel;
    if($.inArray(listener.channel,this.channelNames()) == -1){
      this_channel = new ForeignOfficeChannel(listener.channel)
      this.channels.push(this_channel);
      this.channels_by_name[listener.channel] = this_channel;
    } else {
      var this_channel = this.channels_by_name[listener.channel];
    }
    this_channel.addListener(listener);
  },
  channelNames: function(){
    return $.map(this.channels,function(channel){return channel.channel_name});
  }
});

foreign_office = new ForeignOffice();

var ForeignOfficeChannel = Class.extend({
  init: function(channel_name){
    var foreign_office_channel = this;
    debug_logger.log("Subscribing to: ");
    debug_logger.log(channel_name);
    foreign_office.bus.subscribe({
      channel : channel_name,
      callback : function(m){
        foreign_office_channel.handleMessage(m)
      }
    });
    this.channel_name = channel_name;
    this.listeners = [];
  },
  handleMessage: function(m){
    debug_logger.log("Got a message: ");
    debug_logger.log(m);
    $.each(this.listeners,function(i,listener){
      debug_logger.log("sending message to listener: ");
      debug_logger.log(listener);
      listener.handleMessage(m);
    })
  },
  addListener: function(listener){
    this.listeners.push(listener);
  }
});

var ForeignOfficeListener = Class.extend({
  init: function($listener){
    this.$listener = $listener;
    this.endpoint = $listener.data('endpoint');
    this.reveal_hide = $listener.data('reveal-hide');
    this.object_key = $listener.data('key');
    this.delete_key = $listener.data('delete-key');
    this.channel = $listener.data('channel');
    if(this.$listener.data('progress-indicator')){
      this.progress_indicator = new AjaxProgress(this.$listener);
    }
  },
  handleMessage: function(m){
    var $listener = this.$listener;
    if(this.endpoint){
      if (m.object[this.object_key] == true) {
        $.get(this.endpoint, function(data){
          $listener.html(data);
        })
      }
      if (m.object[this.delete_key] == true) {
        $listener.remove;
      }
    }else if(this.reveal_hide){
      var current_value = m.object[this.object_key];
      if(!current_value || current_value == 'false' || current_value == 'hide'){
        this.$listener.hide();
      } else {
        this.$listener.removeClass('hidden');
        this.$listener.show();
      }
    }else{
      var new_value = m.object[this.object_key];
      switch(this.$listener.get(0).nodeName.toLowerCase()){
        case 'input': case 'select':
          this.$listener.val(new_value);
        break;

        case 'img':
          this.$listener.prop('src',new_value);
        break;

        default:
          if(this.$listener.data('trigger-on-message')){
            if(new_value){
              this.$listener.attr('href',new_value);
              if(this.progress_indicator){
                this.progress_indicator.stop();
              }
              if(this.$listener.data('ajax-link')){
                this.$listener.trigger('click');
              }else{
                window.location = new_value;
              }
            }
          }else{
            this.$listener.html(new_value);
          }
        break;
      }
    }
    this.getForeignOfficeProgressIndicator();
    this.removeProgressIndicator();
  },
  getForeignOfficeProgressIndicator: function(){
    var this_listener = this;
    $('[data-foreign-office-progress-indicator="' + this.channel + '"]').each(function(){
      this_listener.foreign_office_progress_indicator = $(this).data('foreign-office-progress-indicator-object');
      this_listener.foreign_office_flash = $(this).data('ajax-foreign-office-flash').notice;
    })
  },
  removeProgressIndicator: function(){
    if(this.foreign_office_progress_indicator){
      this.foreign_office_progress_indicator.stop();
      if(this.foreign_office_flash){
        new AjaxFlash('success',this.foreign_office_flash,this.$listener);
      }
    }
  }
});

var ForeignOfficeNewListItems = ForeignOfficeListener.extend({
  handleMessage: function(m){
    var $listener = this.$listener;
    $.get(m.object[this.object_key], function(data){
      $listener.append(data);
    })
  }
});

var ForeignOfficeColor = ForeignOfficeListener.extend({
  handleMessage: function(m){
     var new_value = m.object[this.object_key];
     this.$listener.html(new_value);
     if(new_value == "Yes") {
        this.$listener.removeClass('red').addClass('green');
     } else {
        this.$listener.removeClass('green').addClass('red');
     }
  }
});

any_time_manager.register('listener','addListener',foreign_office);
