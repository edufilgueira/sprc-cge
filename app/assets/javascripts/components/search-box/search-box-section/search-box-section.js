//= require ./search-box-section-model
//= require ./search-box-section-view

/**
 * Componente responsável por representar uma seção de busca.
 *
 * [constructor]
 *
 * aSearchBoxSectionContainer: objeto jQuery representando uma seção de busca e
 *   que deve ter todos os [attributes] definidos.
 *
 * [attributes]
 *
 * data-search-box-section: 'identificador da seção'
 * data-title: 'título da seção'
 * data-url: 'url com os dados da seção'
 */

 /* global SearchBoxSectionModel, SearchBoxSectionView */

function SearchBoxSection(aSearchBoxSectionContainer) {
'use strict';

  var self = this,
      _domSearchBoxSectionContainer = aSearchBoxSectionContainer,
      _searchBoxSectionModel = new SearchBoxSectionModel(_domSearchBoxSectionContainer),
      _searchBoxSectionView = new SearchBoxSectionView(_domSearchBoxSectionContainer),
      _currentSearchingTerm = null,
      _nextSearchingTerm = null;

  /* public API */

  self.search = function(aSearchTerm) {
    return _search(aSearchTerm);
  };

  self.clear = function() {
    return _clear();
  };

  /* privates */

  /** search methods */

  function _search(aSearchTerm) {
    var searchTerm = aSearchTerm;


    if (_currentSearchingTerm === null) {

      _nextSearchingTerm = null;
      _currentSearchingTerm = searchTerm;

      _domSearchBoxSectionContainer.attr('loading', 'true');

      _searchBoxSectionModel.getResults(searchTerm, function(aResults) {

        _currentSearchingTerm = null;

        if (_nextSearchingTerm) {

          return _search(_nextSearchingTerm);

        } else {

          _domSearchBoxSectionContainer.attr('loading', 'false');
          _searchBoxSectionView.setResults(aResults);

        }

      });
    } else {

      // Ainda não retornou a última busca. Aguardamos para buscar novamente.
      _nextSearchingTerm = aSearchTerm;
    }
  }

  function _clear() {
    _currentSearchingTerm = null,
    _nextSearchingTerm = null;
    _searchBoxSectionView.clearResults();
  }
}
