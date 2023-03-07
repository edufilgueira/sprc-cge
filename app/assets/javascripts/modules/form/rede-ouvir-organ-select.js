//= require modules/utils/content-utils

/**
 * JavaScript para controlar seleção da categorias do select de órgãos com base no checkbox do rede ouvir
 */
function RedeOuvirOrganSelect(aContainer) {
'use strict';


  // globals

  var self = this,
    _domContainer = aContainer;

  var _contentUtils = new ContentUtils();


  // public

  self.showSelectOrganCategory = function() {
    _showSelectOrganCategory(_domContainer);
  };


  // privates

  function _showSelectOrganCategory(aContent) {
    var redeOuvirInputs = aContent.find('[data-input=rede_ouvir]');

    redeOuvirInputs.each(function() {
      var redeOuvirInput = $(this);

      _showHideOrganType(redeOuvirInput);

      redeOuvirInput.on('change', function() {
        var redeOuvirInputChanged = $(this);

        _showHideOrganType(redeOuvirInputChanged);
      });
    });
  }

  function _showHideOrganType(aInputRedeOuvirOrgan) {
    var inputRedeOuvirOrgan = aInputRedeOuvirOrgan,
        organsContent = inputRedeOuvirOrgan.parents('[data-content=organ]'),
        contentRedeOuvirOrgan = organsContent.find('[data-content=rede_ouvir]'),
        contentExecutiveOrgan = organsContent.find('[data-content=executive_organ]');

    if (inputRedeOuvirOrgan.prop('checked')) {
      _hideAndDisableContent(contentExecutiveOrgan);
      _showAndEnableContent(contentRedeOuvirOrgan);
    } else {
      _hideAndDisableContent(contentRedeOuvirOrgan);
      _showAndEnableContent(contentExecutiveOrgan);
    }
  }

  function _hideAndDisableContent(aContentValue) {
    _contentUtils.updateContent(aContentValue, 'hide_and_disable');
  }

  function _showAndEnableContent(aContentValue) {
    _contentUtils.updateContent(aContentValue, 'show_and_enable');
  }


  // setup

  function _init() {
    _showSelectOrganCategory($(document));
  }

  _init();
}
