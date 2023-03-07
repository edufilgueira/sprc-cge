//= require components/utils/dom-helper
//= require components/utils/event-key-helper
//= require components/utils/url-helper
//= require components/month-range
//= require components/dependent-select

/**
 * Componente responsável por barra de filtro simples.
 */

function FilterBar(aFilterBarContainer) {
'use strict';



  /* consts */
  var INPUT_CHANGE_SELECTORS = 'select, [data-remote-select2], input[type=checkbox], [data-filter-bar-field]',
      DATE_TIME_INPUT_CHANGE_SELECTORS =  'input.datetimepicker, input.date-datetimepicker, input.month-datetimepicker, input.year-datetimepicker',
      STATS_INPUT_CHANGE_SELECTORS = '[data-stats-month]';

  /* globals */

  var self = this,
      _domFilterBarContainer = aFilterBarContainer,
      _domHelper = new DomHelper(_domFilterBarContainer),
      _domFilterForm = _domHelper.find('form'),
      _eventKeyHelper = new EventKeyHelper(),
      _urlHelper = new UrlHelper();


  /* public API */

  self.clearFilter = function() {
    _clearFilter();
  };

  /* event handlers */

  // history.back...

  window.addEventListener('popstate', function(aEvent) {
    // aEvent.target.location.search = parametros da url antiga que está sendo 'popped'
    // ex: ?cod_gestora=+&data_assinatura=&data_publicacao_portal=&decricao_modalidade=+&page=17&search=&sort_column=integration_supports_creditors.nome&sort_direction=desc&status=+&tipo_objeto=+

    var stateData = aEvent.state,
        filterBarId = (stateData && stateData['filter_bar_id']);

    if (filterBarId === _getFilterBarId()) {
      var params = _urlHelper.getUrlParams(aEvent.target.location.search);

      _restoreFormParameters(params);
    }

  }, true);

  // usuário clicou no botão de limpar o filtro...

  _domFilterBarContainer.on('click', 'button[type=reset]', function() {
    _clearFilter();
  });

  // usuário mudou alguma opção de filtro em select...

  _domFilterBarContainer.on('change', INPUT_CHANGE_SELECTORS, function() {
    if (_considerInputChanged(this)) {
      _submitForm();
    }
  });


  // usuário alterou o fitro de estatísticas de período mensal

  _domFilterBarContainer.on('change', STATS_INPUT_CHANGE_SELECTORS, function() {
    if (_considerInputChanged(this)) {
      var inputChanged = $(this);

      new MonthRange(inputChanged).validate();

      _submitForm();
    }
  });


  // usuário mudou alguma data no bootstrap-datetimepicker
  _domFilterBarContainer.on('dp.change', DATE_TIME_INPUT_CHANGE_SELECTORS, function() {

    if (_considerInputChanged(this)) {

      // Advanced filter
      if (this.classList.contains('revenue_account_year')){
        //TODO: implementar editar hierarqia HTML e url params
        // É esperado que permanceça conforme definido.
        var _url = '/portal-da-transparencia/receitas/node_types';


        $.ajax({
          url: _url,
          data: 'year='+ $('#year').val(),
          beforeSend: function() {
          },
          success: function(aData) {
            $(".div_tree_organizer").html(aData);

          },
          complete: function() {

          }
        });

        var select = new MultiDependentSelect('[data-dependent-select=consolidado]');

      }

      _submitForm();


    }
  });

  // usuário mudou algum período no bootstrap-datetimepicker

  _domFilterBarContainer.on('apply.daterangepicker', function() {
    if (_considerInputChanged(this)) {
      _submitForm();
    }
  });

  // usuário pressionou enter no campo de busca...

  _domFilterBarContainer.on('keyup', 'input[type=text]', function(aEvent) {
    _handleKeyUp(aEvent);
  });


  /* privates */

  function _clearFilter() {
    _resetForm();
    _submitForm();
  }

  function _resetForm() {
    var inputs = _domFilterForm.find('input[type=search], input:text:not(.datetimepicker):not(.month-datetimepicker):not(.year-datetimepicker), input:hidden:not([data-filter=permanent])'),
        checkboxes = _domFilterForm.find('input:checkbox:not([data-filter-permanent])'),
        selects = _domFilterForm.find('select:not([data-filter-bar-bypass-clear]), [data-remote-select2]:not([data-filter-bar-bypass-clear])'),
        dateTimePickers = _domFilterForm.find('input.datetimepicker:not([data-filter-bar-bypass-clear]), input.month-datetimepicker:not([data-filter-bar-bypass-clear]), input.year-datetimepicker:not([data-filter-bar-bypass-clear])');

    _clearInput(inputs);
    _clearCheckbox(checkboxes);
    _clearSelect(selects);
    _clearDateTimePickers(dateTimePickers);
  }

  function _submitForm() {
    // atualiza a url na barra pois o load é via ajax...
    _updateUrl();

    _domFilterForm.submit();
  }

  function _getFormParameters() {
    var validInputs = _domFilterForm.find('input[name!=flexdatalist-search_datalist], select'),
        formParams = validInputs.serializeArray(),
        urlParams = _urlHelper.getQueryParameters(),
        params =  _mergedParams(urlParams, formParams);

    // temos que inserir um outro parâmetros pois a url será alterada (History
    // API) e alguns navegadores irão cachear o resultado do AJAX pela sua url.
    // Quando a API encontrar o cache com a mesma url, irá renderizar o json
    // resultado do AJAX e não a página original.
    if (!_urlHelper.paramExists(params, '__')) {
      params.push({ '__': '__' });
    }

    return params;
  }

  /*
   * Restaura os valores dos filtros baseado na URL. Usado no popstate do
   * histórico.
   */
  function _restoreFormParameters(aParams) {
    var params = aParams,
        inputs = _domFilterForm.find(':input');

    for (var i = 0; i < inputs.length; i++) {
      var input = $(inputs[i]),
          name = input.prop('name');

      if (aParams[name] !== undefined) {
        var paramValue = aParams[name],
            paramValueWithSpaces = (paramValue + '').replace(/\+/g, '%20'),
            decodedValue = decodeURIComponent(paramValueWithSpaces);

        if (input.data('select2') !== undefined) {
          // Altera o valor do select2 sem disparar o onchange que recarregaria
          // os dados!

          input.val(decodedValue);
          input.trigger('change.select2');
        } else if (input.prop('type') === 'checkbox') {
          input.prop('checked', decodedValue === input.prop('value'));
        } else {
          input.val(decodedValue);
        }
      }
    }
  }

  function _handleKeyUp(aEvent) {
    var event = aEvent,
        keyCode = event.keyCode,
        input = $(event.target);

    if (_eventKeyHelper.isEnterKeyCode(keyCode)) {
      if (input.data('filter-bar-ignore-submit-on-enter') === true) {
        // para campos de busca dentro de form e que possuem botão de submit,
        // temos que ignorar o enter pois o próprio rails faz a submissão e iria
        // 2 vezes.

        _updateUrl();

        return;
      }

      _submitForm();
    }

    if (_eventKeyHelper.isEscKeyCode(keyCode)) {
      _clearInput(input);
      _submitForm();
    }

    aEvent.preventDefault();
    aEvent.stopPropagation();
  }

  function _clearInput(aInput) {
    aInput.val('');
  }

  function _clearCheckbox(aCheckbox) {
    aCheckbox.prop('checked', false);
  }

  function _clearSelect(aSelect) {
    // jeito normal para limpar...
    aSelect.val('');

    // jeito select2 para limpar...
    aSelect.select2('val', '');
    aSelect.find('option').prop('selected', false);
  }

  function _clearDateTimePickers(aInput) {
    aInput.each(function() {
      var input = $(this),
        placeholderValue = input.attr('placeholder');

      input.data('DateTimePicker').date(null);
    });
  }

  function _mergedParams(aUrlParams, aFormParams) {
    // temos que mergear os parâmetros atuais da url para permitir que a
    // mesma página tenha mais de uma FilterBar e que seus parâmetros sejam
    // mutuamente preservados.

    // aUrlParams é um hash com name: value dos parâmetros.
    // aFormParams é um array com [ {name: '...', value: '...'} dos parâmetros.
    // Devemos dar prioridade ao aForm, ou seja, vamos adicionar os aUrlParams
    // apenas se ainda não existirem em aFormParams.


    // XXX removendo atributos com nomes duplicados, exceto arrays `attr[]`, para
    // evitar duplicações como no caso de checkboxes do rails, que adiciona
    // <input name="attr" type="hidden" value="off">
    // <input name="attr" type="checkbox" value="on">
    //
    // IMPORTANT iteramos sobre o form de "trás para frente", seguindo comportamento da especificação
    // de <form>, que é a de enviar apenas o último parâmetro com valor definido.
    var result = []
    for (var i = aFormParams.length - 1; i >= 0; i--) {
      var formParam = aFormParams[i]
      var formParamName = formParam.name

      // se não for "array", ou seja, se param não terminar com `[]`, então tem que ser único
      if (!/\[\]$/.test(formParamName)) {
        _addParamUnlessExists(result, formParam.name, formParam.value)
      } else {
        result.push(formParam)
      }
    }

    // mergeando form params com url params, dando preferência para valores já em form params
    for (var paramName in aUrlParams) {
      var paramValue = aUrlParams[paramName];

      _addParamUnlessExists(result, paramName, paramValue);
    }


    return result;
  }

  function _addParamUnlessExists(aResult, aParamName, aParamValue) {

    if (_urlHelper.paramExists(aResult, aParamName)) {
      return;
    }

    aResult.push({ name: aParamName, value: aParamValue });

    return aResult;
  }

  function _updateUrl() {
    var filterBarId = _getFilterBarId(),
        stateData = { filter_bar_id: filterBarId };

    _urlHelper.updateUrlParams(_getFormParameters(), true /* aPushState para adicionar nova entreada no histórico */, stateData);
  }

  function _getFilterBarId() {
    return _domFilterBarContainer.data('filter-bar');
  }

  function _considerInputChanged(aInput) {
    return ! ($(aInput).attr('data-filter-bar-ignore') !== undefined);
  }

  /* setup */

  function _init() {
  }

  _init();
}
