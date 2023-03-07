//= require modules/utils/content-utils

function AnswerForm(aContainer) {

  var _domContainer = aContainer,

    _domClassification = _domContainer.find('[data-input=answer_classification]'),
    _domAnswerType = _domContainer.find('[data-input=answer_type]'),

    _contentUtils = new ContentUtils();

  // events

  _domClassification.on('change', function() {
    _setAnswerCertificateVisiblity();
  });

  // private

  function _enableAnswerTypeSelect() {
    _contentUtils.updateInput(_domAnswerType, false);

  }

  function _disableAnswerTypeSelect() {
    _setAnswerTypeAsPartial();
    _contentUtils.updateInput(_domAnswerType, true);
  }

  function _setAnswerTypeAsPartial() {
    _domAnswerType.val('partial');
    _domAnswerType.change();
  }

  function _setAnswerCertificateVisiblity() {
    var classification = _domClassification.val(),
      visibility = /rejected/.test(classification) ? 'show_and_enable' : 'hide_and_disable';

    _contentUtils.updateContent('answer_certificate', visibility);
  }

  function _init() {
    _setAnswerCertificateVisiblity();
  }

  _init();
}
