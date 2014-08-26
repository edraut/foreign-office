//= require debug_logger
var ForeignOffice = Class.extend({
  init: function(){
    this.pubnub = PUBNUB.init({
      publish_key   : 'pub-c-1146120f-14f7-4649-9dee-3b21a519d573',
      subscribe_key : 'sub-c-9d1b308c-a5f1-11e2-87b3-12313f022c90',
      ssl           : true
    });
    this.channels = [];
    this.channels_by_name = [];
  },
  connection: function(){
    return this.pubnub;
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
    foreign_office.connection().subscribe({
      channel : channel_name,
      backfill: true,
      message : function(m){
        debug_logger.log("Got a message: ");
        debug_logger.log(m);
        $.each(foreign_office_channel.listeners,function(i,listener){
          debug_logger.log("sending message to listener: ");
          debug_logger.log(listener);
          listener.handleMessage(m);
        });
      }
    });
    this.channel_name = channel_name;
    this.listeners = [];
  },
  addListener: function(listener){
    this.listeners.push(listener);
  }
});

var ForeignOfficeListener = Class.extend({
  init: function($listener){
    this.$listener = $listener;
    this.endpoint = $listener.data('endpoint');
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
    }else{
      var new_value = m.object[this.object_key];
      switch(this.$listener.get(0).nodeName.toLowerCase()){
        case 'input': case 'select':
          this.$listener.val(new_value);
        break;

        case 'a':
          if(this.$listener.data('trigger-on-message')){
            this.$listener.attr('href',new_value);
            if(this.progress_indicator){
              this.progress_indicator.stop();
            }
            if(this.$listener.data('ajax_link')){
              this.$listener.trigger('click');
            }else{
              window.location = new_value;
            }
          }else{
            this.$listener.html(new_value);
          }
        break;

        case 'img':
          this.$listener.prop('src',new_value);
        break;

        default:
          this.$listener.html(new_value);
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

var ForeignOfficeRevealer = ForeignOfficeListener.extend({
  handleMessage: function(m){
    var current_value = m.object[this.object_key];
    if(!current_value || current_value == 'false' || current_value == 'hide'){
      this.$listener.hide();
    } else if(current_value == true || current_value == 'true' || current_value == 'show'){
      this.$listener.removeClass('hidden');
      this.$listener.show();
    }
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

//Anytime loader, needs to be extracted into its own library

var AnyTimeManager = Class.extend({
  init: function(){
    this.loader_array = []
  },
  register: function(data_attribute,base_class,load_method){
    this.loader_array.push({data_attribute: data_attribute, base_class: base_class, load_method: load_method});
  },
  instantiate: function(jq_obj, class_name){
    if(!jq_obj.data('anytime_loaded')){
      jq_obj.data('anytime_loaded',true);
      var this_class = eval(class_name);
      new this_class(jq_obj);
    }
  },
  run: function (jq_obj, resource, method_name){
    if(!jq_obj.data('anytime_run')){
      jq_obj.data('anytime_run',true);
      resource[method_name](jq_obj);
    }
  },
  load: function(){
    var any_time_manager = this;
    $.each(any_time_manager.loader_array,function(){
      var data_attribute = this['data_attribute'];
      var base_class = this['base_class'];
      var this_method = this['load_method'];
      $('[data-' + data_attribute + ']').each(function(){
        if('instantiate' == this_method){
          var declared_class = $(this).data(data_attribute);
          var this_class = getSubClass(declared_class,base_class);
          any_time_manager.instantiate($(this),this_class);
        }else{
          any_time_manager.run($(this),base_class,this_method);
        }

      });
    });
  }
});
var AnytimeLoader = Class.extend({
  init: function(jq_obj){
    this.jq_obj = jq_obj;
    jq_obj.data('anytime_loaded',true);
  }
});
any_time_manager = new AnyTimeManager();
$(document).ajaxComplete(function(){
  any_time_manager.load();
});
$(document).ready(function(){
  any_time_manager.load();
});

// End AnyTime library

any_time_manager.register('listener',foreign_office,'addListener');
