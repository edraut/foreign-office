//Anytime loader, simulates load events for ajax requests
String.prototype.toCapCamel = function(){
  camel = this.replace(/[-_]([a-z])/g, function (g) { return g.replace(/[-_]/,'').charAt(0).toUpperCase(); });
  return camel.charAt(0).toUpperCase() + camel.slice(1);
};

var AnyTimeManager = Class.extend({
  init: function(){
    this.loader_array = []
  },
  register: function(data_attribute,load_method,base_class){
    this.loader_array.push({data_attribute: data_attribute, base_class: base_class, load_method: load_method});
  },
  registerList: function(list){
    var anytime_manager = this;
    $.each(list,function(){
      anytime_manager.register(this + '','instantiate',null)
    })
  },
  registerListWithClasses: function(list){
    var anytime_manager = this;
    $.each(list,function(attr,klass){
      anytime_manager.register(attr,'instantiate',klass)
    })
  },
  registerRunList: function(list){
    var anytime_manager = this;
    $.each(list,function(attr,method){
      anytime_manager.register(attr,method,null)
    })
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
      if(!base_class){
        base_class = data_attribute.toCapCamel();
      }
      var this_method = this['load_method'];
      $('[data-' + data_attribute + ']').each(function(){
        if('instantiate' == this_method){
          var declared_class = $(this).data('sub-type');
          var this_class = getSubClass(declared_class,base_class);
          any_time_manager.instantiate($(this),this_class);
        }else{
          any_time_manager.run($(this),base_class,this_method);
        }

      });
    });
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
