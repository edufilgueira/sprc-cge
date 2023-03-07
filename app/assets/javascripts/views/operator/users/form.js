//= require modules/helpers/user-info-helper
//= require components/dependent-select

/*
 * JavaScript de view de edição de usuários.
 */
$(function(){
'use strict';

  // globals

  var _domChangePasswordCheckbox = $('[data-input=change_password]'),
      _domEmailConfirmation = $('[data-input=email_confirmation]'),
      _domOperatorType = $('[data-input=operator_type]'),

      _domDependentSelectDepartments = $('[data-dependent-select=departments]'),
      _domDependentSelectOrganSubnet = $('[data-dependent-select=organ_subnet]'),
      _domDependentSelectSubnet = $('[data-dependent-select=subnet]'),
      _domDependentSelectSubDepartments = $('[data-dependent-select=sub_departments]'),

      _contentUtils = new ContentUtils();


  // event handlers

  _domChangePasswordCheckbox.on('change', function() {
    _updatePasswordFields();
  });

  _domEmailConfirmation.on('paste', function(e) {
    e.preventDefault();
  });

  _domOperatorType.on('change', function() {
    _updateOperatorFields();
  });


  // privates

  function _updatePasswordFields() {
    var checkbox = _domChangePasswordCheckbox,
        form = checkbox.closest('form'),
        passwordFields = form.find('input[type=password]');

    passwordFields.prop('disabled', !checkbox.prop('checked'));
  }

  function _updateOperatorFields() {
    _updateDepartmentVisibility();
    _updateSubnetVisibility();
    _updatePositionigVisibility();
  }

  function _updatePositionigVisibility() {
    var value = _domOperatorType.val(),
      operators = ['sou_sectoral', 'sic_sectoral'],
      visibility = _contains(operators, value) ? 'show_and_enable' : 'hide_and_disable';

    _contentUtils.updateContent('positioning', visibility);
  }

  function _updateDepartmentVisibility() {
    var visibility = _isInternal() ? 'show_and_enable' : 'hide_and_disable';

    _contentUtils.updateContent('department', visibility);
  }

  function _updateSubnetVisibility() {
    var visibility = _isInternalOrSubnet() ? 'show_and_enable' : 'hide_and_disable';

    _contentUtils.updateContent('subnet', visibility);
  }

  function _isInternalOrSubnet() {
    return _isInternal() || _isSubnet();
  }

  function _isInternal() {
    var operatorType = _domOperatorType.val();
    return (operatorType === 'internal');
  }

  function _isSubnet() {
    var operatorType = _domOperatorType.val(),
      subnets = ['subnet_sectoral', 'subnet_chief'];
    return _contains(subnets, operatorType);
  }

  function _initUserInfoHelper() {
      var userInfoHelper = new UserInfoHelper($('form'));
  }

  function _contains(aList, aValue) {
    return (aList.indexOf(aValue) !== -1);
  }

  function _initDependentSelects() {
    var dependentSelectDepartments = new DependentSelect(_domDependentSelectDepartments),
      dependentSelectOrganSubnet = new DependentSelect(_domDependentSelectOrganSubnet),
      dependentSelectSubnet = new DependentSelect(_domDependentSelectSubnet),
      dependentSelectSubDepartments = new DependentSelect(_domDependentSelectSubDepartments);
  }

  /// setup

  function _init() {
    _initDependentSelects();
    _updatePasswordFields();
    _updateOperatorFields();
    _initUserInfoHelper();
  }

  _init();
});
