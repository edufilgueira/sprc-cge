//= require views/shared/answers/form

/*
 * JavaScript de shared/tickets/ticket_logs
 */

$(function() {
  'use strict';

  var _domTicketLogsContainer = $("[data-content*='_logs']"),
    _domTicketEvaluationContainer = $("[data-content*='ticket_evaluation']"),
    _domTicketHistoryContainer = $("[data-content='ticket_history']"),
    _domTicketHistoryUrl = _domTicketHistoryContainer.data('content-url'),
    _domEvaluationIntros = $("[data-content='evaluation-intro']"),
    _domEvaluationBtnGroup = $('.btn-group .btn'),

    // Na atual estrutura podemos ter a pesquisa de satisfação dentro da estrutura DOM do ticket_log
    _domRemoteContainer = _domTicketEvaluationContainer.length ? _domTicketEvaluationContainer : _domTicketLogsContainer,
    _logRemoteForm = new RemoteForm(_domRemoteContainer);


    // Event handlers

    _domTicketLogsContainer.on('ajax:success', _updateTicketHistory);


    // jquery + btngroup click event for partials rendered
    //
    // Usado para carregar eventos necessários para selecionar a nota da avaliação
    // no retorno da parial
    //
    // XXX Verificar como podemos initicializar o component bootstrap ao carregar
    // XXX a partial ou após o 'remote-form:after'
    // XXX e remover o javascript_include_tag de namespace/answers/_form
    //
    _domEvaluationBtnGroup.on('click', function() {
      var optionButton = $(this);

      _toggleBtnGroup(optionButton);
    });

    _domEvaluationIntros.each(function() {
      var evaluationIntro = $(this),
          btnEvaluate = evaluationIntro.find("[data-button='evaluate']");

      btnEvaluate.on('click', function() {
        _showEvaluationForm(evaluationIntro);
      });
    });


    // private

    function _toggleBtnGroup(aOptionButton) {
      var optionButton = aOptionButton;
      if (!optionButton.hasClass('active')) {
        optionButton.siblings('.btn-group .btn').removeClass('active');
        var label_tag = $(optionButton[0]);
        label_tag.addClass('active');
      }
    }

    function _showEvaluationForm(aEvaluation) {
      var evaluationIntro = aEvaluation,
          answerId = evaluationIntro.data('answerEvaluationIntroId'),
          evaluationForm = $('[data-answer-evaluation-form-id='+ answerId +']');

      evaluationIntro.hide();
      evaluationForm.show();
    }

    function _updateTicketHistory () {
      if (! _domTicketHistoryUrl) return;

      $.get(_domTicketHistoryUrl, function(aData) {
        _domTicketHistoryContainer.html(aData);
      });
    }

    function getUrlParameter(sParam) {
      var sPageURL = window.location.search.substring(1),
          sURLVariables = sPageURL.split('&'),
          sParameterName,
          i;

      for (i = 0; i < sURLVariables.length; i++) {
          sParameterName = sURLVariables[i].split('=');

          if (sParameterName[0] === sParam) {
              return typeof sParameterName[1] === undefined ? true : decodeURIComponent(sParameterName[1]);
          }
      }
      return false;
  }

  var satisfaction_survey_param = getUrlParameter('satisfaction_survey');

  // Caso tenha o parametro de pesquisa de satisfação for passado via url com valor true
  // E caso existir ao menos uma pesquisa de satisfação em aberto
  if (satisfaction_survey_param == 'true' && $('.evaluation-form').length > 0) {
    $('html').animate({
      scrollTop: $('.evaluation-form').offset().top
    }, 'slow');
  }
});
