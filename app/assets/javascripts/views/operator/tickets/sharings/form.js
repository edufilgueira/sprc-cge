//= require modules/utils/content-utils
//= require modules/form/organs-select
//= require modules/form/rede-ouvir-organ-select

/*
 * JavaScript de operator/tickets/sharings/form (new, edit, create, update)
 */

$(function(){
'use strict';

  var _contentUtils = new ContentUtils();

  // event handlers

  $('form').on('cocoon:after-insert', _cocoonAfterInsert);

  // privates

  function _addOnChangeSouType(aSouTypeContainer) {
    var domTicketTypeWrapper = aSouTypeContainer.find('[data-content=sou_types]');

    domTicketTypeWrapper.on('change', function() {
      _updateTicketTypeContainer(aSouTypeContainer);
    });
  }

  function _updateTicketTypeContainer(aSouTypeContainer) {
    var domDenunciationToogle = aSouTypeContainer.find('[data-input=denunciation]'),
      domGeneralContent = aSouTypeContainer.find('.general-content'),
      domDenunciationContent = aSouTypeContainer.find('.denunciation-content');

    if(domDenunciationToogle.is(':checked')){
      _hideAndDisableContent(domGeneralContent);
      _showAndEnableContent(domDenunciationContent);
    } else{
      _hideAndDisableContent(domDenunciationContent);
      _showAndEnableContent(domGeneralContent);
    }
  }

  function _hideAndDisableContent(aContentValue) {
    _contentUtils.updateContent(aContentValue, 'hide_and_disable');
  }

  function _showAndEnableContent(aContentValue) {
    _contentUtils.updateContent(aContentValue, 'show_and_enable');
  }

  function _setupSouType(aContentValue){
    var souTypeContainer = $(aContentValue);

    _addOnChangeSouType(souTypeContainer);
    _updateTicketTypeContainer(souTypeContainer);
  }


  /// cocoon handlers

  function _cocoonAfterInsert(aEvent, aElement) {
    var domOrganContainer = $(aElement).find('[data-content=organ-container]'),
      domSouTypeContainer = $(aElement).find('[data-content=sou-type-container]');

    _setupSouType(domSouTypeContainer);

    new RedeOuvirOrganSelect($(aElement)).showSelectOrganCategory();
  }

  /// setup

  function _init() {
    var containers = new OrgansSelect($('[data-content=organs]')),
      souTypeContainers = $('.sou-type-content');

    souTypeContainers.each(function(aIndex, aSouTypeContainer) {
      _setupSouType(aSouTypeContainer);
    });

    new RedeOuvirOrganSelect($(document)).showSelectOrganCategory();
  }

  _init();
});