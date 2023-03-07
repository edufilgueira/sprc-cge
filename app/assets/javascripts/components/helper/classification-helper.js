function ClassificationHelper(aContainer) {
  'use strict';

  var self = this,
    _domContainer = aContainer,
    _domOtherOrgans = _domContainer.find('[data-input=other_organs]'),
    _domUnknownClassification = _domContainer.find('[data-input=unknown_classification]'),

    _contentUtils = new ContentUtils();


  // events

  _domOtherOrgans.on('change', function() {
    _setVisibility();
  });

  _domUnknownClassification.on('change', function() {
    _setVisibility();
  });


  // private

  function _isOtherOrgansChecked() {
    return _domOtherOrgans.is(':checked');
  }

  function _isUnknownClassificationChecked() {
    return _domUnknownClassification.is(':checked');
  }

  function _setVisibility() {
    var showContents = [],
      hideContents = [];
    if (_isOtherOrgansChecked()) {
      showContents.push('classification_other_organs', 'classification_other_organs_input');
      hideContents.push('classification_default', 'unknown_classification');
    } else if (_isUnknownClassificationChecked()) {
      showContents.push('unknown_classification');
      hideContents.push('classification_default', 'classification_other_organs', 'classification_other_organs_input');
    } else {
      showContents.push('classification_default','unknown_classification', 'classification_other_organs_input');
      hideContents.push('classification_other_organs');
    }

    _contentUtils.updateContents(showContents, 'show_and_enable');
    _contentUtils.updateContents(hideContents, 'hide_and_disable');
  }

  function _init() {
    _setVisibility();
  }

  _init();
}
