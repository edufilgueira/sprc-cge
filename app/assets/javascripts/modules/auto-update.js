//= require modules/helpers/dom-helper

/**
 * Componente para a auto-atualização de elementos DOM
 *
 * [constructor]
 *
 *  - aContainer: objeto jQuery englobando todos os elementos auto-atualizáveis.
 *
 * [public API]
 *
 *  - start(): inicia a auto-atualização criando os intervals que farão as
 *    requisições;
 *
 *  - stop(): para a auto-atualização limpando os intervals que faziam as
 *    requisições;
 *
 * [exemplo de uso]
 *
 *  [html]
 *
 * .content{'data-auto-update': 'identificador'}
 *
 *    .updataable-content1{'data-auto-update-url': 'http://...', 'data-auto-update-interval': 4000}
 *    .updataable-content2{'data-auto-update-url': 'http://...'}
 *
 *  ----
 *
 *  [js]
 *
 *   $(function() {
 *   'use strict';
 *
 *    var _domAutoUpdate = $('[data-auto-update=identificador]'),
 *        _autoUpdate = new AutoUpdate(_domAutoUpdate);
 *
 *    //// se os elementos updatables estiverem dentro de um remote-content,
 *    //// é preciso atualizar os bindings quando o remote-content for alterado.
 *
 *    /// antes do remote-content ser carregado, precisamos limpar os bindings do
 *    /// _autoUpdate...
 *
 *    $(document).on('remote-content:before', function() {
 *      _autoUpdate.stop();
 *    });
 *
 *    /// depois do remote-content ser carregado, precisamos reiniciar os bindings
 *    /// do _autoUpdate...
 *
 *    $(document).on('remote-content:after', function() {
 *      _autoUpdate.start();
 *   });
 *
 * [rails]
 *
 *  Nos controllers, pode ser usado em actions index e show, por exemplo.
 *
 *  Na index, deve-se renderizar a partial do recurso quando um params[:id]
 *  for passado. Isso faz com que seja possível atualizar registros de uma lista.
 *
 *  Na show, deve-se renderizar a partial _show quando a request for xhr.
 */

/**
 * @constructor
 *
 * @param {jQuery} aContainer Objeto jQuery que deve englobar todo o componente.
 * @return {AutoUpdate}
 */

function AutoUpdate(aAutoUpdateContainer) {
'use strict';

  var self = this,
      _domAutoUpdateContainer = aAutoUpdateContainer,
      _domHelper = new DomHelper(_domAutoUpdateContainer);

  /* public API */

  /*
   * Inicia o autoupdate criando os Intervals nos elementos
   */
  self.start = function() {
    _start();
  };

  /*
   * Para o autoupdate limpando os Intervals nos elementos
   */
  self.stop = function() {
    _stop();
  };

  /* control */

  function _start() {
    _initUpdatableElements();
  }

  function _stop() {
    _finishUpdatableElements();
  }

  function _getUpdatableElements() {
    return _domHelper.find('[data-auto-update-url]');
  }

  function _getUpdateInterval() {
    return _domHelper.data('auto-update-interval') || 4000;
  }

  /* data */

  function _requestData(aUpdatableElement) {
    var updatableElement = aUpdatableElement,
        url = updatableElement.data('auto-update-url');

    // ignora containers sem url. é uma forma do serverside sinalizar que esse
    // container não precisa mais se auto-atualizar, como quando terminou algum
    // processo em background, por exemplo.
    if (! url) {
      _finishUpdatableElement(updatableElement);

      return;
    }

    if (! _elementIsAttachedToDom(updatableElement)) {
      // esse código continua sendo chamado mesmo para os nós que foram
      // substituídos, causando aumento de requisições a cada resposta.
      // temos que garantir que o elemento está na árvore DOM antes de continuar
      return;
    }

    $.get(url, function(aResult) {
      var oldElement = updatableElement,
          newElement = $(aResult);

      _replaceElement(oldElement, newElement);
    });
  }

  function _replaceElement(aOldElement, aNewElement) {
    _finishUpdatableElement(aOldElement);

    // limpamos a url pois o interval continua sendo chamado em alguns casos
    // e isso garante que não haverá requisição para esse nó
    aOldElement.data('auto-update-url', null);

    aOldElement.replaceWith(aNewElement);

    _initUpdatableElement(aNewElement);
  }

  /* setup */

  function _initUpdatableElement(aUpdatableElement) {
    var updatableElement = aUpdatableElement,
        updateInterval = updatableElement.data('updateInterval');

    if (! _elementIsAttachedToDom(updatableElement)) {
      // esse código continua sendo chamado mesmo para os nós que foram
      // substituídos, causando aumento de requisições a cada resposta.
      // temos que garantir que o elemento está na árvore DOM antes de continuar
      return;
    }

    if (! updateInterval) {
      updateInterval = setInterval(function() {
        _requestData(updatableElement);
      }, _getUpdateInterval());
    }

    updatableElement.data('updateInterval', updateInterval);
  }

  function _elementIsAttachedToDom(aElement) {
    return jQuery.contains(document, $(aElement)[0]);
  }

  function _finishUpdatableElement(aUpdatableElement) {
    var updatableElement = aUpdatableElement,
        updateInterval = updatableElement.data('updateInterval');

    if (updateInterval) {
      clearInterval(updateInterval);
    }

    updatableElement.data('updateInterval', null);
  }

  function _initUpdatableElements() {
    _getUpdatableElements().each(function() {
      _initUpdatableElement($(this));
    });
  }

  function _finishUpdatableElements() {
    _getUpdatableElements().each(function() {
      _finishUpdatableElement($(this));
    });
  }

  function _init() {
    _initUpdatableElements();
  }

  _init();
}
