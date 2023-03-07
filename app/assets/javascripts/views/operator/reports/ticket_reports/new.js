//= require modules/utils/content-utils
//= require modules/remote-select2
//= require components/dependent-select
//= require modules/form/rede-ouvir-organ-select

$(function() {
'use strict';

  var _domSouTypeContainer = $('[data-container=sou_type_container]'),
    _domTicketTypeInput = $('[data-input=ticket_type]'),

    _domOrgan = $('[data-input=organ]'),
    _domTopic = $('[data-input=topic]'),
    _domSubtopic = $('[data-input=subtopic]'),
    _domBudgetProgram = $('[data-input=budget_program]'),
    _domOtherOrgans = $('[data-input=other_organs]'),

    _topic = new RemoteSelect2(_domTopic, true),
    _subtopic = new RemoteSelect2(_domSubtopic, true),
    _budgetProgram = new RemoteSelect2(_domBudgetProgram, true),

    _contentUtils = new ContentUtils();

  /* event handlers */

  _domOrgan.on('change', function() {
    _topic.clear();
    _budgetProgram.clear();
  });

  _domTopic.on('change', function() {
    _subtopic.clear();
  });

  _domTicketTypeInput.on('change', function() {
    var value = $(this).val();
    _updateSouTypeContainer(value);
    choose_reports();
  });

  _domOtherOrgans.on('change', function() {
    _setVisibility();
  });

  function _setVisibility() {
    var flagVisible = '',
      flagContents = ['topic', 'subtopic', 'budget_program'];

    if (_isOtherOrgansChecked()) {
      flagVisible = 'hide_and_disable';
    } else {
      flagVisible = 'show_and_enable';
    }

    _contentUtils.updateContents(flagContents, flagVisible);
  }

  function _updateSouTypeContainer(value) {
    if(value === 'sou'){
      _contentUtils.updateContent(_domSouTypeContainer, 'show_and_enable')
    }else{
      _contentUtils.updateContent(_domSouTypeContainer, 'hide_and_disable')
    }
  }

  function _isOtherOrgansChecked() {
    return _domOtherOrgans.is(':checked');
  }

  function choose_reports(){
    if ($('#choose_reports').prop('checked')) {
      if (_domTicketTypeInput.val() == 'sou') {
        $('.sou_reports').show();
        $('.sic_reports').hide();
        $('input:checkbox', $('.sic_reports')).prop("checked", false);
      } else {
        $('.sic_reports').show();
        $('.sou_reports').hide();
        $('input:checkbox', $('.sou_reports')).prop("checked", false);
      }
    } else {
      $('.sou_reports').hide();
      $('.sic_reports').hide();

      $('input:checkbox', $('.sou_reports')).prop("checked", false);
      $('input:checkbox', $('.sic_reports')).prop("checked", false);
    }
  }

  function _init() {
    DependentSelect(_domOrgan);
    _updateSouTypeContainer(_domTicketTypeInput.val());
    _setVisibility();

    $('.state-select').each(function() {
      StateSelect($(this));
    });

    new RedeOuvirOrganSelect($(document)).showSelectOrganCategory();

    $('#choose_reports').click(choose_reports);
  }

  _init();
});
