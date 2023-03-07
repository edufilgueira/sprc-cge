//= require ./state-select/state-select

$(function() {
'use strict';

  $('.state-select').each(function() {
    StateSelect($(this));
  });

});
