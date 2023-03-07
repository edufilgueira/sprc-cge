//= require modules/utils/content-utils

/**
 * JavaScript para form de departments
 */

$(function() {

  var _domFromSubnetInput = $('[data-input=from-subnet]'),
      _contentUtil = new ContentUtils();

  _domFromSubnetInput.on('change', function() {
    _updateSubnetStates();
  });

  // Privates

  function _updateSubnetStates() {
    var subnet = _domFromSubnetInput.is(':checked');

    if (subnet) {
      _contentUtil.updateContent('organ', 'hide_and_disable');
      _contentUtil.updateContent('subnet', 'show_and_enable');
    } else {
      _contentUtil.updateContent('organ', 'show_and_enable');
      _contentUtil.updateContent('subnet', 'hide_and_disable');

    }
  }

  function _init() {
    _updateSubnetStates();
  }

  _init();

});
