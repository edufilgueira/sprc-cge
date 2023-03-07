//= require components/utils/dom-helper
//= require components/utils/url-helper

/**
 * Componente responsável por controlar requisições ajax para a index de algum
 * recurso.
 *
 * A estrutura básica de um remote-content, deve ser:
 *
 *  .qualquer-coisa{'data-remote-content': 'identificador-de-seu-remote'}
 *
 *    ... algum remote form com filtros ou link, por exemplo. ambos devem ser
 *    do tipo 'remote'..
 *
 *    .outra-classe{'data-remote-content-result': 'identificador-de-seu-remote'}
 *
 *      = render 'index' # as requisições remotas só irão renderizar o conteúdo
 *                       # da partial _index. se sua view inicial não carrega
 *                       # nada, esse render é desnecessário e assim que o
 *                       # 'index' é carregado, o remote-content é invocado para
 *                       # exibir o conteúdo.
 *
 */

function RemoteContent(aRemoteContentContainer, aFilterBar) {
'use strict';

  /* globals */
  var self = this,
      _domRemoteContentContainer = aRemoteContentContainer,
      _domHelper = new DomHelper(_domRemoteContentContainer),
      _urlHelper = new UrlHelper(),
      _domRemoteContentForm = _domHelper.find('form'),
      _remoteContentId = _domRemoteContentContainer.data('remote-content'),
      _domResult = _domHelper.findByData('remote-content-result', _remoteContentId),
      _filterBar = aFilterBar; // para remote contents com filter bar

  /* event handlers */

  // history.back...

  // XXX: esse event handler está fazendo com que em páginas com mais de um
  // remote content, um interfira no outro já que o evento é disparando na
  // window.
  // $(window).bind('popstate', function(aEvent) {
  //   _popRemoteStateAndLoadData(aEvent);
  // });

  // o index será recarregado...

  _domRemoteContentContainer.on('ajax:before', function() {
    _domHelper.fireEvent('remote-content:before');

    _urlHelper.updateUrlParams(_getFormParameters(), false);

    _startLoading();
  });

  _domRemoteContentContainer.on('ajax:success', function(aEvent, aData) {
    // escuta o retorno de um json ou html
    // se não é possível parsear o json o algoritmo entende que o aData é html (catch)
    try {
      var result = $.parseJSON(aData);

      _showJSONResults(result);
    } catch(e) {
      _showResults(aData);
    }

    _domHelper.fireEvent('remote-content:after');
  });

  _domRemoteContentContainer.on('ajax:error', function(aEvent, aXhr, aStatus, aError) {
    _showError(aXhr, aError);
  });

  // usuário clicou no cabeçalho de ordenação de uma tabela dentro do remote
  // content

  _domRemoteContentContainer.on('click', 'th a[data-remote=true]', function(aEvent) {
    _updateUrlAndFilterBarForm($(this).attr('href'));

  });

  // usuário clicou numa página de navegação para remote content

  _domRemoteContentContainer.on('click', '.pagination a[data-remote=true]', function(aEvent) {
    _updateUrlAndFilterBarForm($(this).attr('href'));
  });

  // usuário clicou em limpar filtro e um remote-content com filterbar...

  _domRemoteContentContainer.on('click', '[data-input=clear-filter]', function() {
    if (_filterBar !== undefined) {
      _filterBar.clearFilter();
    }
  });

  // usuário clicou um botão 'Iniciar exportação'
  //
  // aqui precisamos concatenar os parâmentros de dois forms (filter-bar, export-bar) antes do submit
  // Desta forma conseguimos salvar o sql dos dados filtrados em Transparency::Export na index
  _domRemoteContentContainer.on('submit', '[data-form=transparency-export]', function() {
    var exportForm = $(this),
        filterBarContainer = $(document).find('[data-filter-bar]'),
        filterBarForm = filterBarContainer.find('form'),

        urlHelper = new UrlHelper(),
        params = urlHelper.getFormParameters(filterBarForm);

    _updateFormAddParams(params, exportForm);
  });

  /* privates */

  /** loading */

  function _startLoading() {
    _domRemoteContentContainer.attr('data-loading', true);

    _domRemoteContentContainer.find('[data-remote-content-partial]').attr('data-loading', true);
  }

  function _stopLoading() {
    _domRemoteContentContainer.attr('data-loading', false);

    _domRemoteContentContainer.find('[data-remote-content-partial]').attr('data-loading', false);
  }

  /** results */

  function _showResults(aData) {

    /* Precisamos extrair as 'partials' do resultado para que possam ser
     * inseridas em outra parte do DOM. Isso permite que o mesmo resultado
     * de uma requisição traga blocos de DOM (como totalizações, listas e etc.)
     * que podem ser inseridas de modo independente no DOM, sem necessariamente
     * ser no _domResult. Tudo que não estiver como 'partial' será inserido
     * normalmente no _domResult.
     */

    var data = $(aData),
        wrapper = $('<div>');

    wrapper.html(data);

    var partials = wrapper.find('[data-remote-content-partial-target]');

    partials.each(function() {
      var partial = $(this),
          targetId = partial.data('remote-content-partial-target'),
          target = $('[data-remote-content-partial="' + targetId + '"]');

      target.html(partial);
    });

    _domResult.html(wrapper);
    _enableSubmit();
    _stopLoading();
  }

  function _showError(aXhr, aError) {
    _stopLoading();
  }

  function _loadData() {
    if (_domRemoteContentForm.data('remote') === true) {
      _domRemoteContentForm.submit();
    } else {
      //XXX: pre-commit não permite console.lo(g)!
      // console.lo('Form precisa ser remoto. Adicione o data-remote: true.');
    }
  }

  function _updateUrlAndFilterBarForm(aUrl) {
    var params = _urlHelper.getUrlParams(aUrl);

    _urlHelper.updateUrlParams(params, true /* aPushState para adicionar nova entreada no histórico */);

    _updateFilterBarForm(params);
  }

  function _updateFilterBarForm(aParams) {
    // temos que atualizar todos os campos marcados com 'data-remote-content-param'
    // para haver sincronia dos diversos parametros (paginacao, sort, etc...)

    var inputs = _domHelper.find('[data-remote-content-param]');

    inputs.each(function() {
      var input = $(this),
          inputId = input.attr('id'),
          paramValue = aParams[inputId];

        input.val(paramValue);
    });
  }

  function _getFormParameters() {

    var urlParams = _urlHelper.getQueryParameters();

    if (!_urlHelper.paramExists(urlParams, '__')) {
      Object.assign(urlParams, {'__': '__'});
    }

    return urlParams;

  }


  /*
   *
   * Adiciona novos parâmetros ao form
   * aParams   =>  JSON object
   * aForm     =>  DOM element
   *
   */
  function _updateFormAddParams(aParams, aForm) {
    var inputs = [];

    for (var key in aParams) {
      var paramName = aParams[key].name,
          paramValue = aParams[key].value;

      if (paramName === '') { continue; }

      var input = $('<input>').attr('name', paramName).attr('type', 'hidden').val(paramValue);

      inputs.push(input);
    }
    aForm.append(inputs);
  }

  /* Reabilita os botões de submits que possam ter disable-with.
   */
  function _enableSubmit() {
    var inputs = _domHelper.find('input[type=submit]:disabled');

    inputs.prop('disabled', false);
  }

  /*
   * Recarrega dados (com seus filtros e parâmetros de page, sort, etc.) de
   * uma entreada no histórico.
   */
  function _popRemoteStateAndLoadData(aEvent) {
    // aEvent.target.location.search = parametros da url antiga que está sendo 'popped'
    // ex: ?cod_gestora=+&data_assinatura=&data_publicacao_portal=&decricao_modalidade=+&page=17&search=&sort_column=integration_supports_creditors.nome&sort_direction=desc&status=+&tipo_objeto=+
    var params = _urlHelper.getUrlParams(aEvent.target.location.search);

    _updateFilterBarForm(params);

    _loadData();
  }

  /*
   *
   * Trata o retorno do JSON no form
   *
   */
  function _showJSONResults(aData) {
    _enableSubmit();
    _stopLoading();

    if (aData.status === 'success') {
      _showJSONSuccess(aData);
    } else {
      _showJSONErrors(aData);
    }
  }

  /*
   * Trata a validação do form
   *
   * Espera-se:
   * aData   =>    json: { status: string, errors: ActiveModel::Errors, message: [string] }
   */
  function _showJSONErrors(aData) {
    _domRemoteContentContainer.find('[data-alert=error]').show();
    _domRemoteContentContainer.find('[data-message=alert]').text(aData.message);

    // limpa todas as mensagens de erro dos inputs
    _domRemoteContentContainer.find('[data-input-message]').text('');
    $.each(aData.errors, function(i, item) {
      _domRemoteContentContainer.find('[data-input-message=' + i + ']').text(item[0]);
    });
  }

  /*
   * Trata o sucesso do form
   *
   * Espera-se:
   * aData   =>    json: { status: string, message: [string] }
   */
  function _showJSONSuccess(aData) {
    _domRemoteContentContainer.find('[data-link=collapse]').siblings().andSelf().hide();
    _domRemoteContentContainer.find('[data-alert=success]').show();
    _domRemoteContentContainer.find('[data-message=success]').text(aData.message);
  }

  /* setup */

  function _init() {
    _loadData();
  }

  _init();
}
