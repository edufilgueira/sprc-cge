//= require components/utils/dom-helper
//= require components/utils/string-helper
//= require components/utils/event-key-helper

//= require ./search-box-view
//= require ./search-box-section

/**
 * Componente responsável por busca em determinada URL que deve retornar os
 * resultados já renderizados (HTML)
 *
 * Possui seções de busca independentes.
 *
 * [constructor]
 *
 * aSearchBoxContainer: objeto jQuery que deve englobar todas as seções de
 *   buscar.
 *
 * [exemplo]
 *
 *  .search-box
 *    %input{ type: 'search' }
 *    .search-box-cancel{ 'data-search-box-cancel': '' }= 'x'
 *
 *    .search-box-sections{ 'data-search-box-sections': '' }
 *      .search-box-section{data: { 'search-box-section': 'server_salary', title: 'Servidores', url: 'global_search?search_group=server_salary' } }
 *
 */

 /* global DomHelper, StringHelper, SearchBoxSection, SearchBoxView,
  * EventKeyHelper
  */

function SearchBox(aSearchBoxContainer) {
'use strict';

  var self = this,
      _domSearchBoxContainer = aSearchBoxContainer,
      _domHelper = new DomHelper(_domSearchBoxContainer),
      _stringHelper = new StringHelper(),
      _searchBoxView = new SearchBoxView(_domSearchBoxContainer),
      _eventKeyHelper = new EventKeyHelper(),
      _searchBoxSections = [],
      _lastSearchTerm = null,
      _nextSearchTerm = null,
      _searchTimeout;

  var FIRST_DELAY_TIME = 4000,
    DELAY_TIME = 10000;

  /* public API */

  self.focus = function() {
    _searchBoxView.focus();
  };

  self.clearSearchWithoutFocusing = function() {
    _clearSearchWithoutFocusing();
  };

  /* event handlers */

  // usuário pressionou alguma tecla em qualquer parte do componente

  _domSearchBoxContainer.on('keyup', function(aEvent) {
    var keyCode = _eventKeyHelper.keyCode(aEvent),
        searchValue = _searchBoxView.getSearchValue();

    if (_searchTimeout) {
      _delayedSearch(searchValue, DELAY_TIME);
    } else {
      _delayedSearch(searchValue, FIRST_DELAY_TIME);
    }
  });

  // a busca foi limpa na view

  _domSearchBoxContainer.on('app:search-box:clear', function(aEvent) {
    _clearSearchStates();
  });

  // usuario pressionou 'F', foco na search bar!

  $(document).on('keypress', function(aEvent) {
    var key = aEvent.which;

    // se o foco estiver em um input, nao movemos no keypress!
    if (aEvent.target.localName === 'input') {
      return;
    }

    if (key === 102 /* f */) {
      // timeout para evitar que o chrome coloque letra F no campo de busca!
      setTimeout(function() {
        $('input[type=search]').focus();
      }, 0);
    }
  });

  /* privates */

  /** search methods */

  function _clearSearch() {
    _searchBoxView.clearSearch();
  }

  function _clearSearchWithoutFocusing() {
    _searchBoxView.clearSearchWithoutFocusing();
  }

  function _clearSearchStates() {
    // limpa todos os estados de busca

    _lastSearchTerm = null;
    _nextSearchTerm = null;
    _searchTimeout = null;

    // limpa todas as secoes
    for (var i = 0; i < _searchBoxSections.length; i++) {
      var searchBoxSection = _searchBoxSections[i];
      searchBoxSection.clear();
    }
  }

  function _delayedSearch(aSearchTerm, aDelayTime) {
    var searchTerm = aSearchTerm,
        delayTime = aDelayTime;

    // nao permite busca de termos vazios
    if (_stringHelper.isEmpty(searchTerm)) {
      return;
    }

    // isso ignora que teclas que não geraram caracteres disparem a busca.
    if (_stringHelper.isSameTerm(searchTerm, _lastSearchTerm)) {
      return;
    }

    // se já existe uma busca corrente, marcamos a próxima busca para quando a
    // atual terminar.
    if (_searchTimeout) {
      _nextSearchTerm = searchTerm;
      return;
    }

    // marcamos o último termo buscado para evitar busca repetida com teclas
    // que não são caracteres

    _lastSearchTerm = searchTerm;

    // exibe as secoes de busca pois vai iniciar...

    _searchBoxView.showSections();

    // timeout de busca para evitar que seja feita uma busca para cada tecla
    // pressionada

    _searchTimeout = setTimeout(function() {

      _searchTimeout = null;

      // se houver outra busca na fila, nem fazemos a atual
      if (_nextSearchTerm) {
        searchTerm = _nextSearchTerm;
        _nextSearchTerm = null;
        _delayedSearch(searchTerm, 0);
        return;
      }

      // a busca será invocada em cada secao de busca
      _search(searchTerm);

    }, delayTime);
  }

  function _search(aSearchTerm) {
    for (var i = 0; i < _searchBoxSections.length; i++) {
      var searchBoxSection = _searchBoxSections[i];
      searchBoxSection.search(aSearchTerm);
    }
  }

  /** setup */

  function _init() {
    _initSearchBoxSections();
  }

  /*
   * Inicializa cada seção de busca, que são responsáveis por requisitar e
   * renderizar os dados relacionados.
   */
  function _initSearchBoxSections() {
    var domSearchBoxSections = _domHelper.find('[data-search-box-section]');

    for (var i = 0; i < domSearchBoxSections.length; i++) {
      var domSearchBoxSection = domSearchBoxSections[i],
          searchBoxSection = new SearchBoxSection($(domSearchBoxSection));

      _searchBoxSections.push(searchBoxSection);
    }
  }

  _init();
}
