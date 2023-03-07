/**
 * JavaScript de shared/transparency/warnings/_show_warning_sefaz_migration
 */

 $(function() {
    'use strict';
  
    verify_communication();
  
    function verify_communication(){
      
      var ouvidoria = window.location.href.indexOf('ouvidoria') 
      
      if ( ouvidoria<0 && _read_cookie("show_warning_sefaz_migration") == ''){
        _write_cookie("show_warning_sefaz_migration");
        _show_modal();
      }
      
    }
    
    function _show_modal(){
  
      $(document).ready( function() {
        $('#modalAlertTitle').html($('#modal_title').val());
        $('#modalAlert').find('.modal-body').html($('#modal_message').val());
        $('#modalAlert').modal('show');
        
      });
      
    }
    
    function _write_cookie(name){
  
      var now = new Date();
  
      var expireTime = new Date(now.setDate(now.getDate() + 1));
          
      document.cookie = name+"=true; expires="+expireTime.toUTCString();
    }
  
    function _read_cookie(nome) {
  
      var vnome = nome + "=";
  
      var ca = document.cookie.split(';');
  
      for(var i=0; i<ca.length; i++) {
        var c = ca[i];
        while (c.charAt(0)==' ') c = c.substring(1);
          if (c.indexOf(vnome) == 0) 
            return c.substring(vnome.length,c.length);
      }
  
      return "";
    }
  
    function _deleteCookie(name) {
  
      document.cookie = name+"=; expires=Thu, 01 Jan 1970 00:00:00 UTC";
  
    }
  
  });
  