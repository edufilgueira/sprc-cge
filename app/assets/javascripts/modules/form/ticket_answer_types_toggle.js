function TicketAnswerTypesToggle(aContainer) {
'use strict';

  var self = this,
      _domAnswerType = aContainer,
      _domAnswerTypePhone = _domAnswerType.find('[data-input=answer_type_phone]'),

      _contentUtils = new ContentUtils();


  /* API pública */

  self.showAnswerTypePhone = _showAnswerTypePhone;

  self.hideAnswerTypePhone = _hideAnswerTypePhone;

  /* private */

  function _showAnswerTypePhone(disabled) {
    _domAnswerTypePhone.show();
    _contentUtils.updateContent('answer_type_phone', 'show_and_enable');

    if (_domAnswerType.find('input[type=radio]:checked').length === 0) {
      _phoneChecked(true);
    }

    _phoneDisabled(disabled);
  }

  function _hideAnswerTypePhone(disabled) {
    _domAnswerTypePhone.hide();
    _contentUtils.updateContent('answer_type_phone', 'hide_and_disable');
    _phoneChecked(false);
    _phoneDisabled(disabled);
  }

  function _phoneChecked(checked) {
    _domAnswerTypePhone.find('input[type=radio]').prop('checked', checked);
  }

  function _phoneDisabled(disabled) {
    _domAnswerTypePhone.find('input[type=radio]').prop('disabled', disabled);
  }
}
