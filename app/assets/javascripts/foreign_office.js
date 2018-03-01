//= require debug_logger
//= require pubnub_bus
//= require pusher_bus
//= require test_bus

var ForeignOffice = Class.extend({
  init: function(){
    this.channels = [];
    this.channels_by_name = [];
    this.session_id = $('meta[name="client_id"]').attr('content')
  },
  config: function(config){
    debug_logger.log("Using Foreign Office js config:")
    debug_logger.log(config);
    bus_class = eval(config.bus_name);

    try {
      bus_class_name = bus_class.third_party_library
      eval(bus_class_name)
    }
    catch(err){
      console.log('WARNING: ' + bus_class.third_party_library + ' is not defined!')
      bus_class_name = 'TestBus'
      bus_class = TestBus
    }
    debug_logger.log("Connecting to message bus using " + bus_class_name)
    this.bus = new bus_class(config);
    if(typeof config.disconnect_alert != 'undefined'){
      this.disconnect_alert = config.disconnect_alert
    } else {
      this.disconnect_alert = 'We lost the connection to the server. No refresh data will be available. Thanks, -the Foreign Office.'
    }
    if(typeof config.reconnect_alert != 'undefined'){
      this.reconnect_alert = config.reconnect_alert
    } else {
      this.reconnect_alert = "We're connected to the server again. Refresh data will now be available. Thanks, -the Foreign Office."
    }
  },
  addListener: function($listener){
    var listener_class = eval(getSubClass($listener.data('listener'),'ForeignOfficeListener'));
    var listener = new listener_class($listener);
    var this_channel;
    var this_foreign_office = this;
    if($.inArray(listener.channel,this_foreign_office.channelNames()) == -1){
      this_channel = new ForeignOfficeChannel(listener.channel)
      this_foreign_office.channels.push(this_channel);
      this_foreign_office.channels_by_name[listener.channel] = this_channel;
    } else {
      var this_channel = this_foreign_office.channels_by_name[listener.channel];
    }
    this_channel.addListener(listener);
  },
  removeListener: function($listener){
    var listener = $listener.data('foreign_office.ForeignOfficeListener');
    listener.getChannelObject().removeListener(listener)
  },
  channelNames: function(){
    return $.map(this.channels,function(channel){return channel.channel_name});
  },
  connect: function(){
    this.connection_status = 'connected';
  },
  disconnection: function(){
    if('connected' == this.connection_status){
      this.connection_status = 'disconnected'
      alert(this.disconnect_alert)
    }
  },
  reconnection: function(){
    if('disconnected' == this.connection_status){
      this.connection_status = 'connected'
      alert(this.reconnect_alert)
    }
  },
  //If the bus broadcasts the channel as part of the message...
  handleMessage: function(m){
    this.channels_by_name[m.channel].handleMessage(m.message)
  },
  bind_listeners: function(){
    window.any_time_manager.register('listener','addListener',this);
    window.any_time_manager.load();
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
      //If the bus binds the callback to the channel object...
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
    //need to ensure forms are last in the list, so that inputs
    //will be updated before forms are submitted
    //NB. this will only work if the form and its inputs share the same channel
    //since we can't control the order of channel messages coming across the wire
    this.listeners.sort(function(a,b){
      var a_kind = a.$listener.get(0).nodeName.toLowerCase()
      var b_kind = b.$listener.get(0).nodeName.toLowerCase()
      if(('form' != a_kind) && ('form' == b_kind)){
        return -1
      }
      if(('form' == a_kind) && ('form' != b_kind)){
        return 1
      }
      return 0 //('form' == a_kind) && ('form' == b_kind)
    })
  },
  removeListener: function(listener){
    listener_index = this.listeners.indexOf(listener)
    this.listeners.splice(listener_index,1)
  }
});

