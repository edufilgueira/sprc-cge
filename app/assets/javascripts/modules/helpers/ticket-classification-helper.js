//= require modules/remote-select2
//= require components/helper/classification-helper

/**
 * Componente para manipular classificação na criação da manifestação
 *
 */

/**
 * @param {form container}
 */
function TicketClassificationHelper(aContainer) {
'use strict';

  var self = this,
    _domContainer = aContainer,
    _domOrgans = _domContainer.find('[data-content=organs]'),
    _domOrgan = _domContainer.find('[data-input=organ]'),
    _domSubnet = _domContainer.find('[data-input=subnet]'),
    _domUnknownOrgan = _domContainer.find('[data-input=unknown_organ]'),
    _domUnknownSubnet = _domContainer.find('[data-input=unknown_subnet]'),


    // Manter o [data-url] garante que o componente seja remoto
    _domTopic = _domContainer.find('[data-input=topic][data-url]'),
    _domDenunciationTopic = _domContainer.find('[data-input=denunciation_topic][data-url]'),
    _domSubtopic = _domContainer.find('[data-input=subtopic][data-url]'),
    _domBudgetProgram = _domContainer.find('[data-input=budget_program][data-url]'),
    _domDepartment = _domContainer.find('[data-input=classification_department][data-url]'),
    _domSubDepartment = _domContainer.find('[data-input=classification_sub_department][data-url]'),
    _domServiceType = _domContainer.find('[data-input=classification_service_type][data-url]'),


    _domDenunciationToogle = $('[data-input=denunciation]'),
    _domClassification = _domContainer.find('[data-content="classification"]'),
    _domImmediateAnswer = _domContainer.find('[data-input=immediate_answer]'),
    _domUnknownClassification = _domContainer.find('[data-content=unknown_classification]'),
    _domUnknownClassificationInput = _domUnknownClassification.find('[data-input=unknown_classification]'),

    _contentUtils = new ContentUtils(),

    _topic = new RemoteSelect2(_domTopic, true),
    _denunciationTopic = new RemoteSelect2(_domDenunciationTopic, true),
    _budgetProgram = new RemoteSelect2(_domBudgetProgram, true),
    _subtopic = new RemoteSelect2(_domSubtopic, true),
    _department = new RemoteSelect2(_domDepartment, true),
    _sub_department = new RemoteSelect2(_domSubDepartment, true),
    _service_type = new RemoteSelect2(_domServiceType, true),

    _classificationHelper = new ClassificationHelper(_domClassification);


  /* event handlers */

  _domOrgan.on('change', function() {
    _topic.clear();
    _department.clear();
    _budgetProgram.clear();
  });

  _domUnknownOrgan.on('change', function() {
    _setFormVisibility();
  });

  _domImmediateAnswer.on('change', function() {
    _setFormVisibility();
  });

  _domTopic.on('change', function() {
    _subtopic.clear();
  });

  _domDepartment.on('change', function() {
    _sub_department.clear();
  });

  // Adiciona novo orgão
  _domOrgans.on('cocoon:after-insert', function(aEvent, aElement) {
    _setFormVisibility();
    _reloadOrgan();
  });

  _domOrgans.on('cocoon:after-remove', function(aEvent, aElement) {
    _setFormVisibility();
    _reloadOrgan();
  });

  _domUnknownSubnet.on('change', function () {
    if ($(this).is(':checked')) {
      _domDepartment.data('param-name', 'organ');
    } else {
      _setDepartmentParamName();
    }
  });

  _domSubnet.on('change', function () {
    _setDepartmentParamName();
  });


  // private


  function _setFormVisibility() {
    var action = _isUnknownOrganOrDenunciationChecked() || _hasMultipleOrgans() ? 'hide_and_disable' : 'show_and_enable';

    // Se estiver marcado como resposta imediata força a
    // exibição do formulário de classificação.
    if (_isImmediateAnswer()) {
      action = 'show_and_enable';
      _domUnknownClassificationInput.attr('checked', false);
      _domUnknownClassificationInput.change();
      _domUnknownClassification.hide();
    } else {
      _domUnknownClassification.show();
    }

    _contentUtils.updateContent('classification', action);
  }

  function _hasMultipleOrgans() {
    return _domOrgans.find('[data-content=organ]').length > 1;
  }

  function _isUnknownOrganOrDenunciationChecked() {
    return _isUnknownOrganChecked() || _isDenunciationChecked();
  }

  function _isImmediateAnswer() {
    return _domImmediateAnswer.length > 0 && _domImmediateAnswer.is(':checked');
  }

  function _isUnknownOrganChecked() {
    return _domUnknownOrgan.is(':checked');
  }

  function _isDenunciationChecked() {
    return _domDenunciationToogle.is(':checked');
  }

  function _reloadOrgan() {
    _domOrgan = _domOrgans.find('[data-input=organ]:first');

    _domOrgan.on('change', function() {
      _topic.clear();
      _department.clear();
    });
  }

  function _setDepartmentParamName () {
    if ($.trim(_domSubnet.val()) == '') {
      _domDepartment.data('param-name', 'organ');
    } else {
      _domDepartment.data('param-name', 'subnet');
    }
  }

  /// setup

  function _init() {
    _setFormVisibility();
  }

  _init();

}
