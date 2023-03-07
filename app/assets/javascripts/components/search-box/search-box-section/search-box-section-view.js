//= require components/utils/dom-helper

/**
 * Componente responsável por exibir uma seção de busca e seus resultados.
 *
 * É utilizado por SearchBoxSection.
 *
 * [constructor]
 *
 * aSearchBoxSectionContainer: objeto jQuery representando uma seção de busca e
 *   que deve ter todos os [attributes] definidos.
 *
 * [attributes]
 *
 * data-title: 'título da seção'
 */

 /* global DomHelper */

function SearchBoxSectionView(aSearchBoxSectionContainer) {
'use strict';

  /* constants */

  var DOM_CLASSES = {
        'section': 'search-box-section-results',
        'section_title': 'search-box-section-title',
        'section_loading': 'search-box-section-loading',
        'results_content': 'search-box-results-content',
        'result': 'search-box-result'
      };

  /* globals */

  var self = this,
      _domSearchBoxSectionContainer = aSearchBoxSectionContainer,
      _domHelper = new DomHelper(_domSearchBoxSectionContainer),
      _eventKeyHelper = new EventKeyHelper(),
      _sectionTitle = _domHelper.data('title');

  /* public API */

  /*
   * Exibe os resultados passados como parâmetro, ou a mensagem de nenhum
   * resultado encontrado.
   */
  self.setResults = function(aResults) {
    _setResults(aResults);
  };

  /*
   * Limpa o container de resultados, removendo os existentes
   */
  self.clearResults = function() {
    _clearResults();
  };

  self.getFocusedResult = function() {
    return _getFocusedResult();
  };

  self.getNextFocusedResult = function() {
    return _getNextFocusedResult();
  };

  self.getPreviousFocusedResult = function() {
    return _getPreviousFocusedResult();
  };

  self.getFirstResult = function() {
    return _getFirstResult();
  };

  self.getLastResult = function() {
    return _getLastResult();
  };

  /* event handlers */


  // usuário pressionou alguma tecla em qualquer parte do componente
  // precisamos ouvir o keydown e o keyup.
  //
  // o keydown serve para previnir o comportamento padrao das teclas para cima
  // e para baixo e evitar o scroll na página quando o usuário estiver
  // navegando por resultados de busca.
  //

  function _sharedKeyHandler(aEvent) {
    var keyCode = _eventKeyHelper.keyCode(aEvent);

    if (_eventKeyHelper.isDirectionalKeyCode(keyCode)) {
      aEvent.preventDefault();
      return false;
    }
  }

  _domSearchBoxSectionContainer.on('keydown', function(aEvent) {
    _sharedKeyHandler(aEvent);
  });

  _domSearchBoxSectionContainer.on('keyup', function(aEvent) {
    var keyCode = _eventKeyHelper.keyCode(aEvent);

    _sharedKeyHandler(aEvent);

    if (_eventKeyHelper.isDirectionalKeyCode(keyCode)) {

      // se o _handle retorna true, indica que o keyCode foi tratado por este
      // componente. No caso de retornar false, indica que o evento pode ser
      // tratado pelo componente parent, como o SearchBox.
      if (_handleDirectionalKeyCode(keyCode)) {

        return false;
      }
    }
  });

  /* privates */

  /*
   * Exibe os resultados passados como parâmetro, ou a mensagem de nenhum
   * resultado encontrado.
   */
  function _setResults(aResults) {
    var results = aResults,
        focusedResultHref = _getFocusedResultHref(),
        resultsContainer = _getResultsContainer();

    _clearResults();

    resultsContainer.append(results);

    if (focusedResultHref) {
      // restaura o foco no resultado selecionado antes dos novos resultados!
      _focusResultByHref(focusedResultHref);
    }
  }

  /*
   * Limpa o container de resultados, removendo os existentes
   */
  function _clearResults() {
    _domHelper.find(_domSelector('results_content')).html('');
  }

  /* dom methods */

  /*
   * Retorna o container de resultados da seção de busca.
   * Caso o container ainda não exista, é criado um novo.
   *
   */
  function _getResultsContainer() {
    var resultsContainer = _domHelper.find(_domSelector('section'));

    if (resultsContainer.length === 0) {
      resultsContainer = _newResultsContainerElement();

      _domSearchBoxSectionContainer.append(resultsContainer);
    }

    return resultsContainer.find(_domSelector('results_content'));
  }

  function _getFocusedResult() {
    return _domHelper.find('.search-box-result:focus');
  }

  function _getFocusedResultHref() {
    var result = _getFocusedResult();

    if (result.length === 1) {
      return result.attr('href');
    }

    return null;
  }

  function _focusResultByHref(aHref) {
    var result = _domHelper.find('.search-box-result[href="' + aHref + '"]');

    if (result.length === 1) {
      result.focus();
    }
  }

  function _getNextFocusedResult() {
    var focusedResult = _getFocusedResult();

    if (focusedResult.length === 1) {
      return focusedResult.closest('li').next('li').find(_domSelector('result'));
    }
  }

  function _getPreviousFocusedResult() {
    var focusedResult = _getFocusedResult();

    if (focusedResult.length === 1) {
      return focusedResult.closest('li').prev('li').find(_domSelector('result'));
    }
  }

  function _getFirstResult() {
    return _domHelper.find('.search-box-result:first a');
  }

  function _getLastResult() {
    return _domHelper.find('.search-box-result:last a');
  }

  /* ui builder methods */

  function _newResultsContainerElement() {
    var containerElement = $('<div></div>'),
        titleElement = $('<div></div>'),
        loadingElement = $('<span></span>'),
        resultsContentElement = $('<div></div>');

    containerElement.addClass(DOM_CLASSES.section);


    titleElement.addClass(DOM_CLASSES.section_title);
    containerElement.append(titleElement);
    titleElement.html(_sectionTitle);

    loadingElement.addClass(DOM_CLASSES.section_loading);
    titleElement.append(loadingElement);
    loadingElement.html('<i class="fa fa-spin fa-refresh"></i>');

    resultsContentElement.addClass(DOM_CLASSES.results_content);
    containerElement.append(resultsContentElement);

    return containerElement;
  }

  /* ui focus methods */

  function _handleDirectionalKeyCode(aKeyCode) {
    var focusedResult = _getFocusedResult(),
        defaultNextFocusedResult = null,
        nextFocusedResult = null;

    // só tratamos o evento de tecla de direcao na propria secao já ha um
    // resultado com foco. Quando ainda não há um resultado com foco, quem deve
    // tratar esse evento e decidir que deve receber o foco é o objeto parent
    // que é o SearchBox.

    if (focusedResult.length === 1) {

      if (_eventKeyHelper.isKeyDownKeyCode(aKeyCode)) {
        nextFocusedResult = _getNextFocusedResult();
      }

      if (_eventKeyHelper.isKeyUpKeyCode(aKeyCode)) {
        nextFocusedResult = _getPreviousFocusedResult();
      }

      if (nextFocusedResult && nextFocusedResult.length > 0) {
        nextFocusedResult.focus();

        // indica que a tecla FOI tratada nesse componente pois encontrou o
        // próximo foco
        return true;
      }
    }

    // indica que a tecla NÃO FOI tratada nesse componente pois nao
    // conseguiu achar um próximo resultado para dar o foco.
    // O evento será tratado por SearchBox que decidirá quem recebe o foco.
    return false;
  }

  /*
   * Retorna o selector para determinada classe identificada pelo id em
   * DOM_CLASSES
   */
  function _domSelector(aClassId) {
    return '.' + DOM_CLASSES[aClassId];
  }

  /* setup */

  function _initResultsContainer() {
    // força a criação do resultsContainer para exibir o load na primeira busca.
    // caso contrário, o resultsContainer só seria criado na resposta da
    // primeira busca e o usuário não veria o loading.

    var resultsContainer = _getResultsContainer();
  }

  function _init() {
    _initResultsContainer();
  }

  _init();
}
