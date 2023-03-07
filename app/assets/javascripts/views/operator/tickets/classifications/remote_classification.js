//= require modules/helpers/ticket-classification-helper
//= require modules/remote-content-show

$(function() {
'use strict';

  var _domRemoteContent = $('#remote-child-classification'),
    _domDataRemoteContent = $('[data-remote-content=organs_classification]'),
    _domOrganInput = $('[data-input=organs_classification]'),
    _buttons = ['[data-input=edit_classification]', '[data-input=cancel_classification]'],
    _classificationHelper = null,
    _domTicketHistoryContainer = $("[data-content='ticket_history']"),
    _domTicketHistoryUrl = _domTicketHistoryContainer.data('content-url');

  _domOrganInput.on('change', function() {
     _setUrlAjax($(this).find('option:selected'));
  });

  _domDataRemoteContent.on('remote-content:after', function() {
    _classificationHelper = new TicketClassificationHelper($(this));

    $(_buttons).each(function() {
      $(this).on('click', function() {
        _setUrlAjax($(this));
      });
    });

    _updateTicketHistory();
  });

  function _setUrlAjax(element){
    _domRemoteContent.data('url', element.data('url'));
    var remoteContent = new RemoteContentShow(_domRemoteContent);
  }

  function _updateTicketHistory () {
    if (! _domTicketHistoryUrl) return;

    $.get(_domTicketHistoryUrl, function(aData) {
      _domTicketHistoryContainer.html(aData);
    });
  }

  function _init() {
    _setUrlAjax(_domOrganInput.find('option:selected'));
  }

  _init();
});
