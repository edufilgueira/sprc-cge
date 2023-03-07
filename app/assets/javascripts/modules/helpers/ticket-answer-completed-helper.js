//= require modules/remote-select2

/**
 * Componente para manipular da resposta imediata na criação do ticket
 *
 */

/**
 * @param {form container}
 */
function TicketAnswerCompletedHelper(aContainer) {
'use strict';

  var _domAnswerCompleted = aContainer.find('[data-content=answer-completed]'),
    _domImmediateAnswer = aContainer.find('[data-input=immediate_answer]'),

    _domOrgan = aContainer.find('[data-input=organ]'),
    _domUnknownOrgan = aContainer.find('[data-input=unknown_organ]'),
    _domOtherOrgans = aContainer.find('[data-input=other_organs]'),

    _domSubnet = aContainer.find('[data-input=subnet]'),
    _domUnknownSubnet = aContainer.find('[data-input=unknown_subnet]'),

    _userOrgan = _domAnswerCompleted.data('user-organ'),
    _userOperatorType = _domAnswerCompleted.data('user-operator-type'),
    _userSubnet = _domAnswerCompleted.data('user-subnet'),

    _contentUtils = new ContentUtils();

  /* event handlers */

  _domOrgan.on('change', function() {
    _init();
  });

  _domSubnet.on('change', function() {
    _init();
  });

  _domUnknownOrgan.on('change', function() {
    _init();
  });

  _domUnknownSubnet.on('change', function() {
    _init();
  });


  _domImmediateAnswer.on('change', function() {
    _init();
  });

  _domOtherOrgans.on('change', function() {
    _init();
  });


  // private

   function _setImmediateAnswerVisibility() {
    var action = _eligibleToshowImmediateAnswer() ? 'show_and_enable' : 'hide_and_disable';

    _contentUtils.updateContent('immediate_answer', action);
   }

  function _setFormVisibility() {
    var action = _eligibleToShowForm() ? 'show_and_enable' : 'hide_and_disable';

    _contentUtils.updateContent('answer-completed', action);
  }

  /*
   *
   * O campo de resposta imediata só fica visível se:
   * - Operador é do mesmo orgão que o ticket
   * - Operador subrede é da mesma unidade que o ticket
   * - Não esta marcado como Não sei qual é o órgão responsável ou não sei a unidade
   * - Está classificado e não classificado como competência de outros poderes
   *
   */
  function _eligibleToshowImmediateAnswer() {
    if (_isSubnet()) {
      return _isSubnetKnownAndEqual() && _isUnknownOrganNotChecked() && _isOtherOrgansNotChecked();
    } else if (_isSectoral() && !_isCoordination()) {
      return _isOrganKnownAndEqual() && _isOtherOrgansNotChecked();
    } else {
      return _domAnswerCompleted.length > 0
    }
  }

  function _eligibleToShowForm() {
    return _isImmediateAnswerVisible() && _isImmediateAnswerChecked();
  }

  function _isCoordination(){
    var operator_type = _userOperatorType;
    return operator_type == 'coordination';
  }

  function _isSectoral() {
    var organ = _userOrgan;
    return !_isSubnet() && organ !== undefined && organ !== null && organ !== ''
  }

  function _isSubnet() {
    var subnet = _userSubnet;
    return subnet !== undefined && subnet !== null && subnet !== ''
  }

  function _isImmediateAnswerVisible() {
    return _domImmediateAnswer.is(':visible');
  }

  function _isImmediateAnswerChecked() {
    return _domImmediateAnswer.is(':checked');
  }

  function _isUnknownOrganChecked() {
    return _domUnknownOrgan.is(':checked');
  }

  function _isUnknownOrganNotChecked() {
    return !_isUnknownOrganChecked();
  }

  function _isUnknownSubnetChecked() {
    return _domUnknownSubnet.is(':checked');
  }

  function _isUnknownSubnetNotChecked() {
    return !_isUnknownSubnetChecked();
  }

  function _isOtherOrgansChecked() {
    return _domOtherOrgans.is(':checked');
  }

  function _isOtherOrgansNotChecked() {
    return !_isOtherOrgansChecked();
  }

  function _isSubnetKnownAndEqual() {
    return _isSameSubnet() && _isUnknownSubnetNotChecked();
  }

  function _isOrganKnownAndEqual() {
    return _isSameOrgan() && _isUnknownOrganNotChecked();
  }

  function _isSameOrgan() {
    var organ = _organValue();
    return (organ == _userOrgan);
  }

  function _isSameSubnet() {
    var subnet = _subnetValue();
    return (subnet == _userSubnet);
  }

  function _organValue() {
    return _domOrgan.val();
  }

  function _subnetValue() {
    return _domSubnet.val();
  }


  /// setup

  function _init() {
    _setImmediateAnswerVisibility();
    _setFormVisibility();
  }

  _init();

}
