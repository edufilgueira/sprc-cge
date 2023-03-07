//= require modules/helpers/user-info-helper
//= require modules/helpers/ticket-classification-helper
//= require modules/helpers/ticket-answer-completed-helper
//= require modules/utils/content-utils
//= require modules/address-filler
//= require modules/form/organs-select
//= require modules/auto-complete

//= require views/shared/answers/form

/*
 * JavaScript de shared/tickets/form (new, edit, create, update)
 */

$(function(){
'use strict';

  // globals

  var _domAnswerIdentifiedWrapper = $('[data-content=identified]'),
      _domAnswerTypeWrapper = _domAnswerIdentifiedWrapper.find('[data-input=answer_type]'),
      _domUnknownOrgan = $('[data-input=unknown_organ]'),
      _domSubmitTicketBtn = $('[data-submit=send_ticket]'),
      _domDenunciationAgreementCheckbox = $('#checkbox-agreement'),
      _domSubmitDenunciationBtn = $('[data-submit=send_denunciation]'),
      _domDenunciationToogle = $('[data-input=denunciation]'),
      _domTicketTypeWrapper = $('[data-content=sou_types]'),
      _domForm = $('form'),

      _domIndividualName = $('[data-content=individual_name]'),
      _domLegalName = $('[data-content=legal_name]'),
      _domContentDocument = $('[data-content=document]'),
      autoCompleteIdividualName = new AutoComplete(_domIndividualName, { params: { person_type: 'individual' } }),
      autoCompleteLegalName = new AutoComplete(_domLegalName, { params: { person_type: 'legal' } }),
      autoCompleteDocument = new AutoCompleteDocument(_domContentDocument),

      _classificationHelper = null,
      _contentUtils = new ContentUtils(),
      _answerTypesToggle = new TicketAnswerTypesToggle(_domAnswerTypeWrapper),

      // preenchedor de campos de endereço
      _domAnswerAddressZipCodeInput = $('[data-input=answer_address_zipcode]'),
      _answerAddressFiller = new AddressFiller(_domAnswerAddressZipCodeInput),

      // preenchedor de campos de local de ocorrencia
      _domTargetAddressZipCodeInput = $('[data-input=target_address_zipcode]'),
      _targetAddressFiller = new AddressFiller(_domTargetAddressZipCodeInput),

      _domUsedInput = $('[data-input=used_input]'),
      _domPrivacyPolicyCheckbox = $('#checkbox-privacy-policy'),
      _domSelectOrgan = $('#ticket_organ_id'),

      _domUnknownDenunciationOrganCheckbox = $('[data-input=unknown_denunciation_organ]'),

      _userInfoHelper = null,

      _domTicketPublicCheckbox = $('#ticket_public_ticket');

  // event handlers

  /// usuário clicou no checkbox para a manifestação ser pública
  _domTicketPublicCheckbox.on('change', function() {
    alert(ticket_public.value)
  });

  /// usuário clicou no botão para salvar a manifestação

  _domSubmitTicketBtn.on('click', function() {
    _cleanComments();
  });

  /// usuário está fazendo um denúncia e clicou no checkbox "Li e estou de acordo"

  _domDenunciationAgreementCheckbox.on('change', function() {
    _enableOrDisableSendDenunciation();
  });

  _domSelectOrgan.on('change', function() {

    $('#lbl_organ_selected').text(this.options[this.selectedIndex].text);
  });


  /// usuário clicou no checkbox da política de privacidade

  _domPrivacyPolicyCheckbox.on('change', function() {
    _enableOrDisableSendTicket();
  });


  /// usuário alterou o tipo da manifestação

  _domTicketTypeWrapper.on('change', function() {
    _updateTicketTypeContainer();
  });

  _domAnswerTypeWrapper.on('click', 'input', function() {
    var option = $(this).val(),
      inputs = '[data-required]',
      selector = '[data-required=' + option + ']';

      _removeRequiredText(inputs);

      _addRequiredText(selector);
  });

  // usuário alterou meio de entrada
  _domUsedInput.on('change', function() {
    _updateUsedInputUrlField();
  });



  // privates

  /*
   * Habilita o botão para enviar denúncia se checkbox está selecionado ou
   * Dasabilita o botão para enviar denúncia se checkbox não está selecionado
   */
  function _enableOrDisableSendDenunciation() {
    var isChecked = _domDenunciationAgreementCheckbox.is(':checked');
    _domSubmitDenunciationBtn.attr('disabled', !isChecked);
  }

  /*
   * Habilita o botão para salvar se o checkbox está selecionado ou
   * Dasabilita se o checkbox não está selecionado
   */
  function _enableOrDisableSendTicket() {
    var isChecked = _domPrivacyPolicyCheckbox.is(':checked');
    _domSubmitTicketBtn.attr('disabled', !isChecked);
  }

  function _hideAndDisableContent(aContentValue) {
    _contentUtils.updateContent(aContentValue, 'hide_and_disable');
  }

  function _showAndEnableContent(aContentValue) {
    _contentUtils.updateContent(aContentValue, 'show_and_enable');
  }

  function _updateTicketTypeContainer() {
    if(_domDenunciationToogle.is(':checked')){
      _hideAndDisableContent('general_ticket_type_content');
      _showAndEnableContent('denunciation_ticket_type_content');
      _domUnknownDenunciationOrganCheckbox.trigger('change');
    } else {
      _hideAndDisableContent('denunciation_ticket_type_content');
      _showAndEnableContent('general_ticket_type_content');
      _domUnknownOrgan.trigger('change');
    }
  }

  function _initOrgans() {
    var organsContent = $('[data-content=organs]');
    OrgansSelect(organsContent);
  }

  function _initUserInfoHelper() {
    _userInfoHelper = new UserInfoHelper(_domForm);
  }

  function _initTicketClassificationHelper() {
    _classificationHelper = new TicketClassificationHelper(_domForm);
  }

  function _initTicketAnswerCompletedHelper() {
    TicketAnswerCompletedHelper(_domForm);
  }

  function _initRequiredAnswerType () {
    var option = _domAnswerTypeWrapper.find(':checked').val(),
      inputs = $('[data-required=' + option + ']');

    _addRequiredText(inputs);
  }

  function _addRequiredText (aInputs) {
    $(aInputs).each(function() {
      _updateText(this, /$/, ' *');
    });
  }

  function _removeRequiredText (aInputs) {
    $(aInputs).each(function() {
      _updateText(this, ' *', '');
      _removeErrorMessage(this);
    });
  }

  function _removeErrorMessage (aInput) {
    var input = $(aInput),
      container = input.closest('.has-danger'),
      textHelp = container.find('small.text-help');

      container.removeClass('has-danger');

      textHelp.remove();
  }

  function _updateText (aInput, aPattern, aText) {
    var input = $(aInput),
      text = input.text(),
      newText = text.replace(aPattern, aText);

    input.text(newText);
  }

  function _updateSubmitTicketBtn(){
    if (_domPrivacyPolicyCheckbox.length){
      _domSubmitTicketBtn.attr('disabled', true);
    }
  }

  function _updateUsedInputUrlField() {
    var value = _domUsedInput.val();

    if (value === 'consumer_gov' || value === 'complaint_here') {
      _showAndEnableContent('used_input_url');
    } else {
      _hideAndDisableContent('used_input_url');
    }
  }

  /*
   *
   * Limpa o atributos de resposta quando não há resposta para evitar validação
   *
   */
  function _cleanComments() {
    var answerInput = $('[data-input=comment-description]'),
        id = answerInput.attr('id'),
        answer = CKEDITOR.instances[id];

    if (answer === undefined) {
      return;
    }
  }

  /// setup

  function _init() {
    _initUserInfoHelper();
    _initOrgans();
    _initRequiredAnswerType();
    _initTicketClassificationHelper();
    _initTicketAnswerCompletedHelper();
    _updateSubmitTicketBtn();
    _updateUsedInputUrlField();

    // evento deve ficar por ultimo pois o metodo initOrgans recarrega a combo de topic a deixando habilitada.
    // esse metodo bloqueia os demais inputs que nao estao vinculados a aba ticket type selecionada (reclamacao, denuncia..)
    _updateTicketTypeContainer();
  }

  _init();
});
