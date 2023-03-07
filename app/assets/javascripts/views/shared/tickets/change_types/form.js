//= require modules/utils/content-utils

$(function(){
  'use strict';

    // globals

    var _domTicketTypeWrapper = $('[data-content=sou_types]'),
        _domDenunciationToogle = $('[data-input=denunciation]'),
        _contentUtils = new ContentUtils();


    // event handlers

    /// usuário alterou o tipo da manifestação

    _domTicketTypeWrapper.on('change', function() {
      _updateTicketTypeContainer();
    });

    // privates

    function _updateTicketTypeContainer() {
      var contentId = 'denunciation_ticket_type_content';

      if (_domDenunciationToogle.is(':checked')) {
        _contentUtils.updateContent(contentId, 'show_and_enable');
      } else {
        _contentUtils.updateContent(contentId, 'hide_and_disable');
      }
    }

    /// setup

    function _init() {
      _updateTicketTypeContainer();
    }

    _init();
  });