var ForeignOfficeListener = Class.extend({
  init: function($listener){
    this.$listener = $listener;
    $listener.data('foreign_office.ForeignOfficeListener',this)
    this.endpoint = $listener.data('endpoint');
    this.reveal_hide = $listener.data('reveal-hide');
    this.object_key = $listener.data('key');
    this.delete_key = $listener.data('delete-key');
    this.href_target = $listener.data('href-target');
    this.create_modal = $listener.data('create-modal');
    this.mask_me = $listener.data('mask-me');
    this.channel = $listener.data('channel');
    if(this.$listener.data('progress-indicator')){
      this.progress_indicator = new thin_man.AjaxProgress(this.$listener);
    }
  },
  maskMe: function(){
    if(this.mask_me)
    this.mask = new thin_man.AjaxMask(this.$listener,'')
  },
  unMaskMe: function(){
    if(this.mask){
      this.mask.remove()
      delete this.mask
    }
  },
  handleMessage: function(m){
    var $listener = this.$listener;
    var listener = this
    if(!m.object.hasOwnProperty(this.object_key) && !m.object.hasOwnProperty(this.delete_key)){
      return true
    }
    if(this.endpoint){
      if (m.object[this.object_key] == true) {
        listener.maskMe()
        $.get(this.endpoint, function(data){
          $listener.html(data);
        }).always(function(){
          listener.unMaskMe()
        })
      }else if(m.object[this.object_key] == false) {
        $listener.empty();
      }else if(typeof(m.object[this.object_key]) == 'string'){
        listener.maskMe()
        $.get(m.object[this.object_key], function(data){
          $listener.html(data);
        }).always(function(){
          listener.unMaskMe()          
        })
      }
      if (m.object[this.delete_key] == true) {
        $listener.remove();
      }
    }else if(this.reveal_hide){
      var current_value = m.object[this.object_key];
      if(!current_value || current_value == 'false' || current_value == 'hide'){
        this.$listener.hide();
      } else {
        this.$listener.removeClass('hidden');
        this.$listener.show();
      }
    }else if(this.href_target){
      this.$listener.attr('href',m.object[this.object_key])
    }else if(this.create_modal){
      if (m.object[this.object_key] == true) {
        var $modal_content = $('<div>').html($(this.create_modal).html());
        var modal = new hooch.Modal($modal_content);
        modal.$dismisser.remove();
        delete modal.dismisser;
        delete modal.$dismisser;
      }
    }else{
      var new_value = m.object[this.object_key];
      switch(this.$listener.get(0).nodeName.toLowerCase()){
        case 'input':
          if(this.$listener.attr('type') == 'checkbox'){
            this.$listener.prop('checked', new_value);
          } else {
            this.$listener.val(new_value);
          }
        break;
        case 'select':
          if(this.$listener.val() != ('' + new_value)){
            this.$listener.val('' + new_value).change()
          }
          this.$listener.trigger("chosen:updated")
        break;

        case 'img':
          this.$listener.prop('src',new_value);
        break;

        case 'progress':
          this.$listener.attr('value',new_value)
        break;

        default:
          if(this.$listener.data('trigger-on-message') || this.$listener.data('download')){
            if(new_value && (new_value != 'false')){
              if((new_value != true) && (new_value != 'true')){
                this.$listener.attr('href',new_value);
              }
              if(this.progress_indicator){
                this.progress_indicator.stop();
              }
              if(this.$listener.data('ajax-link')){
                this.$listener.trigger('apiclick');
              }else if(this.$listener.data('ajax-form')){
                this.$listener.trigger('apisubmit');
              }else if(this.$listener.data('download')){
                window.open(new_value);
              }else{
                window.location = new_value;
              }
            }
          }else if (m.object[this.delete_key] == true) {
            $listener.remove();
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
    $('[data-foreign-office-progress-indicator][data-channel="' + this.channel + '"][data-key="' + this.object_key + '"]').each(function(){
      this_listener.$foreign_office_progress_indicator = $(this);
    })
  },
  getChannelObject: function(){
    return foreign_office.channels_by_name[this.channel];
  },
  removeProgressIndicator: function(){
    if(this.$foreign_office_progress_indicator){
      this.$foreign_office_progress_indicator.remove()
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
