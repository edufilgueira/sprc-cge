//= require components/dependent-select
//= require modules/form/rede-ouvir-organ-select

/**
 * JavaScript para controlar seleção de órgão
 */
function OrganSelect(aContainer) {
'use strict';

  // globals

  var self = this,
    _domContainer = aContainer,

    _domUnknownOrganCheckbox = $('[data-input=unknown_organ]'),
    _domUnknownDenunciationOrganCheckbox = $('[data-input=unknown_denunciation_organ]'),

    _domUnknownDenunciationTopicCheckbox = $('[data-input=unknown_denunciation_topic]'),
    _domOrganSelect = _domContainer.find('[data-input=organ]'),
    _domDenunciationOrganSelect = $('#ticket_denunciation_organ_id'),

    _domUnknownSubnetCheckbox = _domContainer.find('[data-input=unknown_subnet]'),
    _domSubnetSelect = _domContainer.find('[data-input=subnet]'),
    _domSubnetContent = _domContainer.find('[data-content=subnet]'),
    _domRedeOuvirInput = _domContainer.find('[data-input=rede_ouvir]'),
    _domTopicSelect = _domContainer.find('[data-input=topic]'),
    _domDenunciationTopicSelect = $('[data-input=denunciation_topic]'),
    _domUnknownTopicCheckbox = _domContainer.find('[data-input=unknown_topic]');

  // public

  // events

  _domUnknownOrganCheckbox.on('change', _updateOrganSelect);
  _domUnknownDenunciationOrganCheckbox.on('change', _updateDenunciationOrganSelect);

  _domOrganSelect.on('change', function(){
    _updateSubnetStates();
    _updateTopicStates();
  });
  _domDenunciationOrganSelect.on('change', _updateDenunciationTopicStates);

  _domUnknownSubnetCheckbox.on('change', _updateSubnetSelect);

  _domUnknownTopicCheckbox.on('change', _updateTopicSelect);
  _domUnknownDenunciationTopicCheckbox.on('change', _updateDenunciationTopicSelect);

  // privates

  /*
    * Atualiza estado (disabled) do select de órgão de acordo com o valor do
    * checkbox 'Não sei qual é o órgão responsável'
    */
  function _updateOrganSelect() {
    var inputs = _domContainer.find(':input').not('[data-input=unknown_organ]').not('[data-input=unknown_topic]');
    var unknown_organ_checked = _isUnknownOrganChecked();

    if (unknown_organ_checked){
      // componente select2 precisa de trigger change para alterar valor da combo
      _domOrganSelect.val('').trigger('change');
    }

    inputs.each(function() {
      $(this).prop('disabled', unknown_organ_checked);
    });

    _updateSubnetStates();
    _updateTopicStates();
  }

  /*
    * Atualiza estado (disabled) do select de órgão de acordo com o valor do
    * checkbox 'Não sei qual é o órgão responsável'
    */
  function _updateDenunciationOrganSelect() {

    // Nao precisa pegar as demais abas pois ao ocultar os inputs dela ja sao desabilitados

    var unknown_organ_checked = _isUnknownDenunciationOrganChecked();

    if (unknown_organ_checked){
      // componente select2 precisa de trigger change para alterar valor da combo
      _domDenunciationOrganSelect.val('').trigger('change');
    }

    $('#ticket_denunciation_organ_id').prop('disabled', unknown_organ_checked);
    _updateDenunciationTopicStates();
  }

  /*
   * Atualiza estado (disabled) do select de Unidade de acordo com o valor do
   * checkbox 'Não sei a Unidade'
   */
  function _updateSubnetSelect() {
    _domSubnetSelect.prop('disabled', _isUnknownSubnetChecked());
  }

  function _updateTopicSelect() {
    _domTopicSelect.prop('disabled', _isUnknownTopicChecked());
  }

  function _updateDenunciationTopicSelect() {
    _domDenunciationTopicSelect.prop('disabled', _isUnknownDenunciationTopicChecked());
  }

  function _updateSubnetStates() {
    var subnet = _domOrganSelect.find('option:selected').data('subnet'),
        showSubnet = !! (! _isUnknownOrganChecked() && subnet),
        enableSubnet = !! (showSubnet && (! _isUnknownSubnetChecked()));

    _domUnknownSubnetCheckbox.prop('disabled', !showSubnet);
    _domSubnetSelect.prop('disabled', !enableSubnet);

    // exibe/escode info sobre Unidade pois o órgão não possui sub-rede
    _domSubnetContent.toggle(showSubnet);
  }

  function _isUnknownOrganChecked() {
    return _domUnknownOrganCheckbox.prop('checked');
  }

  function _isUnknownDenunciationOrganChecked() {
    return _domUnknownDenunciationOrganCheckbox.prop('checked');
  }

  function _isUnknownSubnetChecked() {
    return _domUnknownSubnetCheckbox.prop('checked');
  }

  function _isUnknownTopicChecked() {
    return _domUnknownTopicCheckbox.prop('checked');
  }

  function _isUnknownDenunciationTopicChecked() {
    return _domUnknownDenunciationTopicCheckbox.prop('checked');
  }

  function _updateTopicStates() {
    var organSelected = _domOrganSelect.val() != '';
    var enableTopic = (
      (!_isUnknownOrganChecked() && organSelected && !_isUnknownTopicChecked()) ||
      (_isUnknownOrganChecked() && !_isUnknownTopicChecked())
    );

    _domTopicSelect.prop('disabled', !enableTopic);
  }

  function _updateDenunciationTopicStates() {

    var organSelected = _domDenunciationOrganSelect.val() != '';

    var enableTopic = (
      (!_isUnknownDenunciationOrganChecked() && organSelected && !_isUnknownDenunciationTopicChecked()) ||
      (_isUnknownDenunciationOrganChecked() && !_isUnknownDenunciationTopicChecked())
    );

    _domDenunciationTopicSelect.prop('disabled', !enableTopic);
  }

  // setup

  function _init() {
    _updateOrganSelect();
    _updateDenunciationOrganSelect();

    DependentSelect(_domOrganSelect);
    DependentSelect(_domDenunciationOrganSelect);

    new RedeOuvirOrganSelect(_domRedeOuvirInput).showSelectOrganCategory();

    _domOrganSelect.trigger('change');
    _domDenunciationOrganSelect.trigger('change');
  }

  _init();
}