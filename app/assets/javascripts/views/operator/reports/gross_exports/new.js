//= require modules/remote-select2
//= require components/dependent-select
//= require modules/utils/content-utils
//= require modules/form/rede-ouvir-organ-select

$(function () {
'use strict';

  var _domSouTypeContainer = $('[data-container=sou_type_container]'),
    _domTicketTypeInput = $('[data-input=ticket_type]'),
    _domOrgan = $('[data-input=organ]'),
    _domTopic = $('[data-input=topic]'),
    _domSubtopic = $('[data-input=subtopic]'),
    _domBudgetProgram = $('[data-input=budget_program]'),
    _domDepartment = $('[data-input=department]'),
    _domSubDepartment = $('[data-input=sub_department]'),
    _domServiceType = $('[data-input=service_type]'),


    _topic = new RemoteSelect2(_domTopic, true),
    _subtopic = new RemoteSelect2(_domSubtopic, true),
    _department = new RemoteSelect2(_domDepartment, true),
    _subDepartment = new RemoteSelect2(_domSubDepartment, true),
    _serviceType = new RemoteSelect2(_domServiceType, true),
    _budgetProgram = new RemoteSelect2(_domBudgetProgram, true),

    _contentUtils = new ContentUtils();


  /* event handlers */

  _domOrgan.on('change', function() {
    _topic.clear();
    _budgetProgram.clear();
    _department.clear();
    _serviceType.clear();
  });

  _domTopic.on('change', function() {
    _subtopic.clear();
  });

  _domDepartment.on('change', function() {
    _subDepartment.clear();
  });

  _domTicketTypeInput.on('change', function() {
    var value = $(this).val();
    _updateSouTypeContainer(value);
  });

  function _updateSouTypeContainer(value) {
    if(value === 'sou'){
      _contentUtils.updateContent(_domSouTypeContainer, 'show_and_enable')
    }else{
      _contentUtils.updateContent(_domSouTypeContainer, 'hide_and_disable')
    }
  }

  // setup

  function _init() {
    DependentSelect(_domOrgan);

    _updateSouTypeContainer(_domTicketTypeInput.val());

    $('.state-select').each(function() {
      StateSelect($(this));
    });

    new RedeOuvirOrganSelect($(document)).showSelectOrganCategory();
  }

  _init();
});
