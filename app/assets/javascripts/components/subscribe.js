$(function() {
  'use strict';


  $(document).on('ajax:success', '[data-container=follow]', function(aEvent, aData) {
    $(this).html(aData);
  });

});
