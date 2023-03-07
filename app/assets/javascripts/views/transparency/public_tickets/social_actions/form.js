$(function(){
'use strict';

  var domSocialActions = $('[data-content=social-actions]'),
    domForms = null;


  function _attachEvents() {
    domForms = domSocialActions.find('form');

    domForms.on('ajax:success', function(aEvent, aData) {
      domSocialActions.html(aData);
      _attachEvents();
    });
  }

  function _init() {
    _attachEvents();
  }

  _init();

});
