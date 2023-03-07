//= require modules/helpers/user-info-helper
//= require components/dependent-select
//= require modules/form/rede-ouvir-organ-select

/*
 * JavaScript de view de edição de usuários.
 */

$(function(){
'use strict';

  // globals

  var _domChangePasswordCheckbox = $('[data-input=change_password]'),
      _domEmailConfirmation = $('[data-input=email_confirmation]'),
      _domOperatorTypeContent = $('[data-content=operator_type]'),
      _domUserType = $('[data-input=user_type]'),
      _domInternalSubnetCheckbox = $('[data-input=internal_subnet]'),
      _domRedeOuvirCheckbox = $('[data-input=rede_ouvir]'),
      _domOrganInput = $('[data-input=organ]'),
      _domSubnetOrganInput = $('[data-input=organ_subnet]'),
      _domDenunciationTrackingContent = $('[data-content=denunciation_tracking]'),
      _domDenunciationTrackingInput = $('[data-input=denunciation_tracking]'),

      _domDependentSelectDepartments = $('[data-dependent-select=departments]'),
      _domDependentSelectOrganSubnet = $('[data-dependent-select=organ_subnet]'),
      _domDependentSelectSubnet = $('[data-dependent-select=subnet]'),
      _domDependentSelectSubDepartments = $('[data-dependent-select=sub_departments]'),


      _dependentDepartmentsSelect = new DependentSelect(_domDependentSelectDepartments),
      _dependentOrganSubnetSelect = new DependentSelect(_domDependentSelectOrganSubnet),
      _dependentSubnetSelect = new DependentSelect(_domDependentSelectSubnet),
      _dependentSubDepartmentSelect = new DependentSelect(_domDependentSelectSubDepartments),

      _contentUtils = new ContentUtils();

  // event handlers

  // Usuário mudou o checkbox de rede ouvir
  _domRedeOuvirCheckbox.on('change', function() {
    _updateRedeOuvirFields();
  });

  /// usuário alterou o checkbox 'mudar senha'...

  _domChangePasswordCheckbox.on('change', function() {
    _updatePasswordFields();
  });

  /// usuário alterou o checkbox 'Ouvidor da Sub-rede'...

  _domInternalSubnetCheckbox.on('change', function() {
    _updateSubnetFields();
    _reloadDepartmentFields();
  });

  /// bloquer o "paste" no campo confirmação de email

  _domEmailConfirmation.on('paste', function(e) {
    e.preventDefault();
  });

  /// usuário alterou o tipo de usuário
  _domUserType.on('change', function() {
    _updateOperatorTypeInputVisibility();
  });

  /// usuário alter o tipo de operador
  _domOperatorTypeContent.on('change', function() {
    _updateOperatorFields();
  });

  _domDenunciationTrackingContent.on('change', function() {
    _updateDenunciationTrackingFields();
  });

  _domUserType.on('change', function() {
    _domOperatorTypeContent.trigger('change');
  });

  // XXX
  // XXX FIX:
  // XXX No form temos dois campos 'organ' um para subrede e outro para comum
  // XXX
  // XXX No form o campo organ de sub rede fica por último.
  // XXX Ao criar um usuário comum o valor de organ que é submetido é o de subrede que está esondido porém vazio.
  // XXX Desta forma a validação falha.
  // XXX
  _domOrganInput.on('change', function() {
    var organInput = $(this),
        organValue = organInput.val();

    _domSubnetOrganInput.val(organValue);
  });

  // privates

  /// controle de campos de 'alterar senha'

  function _updatePasswordFields() {
    var checkbox = _domChangePasswordCheckbox,
        form = checkbox.closest('form'),
        passwordFields = form.find('input[type=password]');

    passwordFields.prop('disabled', !checkbox.prop('checked'));
  }

  function getSelectValues(select) {
    var result = [];
    var options = select && select.options;
    var opt;

    for (var i=0, iLen=options.length; i<iLen; i++) {

      opt = options[i];
      
        result.push(opt.value || opt.text);
      
    }
    return result;
  }

  var originalListOperatorType = "";
  
   function _updateDenunciationTrackingFields() {      
    if (_domDenunciationTrackingInput.prop('checked')) {

      if ( originalListOperatorType == "") {

        originalListOperatorType = user_operator_type.innerHTML;

      }

      _remove_operator_without_denunciation_tracking()
      _domUserType.val('operator').trigger('change.select2');
      _domUserType.attr('disabled', 'disabled');
      _contentUtils.updateContent('operator_type', 'show_and_enable');   
      
      } else {
        
        _domUserType.attr('disabled', false);

        if ( originalListOperatorType != "") {

          user_operator_type.innerHTML = originalListOperatorType;

        }
  
      _contentUtils.updateContent('operator_type', 'show_and_enable');      
    }

    _domOperatorTypeContent.trigger('change');
  }

  function _remove_operator_without_denunciation_tracking() {
    $(_domOperatorTypeContent).each(function() {
      $(_domOperatorTypeContent.find('option')).each(function()
       {
          if ($(this).val() != 'cge' &&  $(this).val() != 'coordination' &&  $(this).val() != ''  ) {
            $(this).remove();
          } 
        }
      )
      $(this).val('');
    })
  }

  function _updateOperatorFields() {
    _updateDenunciationTrackingVisibility();
    _updateOrganAndDepartmentInputVisibility();
    _updateOperatorPositionigVisibility();
    _updateOperatorActsAsSicVisibility();
    _updateOperatorRedeOuvirVisibility();
    _updateOperatorSectoralDenunciationVisibility();

  }

  function _updateOperatorSectoralDenunciationVisibility() {
    var value = _domOperatorTypeContent.find('option:selected').val(),
        operators = ['sou_sectoral'];

    if (_contains(operators, value)) {
      _contentUtils.updateContent('sectoral_denunciation', 'show_and_enable');
    } else {
      _contentUtils.updateContent('sectoral_denunciation', 'hide_and_disable');
    }
  }

  function _updateOperatorTypeInputVisibility() {
    var value = _domUserType.val();
    var tracking_check = _domDenunciationTrackingInput.prop('checked');

    if ( (value === 'operator' && !tracking_check) || _isInOperatorNamespace()) {
      _contentUtils.updateContent('operator_type', 'show_and_enable');
    } else {
      _contentUtils.updateContents(['department', 'subnet'], 'hide_and_disable');
    }
  }

  function _updateOperatorPositionigVisibility() {
    var value = _domOperatorTypeContent.find('option:selected').val(),
        operators = ['sou_sectoral', 'sic_sectoral'];

    if (_contains(operators, value)) {
      _contentUtils.updateContent('positioning', 'show_and_enable');
    } else {
      _contentUtils.updateContent('positioning', 'hide_and_disable');
    }
  }

  function _updateOperatorActsAsSicVisibility() {
    var value = _domOperatorTypeContent.find('option:selected').val(),
        visiblility = 'sou_sectoral' === value ? 'show_and_enable' : 'hide_and_disable';

    _contentUtils.updateContent('acts_as_sic', visiblility);
  }

  function _updateOrganAndDepartmentInputVisibility() {
    var value = _domOperatorTypeContent.find('option:selected').val(),
        operators = ['sou_sectoral', 'sic_sectoral', 'internal', 'chief','coordination'],
        subnets = ['subnet_sectoral', 'subnet_chief'];

    if (_contains(operators, value)) {
      _contentUtils.updateContent('organ', 'show_and_enable');

      if (_isInternal(value)) {
        _contentUtils.updateContent('department', 'show_and_enable');
        _contentUtils.updateContent('internal_subnet', 'show_and_enable');
      } else {
        _contentUtils.updateContent('department', 'hide_and_disable');
        _contentUtils.updateContent('internal_subnet', 'hide_and_disable');
      }

      _updateSubnetFields();
    } else {
      if (_contains(subnets, value)) {

        _contentUtils.updateContent('subnet', 'show_and_enable');
      } else {

        _contentUtils.updateContent('subnet', 'hide_and_disable');
      }
        _contentUtils.updateContent('organ', 'hide_and_disable');
        _contentUtils.updateContent('department', 'hide_and_disable');
      _contentUtils.updateContent('internal_subnet', 'hide_and_disable');
    }
  }

  function _updateDenunciationTrackingVisibility() {
    var value = _domUserType.val();

    if (value === 'operator') {
      $('[data-content=denunciation_tracking]').show();
    } else {
      $('[data-content=denunciation_tracking]').hide();
    }
  }

  function _updateSubnetFields() {
    if (_isSubnetChecked()) {
      _contentUtils.updateContent('subnet', 'show_and_enable');
      _contentUtils.updateContent('organ', 'hide_and_disable');
    } else {
      _contentUtils.updateContent('subnet', 'hide_and_disable');
      _contentUtils.updateContent('organ', 'show_and_enable');
    }
  }

  function _reloadDepartmentFields() {
    if (_isSubnetChecked()) {
      _domDependentSelectSubnet.trigger('change');
    } else {
      _domDependentSelectDepartments.trigger('change');
    }
  }

  function _isInternal(aOperatorType) {
    return (aOperatorType === 'internal');
  }

  function _isSubnetChecked() {
    return (_domInternalSubnetCheckbox.prop('checked'));
  }

  function _isInOperatorNamespace() {
    var controller = $('body').data('controller');

    return (controller === 'operator/users');
  }

  function _initUserInfoHelper() {
    var formContainer = $('form'),
        userInfoHelper = new UserInfoHelper(formContainer);
  }

  function _contains(aList, aValue) {
    return (aList.indexOf(aValue) !== -1);
  }

  function _updateRedeOuvirFields() {
    if (_domRedeOuvirCheckbox.is(':visible') && _domRedeOuvirCheckbox.prop('checked')) {
      _contentUtils.updateContent('positioning', 'hide_and_disable');
      _contentUtils.updateContent('acts_as_sic', 'hide_and_disable');
    } else {
      _contentUtils.updateContent('positioning', 'show_and_enable');
      _contentUtils.updateContent('acts_as_sic', 'show_and_enable');
    }

    new RedeOuvirOrganSelect($('form')).showSelectOrganCategory();
  }

  function _updateOperatorRedeOuvirVisibility() {
    var value = _domOperatorTypeContent.find('option:selected').val(),
        visiblility = 'sou_sectoral' === value || 'chief' === value ? 'show_and_enable' : 'hide_and_disable';

    if (visiblility === 'hide_and_disable') {
      _domRedeOuvirCheckbox.prop('checked', false);
    }

    _updateRedeOuvirFields();

    _contentUtils.updateContent('rede_ouvir_checkbox', visiblility);
  }


  /// setup

  function _init() {
    _updatePasswordFields();
    _updateOperatorFields();
    _initUserInfoHelper();
    _updateRedeOuvirFields();
    _updateDenunciationTrackingFields();
    _updateOperatorTypeInputVisibility();
  }

  _init();
});