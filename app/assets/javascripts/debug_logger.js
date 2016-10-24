// This is a bit heavy for what it does, but should be super-easy to extend/enhance
if(typeof console == 'undefined'){
  console = {log: function(msg){alert(msg)}}
}
var DebugLogger = Class.extend({
  init: function($debug_settings){
    if($debug_settings.data('logging_on')){
      console.log('Debug logging turned on.')
      this.logging_on = true;
    } else {
      this.logging_on = false;
    }
  },
  log: function(msg){
    if(this.logging_on){
      console.log(msg)
    }
  }
})

debug_logger = {
  log: function(){}
}
$(document).ready(function(){
  if($('[data-debug_logger]')){
    jqobj = $('[data-debug_logger]');
    debug_logger = new DebugLogger(jqobj);
  }
})