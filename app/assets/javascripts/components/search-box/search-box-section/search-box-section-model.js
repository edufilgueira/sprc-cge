//= require components/utils/dom-helper
//= require components/utils/url-helper

/**
 * Componente responsável por requisitar os dados para a url definida no
 * container.
 *
 * É utilizado por SearchBoxSection para fazer a busca.
 *
 * aSearchBoxSectionContainer: objeto jQuery que deve ter um 'data-url' com a
 *   url responsável por responder com os dados de busca. O termo de busca é
 *   passado pelo parâmetro 'search' da requisição para 'data-url'.
 *
 */

 /* global DomHelper */

function SearchBoxSectionModel(aSearchBoxSectionContainer) {
'use strict';

  var self = this,
      _domSearchBoxSectionContainer = aSearchBoxSectionContainer,
      _domHelper = new DomHelper(_domSearchBoxSectionContainer),
      _urlHelper = new UrlHelper(),
      _sectionUrl = _domHelper.data('url');

  /* public API */

  /*
   * Retorna os resultados de busca retornados pela API em _sectionUrl.
   *
   * aSearchTerm: string com o termo de busca a ser passado para a API
   * aCallback: function que será invocada no final da requisição
   */
  self.getResults = function(aSearchTerm, aCallback) {
    return _getResults(aSearchTerm, aCallback);
  };

  /* privates */

  function _getResults(aSearchTerm, aCallback) {
    var searchTerm = aSearchTerm,
        callback = aCallback;

    $.get(_sectionUrl, { search_term: searchTerm }, function(aResults) {
      return (aCallback && aCallback(aResults));
    });
  }
}
