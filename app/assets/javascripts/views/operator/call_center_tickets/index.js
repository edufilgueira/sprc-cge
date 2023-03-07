//= require components/table
/*
 * JavaScript de operator/call_center_tickets/index
 */
$(function(){
'use strict';

  // globals

  $(document).on('remote-content:after', function() {
    _init();
  });

  function _init() {
    CheckAll($('table'));
  }

  _init();
});
