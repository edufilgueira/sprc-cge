//= require modules/utils/content-utils

/**
 * Componente para manipular conteúdo de informações de usuários
 *
 */

/**
 * @param {form container}
 */
function UserInfoHelper(aContainer) {
  'use strict';

  var self = this,
      _domDocumentTypeSelect = aContainer.find('[data-input=document_type]'),
      _domDocumentInput = aContainer.find('[data-input=document]'),
      _domPersonType = aContainer.find('[data-input=person_type]'),
      _domPersonTypeContainer = aContainer.find('[data-input=person_type]'),
      _domCnpjDocumentTypeLabel = aContainer.find('[data-input=document_cnpj]'),
      _contentUtils = new ContentUtils();

  /* API pública */

  self.updatePersonType = function () {
    _updatePersonTypeContents(_domPersonTypeContainer.find('input:checked'));
    _updateDocumentMask();
  };

  self.hideAnonymousOption = function () {
    _domPersonType.find('label[for=anonymous]').hide()
  };

  self.showAnonymousOption = function () {
    _domPersonType.find('label[for=anonymous]').show()
  };


  /* event handlers */

  /// usuário alterou o select 'perfil da pessoa'... (física, jurídica ou anônima)
  _domPersonTypeContainer.on('change', 'input', function() {
    _updatePersonTypeContents($(this));
    _updateDocumentMask();
  });

  /// usuário alterou o select 'tipo de documento'...

  _domDocumentTypeSelect.on('change', function() {
    _updateDocumentMask();
  });


  /* privates */

  /*
   *
   * Adiciona ou remove as máscaras do documento
   *
   */
  function _updateDocumentMask() {
    var selectedDocumentType = _domDocumentTypeSelect.val(),
        personType = _getPersonType();

    switch(personType) {
      case 'individual':
        cpfMask(selectedDocumentType);
        break;

      case 'legal':
        _addCnpjMask();
        break;

      default:
        _removeMask();
    }
  }

  function _getPersonType() {
    return _domPersonType.val() || _domPersonTypeContainer.find('input:checked').val();
  }

  function cpfMask(aSelectedDocumentType) {
    if (aSelectedDocumentType === 'cpf') {
      _addCpfMask();
    } else {
      _removeMask();
    }
  }

  /*
   *
   * Atualiza os campos para pessoa física ou jurídica
   *
   */
  function _updatePersonTypeContents(aInput) {
    var input = $(aInput),
      selectedPersonType = input.val();

    switch(selectedPersonType) {
      case 'individual':
        _showIndividualPersonContent();
        _showComplimentSouType();
        break;

      case 'legal':
        _showLegalPersonContent();
        _showComplimentSouType();
        break;

      case 'anonymous':
        _showAnonymousPersonContent();
        _hideComplimentSouType();
        break;
    }
  }


  function _showIndividualPersonContent() {
    _contentUtils.updateContent('anonymous', 'hide_and_disable');
    _contentUtils.updateContent('identified', 'show_and_enable');
    _domPersonTypeContainer.find('input[data-anonymous]').attr('checked', false);

    _contentUtils.updateContent('legal_person', 'hide_and_disable');

    _contentUtils.updateContent('individual_person', 'show_and_enable');

    _domCnpjDocumentTypeLabel.hide();
    _domDocumentTypeSelect.siblings('.select2-container').show();

    _domDocumentTypeSelect.trigger('change');
  }

  function _showLegalPersonContent() {
    _contentUtils.updateContent('anonymous', 'hide_and_disable');
    _contentUtils.updateContent('identified', 'show_and_enable');
    _domPersonTypeContainer.find('input[data-anonymous]').attr('checked', false);

    _contentUtils.updateContent('individual_person', 'hide_and_disable');

    _contentUtils.updateContent('legal_person', 'show_and_enable');

    _domCnpjDocumentTypeLabel.show();
    _domDocumentTypeSelect.siblings('.select2-container').hide();
  }

  function _showAnonymousPersonContent() {
    _contentUtils.updateContent('anonymous', 'show_and_enable');
    _contentUtils.updateContent('identified', 'hide_and_disable');

    _contentUtils.updateContent('individual_person', 'hide_and_disable');

    _contentUtils.updateContent('legal_person', 'hide_and_disable');

    _domPersonTypeContainer.find('input[data-identified]').attr('checked', false);
  }

  /// ocultar tipo de manifestação quando for Elogio
  function _hideComplimentSouType() {
    $('[data-input=compliment]').parents("label").hide();
    $('[data-input=compliment]').attr('disabled', true);
  }

  function _showComplimentSouType() {
    $('[data-input=compliment]').parents("label").show();
    $('[data-input=compliment]').attr('disabled', false);
  }

  /// controle de máscaras de 'Documento'

  function _addCpfMask() {
    _domDocumentInput.mask('999.999.999-99', { autoclear: false });
  }

  function _addCnpjMask() {
    _domDocumentInput.mask('99.999.999/9999-99', { autoclear: false });
  }

  function _removeMask() {
    _domDocumentInput.unmask();
  }

  /// setup

  function _init() {
    _updateDocumentMask();
    _updatePersonTypeContents(_domPersonTypeContainer.find('input:checked'));
  }

  _init();

}
