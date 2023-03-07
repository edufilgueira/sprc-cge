/**
 *
 * Componente para carregamento de selects dependente de outros
 *
 *
 *  [construtor]
 *
 *  - aContainer: Objeto ou selector jQuery que possui componente principal
 *
 *
 * Utiliza os seguintes parâmetros:
 *
 *   [data-child-container]: selector do container que exibirá os resultados
 *   [data-params-name]: nome do parâmetro que será enviado a url
 *   [data-url]: url da requisição ajax que retorna os resultados
 *   [data-content=loading]: Loader para exibir durante a requisição ajax
 *   [data-parent]: (opcional) nome do container wrapper, util para conteúdo nested. default: body
 *
 *
 * O JSON retornado pela url deve ser:
 *
 * [ {id: ..., name: ...}, {id: ..., name: ...}, ... ]
 */
function DependentSelect(aContainer) {
'use strict';

  // globals

  var _domContainer = $(aContainer),

    _url = _domContainer.data('url'),
    _domLoader = _domContainer.find('[data-content=loading]'),

    _parentSelector = _domContainer.data('parent') || 'body',
    _domParentContainer = _domContainer.closest(_parentSelector),

    _domResultsContainer = _domParentContainer.find(_domContainer.data('child-container'));




  // event handlers

  _domContainer.on('change', function() {    
    _getResults();
  });

  // privates

  function _startLoading() {
    _domLoader.removeClass('hidden-xs-up');
  }

  function _stopLoading() {
    _domLoader.addClass('hidden-xs-up');
  }

  function _getResults() {


    var paramName = _domContainer.data('param-name'),
        ignoreBlank = _domContainer.data('ignore-blank'),
        paramValue = _domContainer.val(),
        data = {};

    if (paramValue === '' && ignoreBlank) {
      _clearResults();
      return;
    }

    data[paramName] = paramValue;

    $.ajax({
      url: _url,
      data: data,
      beforeSend: function() {
        _clearResults();
        _startLoading();
      },
      success: function(aData) {
        _showResults(aData);
      },
      complete: function() {
        _stopLoading();
      }
    });
  }

  function _showResults(aData) {

    var container = _domContainer,
      childContainer = _domResultsContainer,
      data = aData,
      selectedValue = _domResultsContainer.data('value'),
      selectAllSelected = (selectedValue === undefined),
      options = _getInitialOptions(selectAllSelected);

    $.each(data, function(index, result){
      var selected = (selectedValue === (result.id + '')) ? ' selected=selected' : '';
      options += '<option value="' + result.id + '"' + selected + '>' + result.name + '</option>';
    });

    childContainer.html(options);

    container.trigger('dependent-select:child:load');

    _selectDefaultResult();
  }

  function _getInitialOptions(aSelected) {
    var _dependentSelectBlank = _domResultsContainer.data('dependent-select-blank');

    if (_dependentSelectBlank !== undefined) {
      var selected = (aSelected ? ' selected=selected' : '');

      return "<option value=' '" + selected + ">" + _dependentSelectBlank + "</option>";
    }

    return '';
  }

  function _clearResults() {
    var childContainer = _domResultsContainer;

    // armazena o resultado selecionado para mantê-lo após o load.
    childContainer.data('value', childContainer.val());

    childContainer.val('').html('').change();
  }

  function _selectDefaultResult() {
    var _dependentSelectBlank = _domResultsContainer.data('dependent-select-blank');

    if (_dependentSelectBlank !== undefined) {
      // para que o select2 selecione a opção padrão do select filho
      _domResultsContainer.trigger('change.select2');
    }
  }

  function _init() {
    if (_domContainer.size() > 0 && _domContainer.is(':visible')) {
      _getResults();
    }
  }

  _init();
}
