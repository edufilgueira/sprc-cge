$(function(){
'use strict';

  $('.btn-privacy-grant').click(function(event) {
    var now = new Date();
    var time = now.getTime();
    var expireTime = time + 1000*36000*24*3*3; 
    now.setTime(expireTime);
        
    document.cookie = "grant_privacy_statement=true; expires="+now.toUTCString();

    $('.privacy_statement').fadeOut();
  });
  
});
