/**
 * Componente para controle de elementos DOM do attendandace_evaluation/
 *   Ao modificar o valor de uma nota de avaliação, recalcula a média ponderada.
 *
 * Utiliza os seguintes parâmetros:
 *
 * data-weight: Peso da nota na média final
 *
 */

/**
 * [constructor]
 *
 *  - aContainer: objeto jQuery englobando todos os elementos do attendandace_evaluation.
 */
function AttendanceEvaluation(aContainer) {
'use strict';

  var self = this,
      _domContainer = aContainer,

      _domEvaluationClarity = _domContainer.find("[data-content=attendance_evaluation-clarity]"),
      _domEvaluationContent = _domContainer.find("[data-content=attendance_evaluation-content]"),
      _domEvaluationWording = _domContainer.find("[data-content=attendance_evaluation-wording]"),
      _domEvaluationKindness = _domContainer.find("[data-content=attendance_evaluation-kindness]"),
      _domEvaluationAverage = _domContainer.find("[data-content=average]"),
      _domEvaluationSubmit = _domContainer.find("[data-content=submit]"),
      _domEvaluationTextualStructure = _domContainer.find("[data-content=attendance_evaluation-textual_structure]"),
      _domEvaluationTreatment = _domContainer.find("[data-content=attendance_evaluation-treatment]"),
      _domEvaluationQuality = _domContainer.find("[data-content=attendance_evaluation-quality]"),
      _domEvaluationClassification = _domContainer.find("[data-content=attendance_evaluation-classification]"),
      _domEvaluationTicketType = document.getElementById("ticket_type"),

      _domEvaluationOptions = _domContainer.find("[data-content^=attendance_evaluation] input[type=radio]"),

      _logRemoteForm = new RemoteForm(_domContainer);


  // event handlers

  _domEvaluationOptions.on('change', function() {
    if (_domEvaluationTicketType.value == 'sou'){
      _calculateAverageSou();
    }else{
      _calculateAverage();
    }

    _enableEvaluationSubmit();
  });

  // jquery + btngroup click event for partials rendered
  //
  // Usado para carregar eventos necessários para selecionar a nota da avaliação
  // no retorno da parial
  //
  // XXX Verificar como podemos initicializar o component bootstrap ao carregar
  // XXX a partial ou após o 'remote-form:after'
  // XXX e remover o javascript_include_tag de operator/tickets/atendance_evaluations/_form
  //
  $('.btn-group .btn').on('click', function() {
    var optionButton = $(this);

    _toggleBtnGroup(optionButton);
  });

  _domEvaluationSubmit.on('click', function() {
    if(_domEvaluationTicketType.value != 'sic'){
      _domEvaluationSubmit.hide();
    };
  });


  // private

  function _toggleBtnGroup(aOptionButton) {
    var optionButton = aOptionButton;
    if (! optionButton.hasClass('active')) {
      optionButton.siblings('.btn-group .btn').removeClass('active');
      optionButton.button('toggle');
    }
  }

  function _weightedValue(aContainer) {
    var weight = aContainer.data('weight'),
        value = aContainer.find(':checked').val() || 0,
        weighted_value = weight * value;

    return weighted_value;
  }

  // REFATORAR AS FUNÇÕES DA MÉDIA PARA GENÉRICA.
  function _calculateAverage() {

    var clarity_weighted = _weightedValue(_domEvaluationClarity),
        content_weighted = _weightedValue(_domEvaluationContent),
        wording_weighted = _weightedValue(_domEvaluationWording),
        kindness_weighted = _weightedValue(_domEvaluationKindness),
        
        sum = clarity_weighted + content_weighted + wording_weighted + kindness_weighted,
        average = sum / 10;

      _domEvaluationAverage.text(average);
  }

  function _calculateAverageSou() {
    var textual_structure_weighted = _weightedValue(_domEvaluationTextualStructure),
        treatment_weighted = _weightedValue(_domEvaluationTreatment),
        quality_weighted = _weightedValue(_domEvaluationQuality),
        classification_weighted = _weightedValue(_domEvaluationClassification),

        // sum = clarity_weighted + content_weighted + wording_weighted + kindness_weighted,
        sum = textual_structure_weighted + treatment_weighted + quality_weighted + classification_weighted,
        average = sum / 10;

    _domEvaluationAverage.text(average);
  }

  function _enableEvaluationSubmit(){
    var _ticket_internally_evaluated = document.getElementById('attendance_evaluation_ticket_internally_evaluated');
    var _status_internally_evaluated = document.getElementById('status')

    if(_allCategoriesEvaluated() && (_domEvaluationTicketType.value == 'sic' && _ticket_internally_evaluated.value == 'false')
      || (_domEvaluationTicketType.value == 'sou' && _status_internally_evaluated.value == 'open') ){
      $('input').prop('disabled', false);
    }

  }

  function _allCategoriesEvaluated() {

    var allEvalueted = true;

    $.each(_listDomCategories(_domEvaluationTicketType), function(index, domCategory) {
      if(domCategory.find(':checked').val() == undefined){
        allEvalueted = false;
      }
    });

    return allEvalueted;
  }

  function _listDomCategories(ticketType){
    var categoriesByTickectType = '_categories'.concat(toCamelCase(ticketType.value) + '()')

    return eval(categoriesByTickectType);
  }

  function _categoriesSou(){
    return  new Array(
      _domEvaluationTextualStructure,
      _domEvaluationTreatment,
      _domEvaluationQuality,
      _domEvaluationClassification
    )
  }

  function _categoriesSic(){
    return new Array(
      _domEvaluationClarity,
      _domEvaluationContent,
      _domEvaluationWording,
      _domEvaluationKindness
    )
  }

  function toCamelCase(str) {
    return str.replace(/(?:^|\s)\w/g, function(match) {
      return match.toUpperCase();
    });
  }

}

$(document).ready(function() {
  var _ticketType = document.getElementById('ticket_type');
  var _ticket_internally_evaluated = document.getElementById('attendance_evaluation_ticket_internally_evaluated');

  if(_ticketType.value == 'sic' && _ticket_internally_evaluated.value == 'true'){
    $('input').prop('disabled', false);
  };
});