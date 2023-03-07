//= require views/shared/tickets/form

/*
 * JavaScript de operator/attendances/form (edit, update)
 */

$(function(){
'use strict';
  // globals

  var _domAttendanceType = $('[data-content=attendance_type]'),
    _domUnknownOrgan = $('[data-input=unknown_organ]'),
    _domAnswerType = $('[data-input=answer_type]'),
    _contentUtils = new ContentUtils(),
    _formContainer = $('form'),
    _userInfoHelper = new UserInfoHelper(_formContainer),
    _answerTypesToggle = new TicketAnswerTypesToggle(_domAnswerType);


  // event handlers


  /// usuário alterou o tipo do atendimento

  _domAttendanceType.on('change', function() {
    _init();
  });



  // privates

  function _updateTicketContainer() {
    var sicTicketOptions = ['sic_completed', 'sic_forward'],
        souTicketOptions = ['sou_forward', 'no_characteristic'];

    _contentUtils.updateContent('ticket', 'show_and_enable');

    _setSicCompletedContents();

    if (_contains(sicTicketOptions, _attendanceTypeValue())) {
      _contentUtils.updateContent('sou_only_fields', 'hide_and_disable');
      _contentUtils.updateContent('general_ticket_type_content', 'show_and_enable');
    } else if (_contains(souTicketOptions, _attendanceTypeValue())) {
      _contentUtils.updateContent('sou_only_fields', 'show_and_enable');
    } else {
      _contentUtils.updateContent('ticket', 'hide_and_disable');
    }

    _domUnknownOrgan.trigger('change');
  }

  function _updateAnswerContent() {
    var completed = ['sic_completed', 'no_characteristic'],
        status = _contains(completed, _attendanceTypeValue()) ? 'show_and_enable' : 'hide_and_disable';

    _contentUtils.updateContent('answer_content', status);
  }


  function _updateAvailablePersonTypeOptions() {
    switch (_attendanceTypeValue()) {
      case 'sic_forward':
      case 'sic_completed': {
        _userInfoHelper.hideAnonymousOption();
        break;
      }

      default: {
        _userInfoHelper.showAnonymousOption();
        break;
      }
    }
  }

  function _setSicCompletedContents() {
    var visibility = _isSicCompleted() ? 'hide_and_disable' : 'show_and_enable';

    _contentUtils.updateContent('unknown_organ', visibility);

    _setRequiredFieldsForSicCompleted();
  }

  function _setRequiredFieldsForSicCompleted() {
    var userInfoContainer = $('[data-content=identified]');

    userInfoContainer.find('.form-control-label abbr').each(function() {
      // Se for :sic_completed não é obrigatório dados do cidadão
      if (_isSicCompleted()) {
        $(this).hide();
      } else {
        $(this).show();
      }
    });
  }

  function _isSicCompleted() {
    return _attendanceTypeValue() === 'sic_completed';
  }

  function _attendanceTypeValue() {
    return _domAttendanceType.val();
  }

  function _contains(aList, aValue) {
    return (aList.indexOf(aValue) !== -1);
  }

  function _init() {
    _updateAnswerContent();
    _updateTicketContainer();
    _userInfoHelper.updatePersonType();
    _updateAvailablePersonTypeOptions();
  }

  _init();
});
