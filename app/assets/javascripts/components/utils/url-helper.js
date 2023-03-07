/**
 * Utilitário com helpers para tratar de url, window.location, window.history,
 * etc.
 */

/**
 * @constructor
 */
function UrlHelper() {
'use strict';

  /* constants */

  var QUERY_PARAMETERS_REGEX = new RegExp('([^?=&]+)(=([^&]*))?', 'g');

  var self = this;

  /* public API */

  /**
   * Retorna um hash para os parametros da url (window.location.search).
   * Ex: http://minha.url?filtro1=a&filtro2=b
   *     > { 'filtro1': 'a', 'filtro1': 'b' }
   */
  self.getQueryParameters = function() {
    return _getQueryParameters();
  };

  /**
   * Retorna um hashmap com os parametros mapeados da url passada
   */
  self.getUrlParams = function(aUrl) {
    return _getUrlParams(aUrl);
  };

  /**
   * Atualiza os parametros da URL através de replaceState para não haver
   * reload da página.
   */
  self.updateUrlParams = function(aParams, aPushState, aStateData) {
    _updateUrlParams(aParams, aPushState, aStateData);
  };

  /**
   * Atualiza a URL através de replaceState para não haver reload da página.
   */
  self.updateUrl = function(aUrl, aPushState, aStateData) {
    _updateUrl(aUrl, aPushState, aStateData);
  };

  /**
   * Atualiza a hash da página corrente.
   */
  self.updateHash = function(aHash, aPushState, aStateData) {
    _updateHash(aHash), aPushState;
  };

  /**
   * Retorna os valores do form como parâmetro da URL
   */
  self.getFormParameters = function(aForm) {
    return _getFormParameters(aForm);
  };

  /**
   * retorna a url da show
   */
  // XXX: isso não deveria ser feito dessa forma. Temos que passar a
  // url pronta para o javascript usar (via data-attribute de algum
  // element envolvido).
  self.getShowUrl = function(aId) {
    return _getShowUrl(aId);
  };


  /**
   * verifica se o parametro está contido
   */
  self.paramExists = function(aResult, aParamName) {
    return _paramExists(aResult, aParamName);
  }

  /* privates */

  function _updateUrlParams(aParams, aPushState, aStateData) {
    var decodedParams = '?' + decodeURIComponent($.param(aParams));

    // atualiza a location sem reload e sem incrementar o history.

    _updateUrl(decodedParams, aPushState, aStateData);
  }

  function _updateUrl(aUrl, aPushState, aStateData) {
    if (aPushState) {
      window.history.pushState(aStateData, window.title, aUrl);
    } else {
      window.history.replaceState({}, window.title, aUrl);
    }

    // atualiza tag de open_graph para refletir a nova location.search

    $('meta[property="og:url"]').attr('content', window.location);
  }

  function _updateHash(aHash, aPushState, aStateData) {
    // window.location = '#' + aHash;

    if (aPushState) {
      window.history.pushState(aStateData, window.title, aUrl);
    } else {
      window.history.replaceState({}, window.title, '#' + aHash);
    }
  }

  function _getFormParameters(aForm) {
    var params = aForm.serializeArray();

    // temos que inserir um outro parâmetros pois a url será alterada (History
    // API) e alguns navegadores irão cachear o resultado do AJAX pela sua url.
    // Quando a API encontrar o cache com a mesma url, irá renderizar o json
    // resultado do AJAX e não a página original.
    params.push({ '__': '__' });
    return params;
  }

  function _getUrlParams(aUrl) {
    var result = {},
        params = aUrl.slice(aUrl.indexOf('?') + 1).split('&');

    for (var i = 0; i < params.length; i++) {
      var param = params[i].split('=');

      result[param[0]] = param[1];
    }

    return result;
  }

  function _getQueryParameters() {
    var queryString = window.location.search,
        params = {};

    queryString.replace(QUERY_PARAMETERS_REGEX, function($0, $1, $2, $3) {
      params[$1] = $3;
    });

    return params;
  }

  // XXX: isso não deveria ser feito dessa forma. Temos que passar a
  // url pronta para o javascript usar (via data-attribute de algum
  // element envolvido).
  function _getShowUrl(aId) {
    var id = aId;

    return window.location.pathname + '/' + id;
  }

  function _paramExists(aResult, aParamName) {
    for (var i = 0; i < aResult.length; i++) {
      var item = aResult[i];

      if (item.name === aParamName) {
        return true;
      }
    }

    return false;
  }
}
