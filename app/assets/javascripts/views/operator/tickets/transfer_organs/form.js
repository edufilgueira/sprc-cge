//= require modules/form/organ-select

/*
 * JavaScript de operator/tickets/transfer_organs/form (new, edit, create, update)
 */

$(function(){
'use strict';

  /// setup

  function _init() {
    new OrganSelect($(document));
  }

  _init();
});
