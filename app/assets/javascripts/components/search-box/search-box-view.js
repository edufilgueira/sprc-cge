//= require components/utils/dom-helper

/**
 * Componente responsável por aspectos da view do search-box, assim como foco e
 * navegacao por teclado.
 *
 * [constructor]
 *
 * aSearchBoxContainer: objeto jQuery que deve englobar todas as seções de
 *   buscar.
 *
 *
 * [events]
 *
 * app:search-box:clear: sinaliza que o termo de busca foi limpo, via ESC ou
 *   botão de cancelar, por exemplo. Serve para que SearchBox saiba que não há
 *   mais termo de busca.
 *
 */

 /* global DomHelper */

function SearchBoxView(aSearchBoxContainer) {
'use strict';

  var self = this,
      _domSearchBoxContainer = aSearchBoxContainer,
      _domHelper = new DomHelper(_domSearchBoxContainer),
      _domSearchInput = _domHelper.find('input[type=search]'),
      _domSearchBoxSections = _domHelper.find('[data-search-box-sections]'),
      _domSearchBoxCancel = _domHelper.find('[data-search-box-cancel]'),
      _domSearchBoxSearch = _domHelper.find('[data-search-box-search]'),
      _eventKeyHelper = new EventKeyHelper();

  /* public API */

  self.focus = function() {
    _focus();
  };

  self.clearSearch = function() {
    _clearSearch();
  };

  self.clearSearchWithoutFocusing = function() {
    _clearSearchWithoutFocusing();
  };

  self.getSearchValue = function() {
    return _getSearchValue();
  };

  self.showSections = function(aCallback) {
    _showSections(aCallback);
  };

  /* event handlers */

  // usuário pressionou alguma tecla em qualquer parte do componente

  _domSearchBoxContainer.on('keyup', function(aEvent) {
    var keyCode = _eventKeyHelper.keyCode(aEvent);

    if (_eventKeyHelper.isDirectionalKeyCode(keyCode)) {
      _handleDirectionalKeyCode(keyCode);
      return false;
    }

    if (_eventKeyHelper.isEscKeyCode(keyCode) || _isSearchEmpty()) {
      _clearSearch();
      return false;
    }

    // exibe/esconde botao de limpar a busca

    _updateCancelButtonVisibility();

  });

  // usuário pressionou botão de cancelar a busca...

  _domSearchBoxCancel.on('click', function(aEvent) {
    _clearSearch();
  });

  // usuário pressionou a lupa, forçamos o foco no campo de busca!

  _domSearchBoxSearch.on('click', function(aEvent) {
    _focus();
  });

  _domSearchInput.on('focus', function(aEvent) {
    _domSearchInput.select();
  });

  /* privates */

  /** search methods */

  function _clearSearch() {
    _clearSearchWithoutFocusing(function() {
      _focus();
    });
  }

  function _clearSearchWithoutFocusing(aCallback) {
    var callback = aCallback;

    _domSearchInput.val('');

    // apenas fechamos a caixa de resultados e sinalizamos o callback
    _domSearchBoxSections.slideUp(function() {

      if (callback) {
        callback();
      }

      _updateCancelButtonVisibility();

      _domSearchBoxContainer.trigger('app:search-box:clear');
    });
  }

  function _getSearchValue() {
    return _domSearchInput.val();
  }

  /*
   * Retorna se o input de busca está vazio
   */
  function _isSearchEmpty() {
    return (_domSearchInput.val() === '');
  }

  /** ui methods */

  function _focus() {
    _domSearchInput.focus();
  }

  function _showSections(aCallback) {
    _domSearchBoxSections.slideDown(function() {
      return (aCallback && aCallback());
    });
  }

  /*
   * Atualiza exibição do botão de cancelar a busca, que só deve ser exibido
   * quando houver texto preenchido no input.
   */
  function _updateCancelButtonVisibility() {
    _domSearchBoxContainer.attr('data-search-value', _domSearchInput.val());
  }

  function _handleDirectionalKeyCode(aKeyCode) {
    var currentFocusedResult = _domHelper.find('.search-box-result:focus'),
        nextFocusedResult = null;

    if (currentFocusedResult.length === 0) {
      _handleFirstFocus(aKeyCode);
    } else {
      // já existe um resultado selecionado mas mesmo assim a seção não foi
      // capaz de tratar o evento e encontrar o próximo foco. Isso indica que
      // o resultado selecionado é o primeiro ou o último de alguma seção.

      _handleNextFocus(currentFocusedResult, aKeyCode);
    }
  }

  function _handleFirstFocus(aKeyCode) {
    var focusedResult = null;

    if (_eventKeyHelper.isKeyDownKeyCode(aKeyCode)) {
      focusedResult = _domHelper.find('.search-box-result:first');
    }

    if (_eventKeyHelper.isKeyUpKeyCode(aKeyCode)) {
      focusedResult = _domHelper.find('.search-box-result:last');
    }

    focusedResult.focus();
  }

  function _handleNextFocus(aCurrentFocusedResult, aKeyCode) {
    var currentFocusedSection = aCurrentFocusedResult.closest('.search-box-section');

    if (_eventKeyHelper.isKeyDownKeyCode(aKeyCode)) {
      _focusNextSection(currentFocusedSection);
    }

    if (_eventKeyHelper.isKeyUpKeyCode(aKeyCode)) {
      _focusPreviousSection(currentFocusedSection);
    }
  }

  function _focusNextSection(aCurrentSection) {
    _focusResult(aCurrentSection.next(), 'first');
  }

  function _focusPreviousSection(aCurrentSection) {
    var previousSection = aCurrentSection.prev();

    if (previousSection.length === 0) {
      previousSection = _domHelper.find('.search-box-section:last');
    }

    if (previousSection.find('.search-box-result').length === 0) {
      return _focusPreviousSection(previousSection);
    }

    _focusResult(previousSection, 'last');
  }

  function _focusResult(aFocusedSection, aPosition) {
    if (aFocusedSection.length === 1) {
      aFocusedSection.find('.search-box-result:' + aPosition).focus();
    } else {
      // está no último da última seção, faz um cycle
      _domHelper.find('.search-box-result:' + aPosition).focus();
    }
  }

  /** setup */

  function _init() {
    _updateCancelButtonVisibility();
  }

  _init();
}
