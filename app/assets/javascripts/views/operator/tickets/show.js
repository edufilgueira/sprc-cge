//= require modules/utils/content-utils

/*
 * JavaScript de operator/tickets/show
 */

$(function(){
'use strict';

  // globals

  var _domInternalStatus = $('[data-internal-status]'),
    _domTicketLogsContainer = $('[data-content="ticket_logs"]'),


    _domExtensionsContainer = $('[data-content=extensions-form]'),
    _remoteForm = new RemoteForm(_domExtensionsContainer),
    _positioningInput = $('[data-input=positioning]'),
    _contentUtils = new ContentUtils();


  // event handlers

  _domTicketLogsContainer.on('remote-form:after', function() {
    $.each(_domInternalStatus, function(aStatus) {
      _updateTicketStatus($(this));
    });

    _updatePositioningFields();
    $('[data-input=positioning]').on('click', _updatePositioningFields);
  });

  _domExtensionsContainer.on('remote-form:after', function() {
    if (_domExtensionsContainer.html() === '') {
      location.reload();
    }
  });

  _positioningInput.on('click', _updatePositioningFields);

  // privates

  function _updateTicketStatus (aStatus) {
    var ticketUrl = aStatus.data('internal-status');

    $.getJSON(ticketUrl, function(aData) {
      var internalStatus = aData.internal_status_str;

      aStatus.html(internalStatus);
    });
  }

  function _updatePositioningFields() {
    var positioningInput = $('[data-input=positioning]'),
      positioningContent = $('[data-content=positioning-fields]'),
      sectoralContent = $('[data-content=sectoral-fields]');

    if (positioningInput.is(':checked')) {
      _contentUtils.updateContent(positioningContent, 'show_and_enable')
      _contentUtils.updateContent(sectoralContent, 'hide_and_disable')
    } else {
      _contentUtils.updateContent(sectoralContent, 'show_and_enable')
      _contentUtils.updateContent(positioningContent, 'hide_and_disable')
    }
  }

  function _init() {
    _updatePositioningFields();
  }

  _init();

});
