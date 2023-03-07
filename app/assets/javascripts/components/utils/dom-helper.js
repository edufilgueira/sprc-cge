/**
 * Utilitário com helpers de DOM muito usados pelos componentes.
 *
 * [constructor]
 *
 *  - aContainer: objeto jQuery em que todos os métodos desse utilitário serão
 *      invocados. Assim, o método find faz uma seleção jQuery escopada em
 *      aContainer. O método data, retorna um 'data-attribute' do aContainer.
 *      Isso segue o padrão de componentes da aplicação em que toda informação
 *      relevante deve estar no container máximo do elemento html.
 *
 * [public API]
 *
 *  - find(aSelector): faz uma seleção jQuery escopada por aContainer
 *
 *  - data(aSelector, aValue): retorna ou seta o valor de um data-attribute de
 *      aContainer
 *
 * [exemplo de uso]
 *
 * function MeuComponente(aContainerDoMeuComponente) {
 *    ...
 *
 *    var self = this,
 *        _containerDoMeuComponente = aContainerDoMeuComponente,
 *        _domHelper = new DomHelper(_containerDoMeuComponente);
 *    ...
 *
 *    function _algumFunctionPrivada() {
 *       var elementoLocalAoContainer = _domHelper.find('[data-id=elemento]');
 *       ...
 *    }
 *
 * }
 *
 */

/**
 * @constructor
 *
 * @param {jQuery} aContainer Objeto jQuery que deve ser o escope deste helper.
 * @return {DomHelper}
 */
function DomHelper(aContainer) {
'use strict';

  var self = this,
      _container = aContainer;

  /* public API */

  /**
   * Retorna uma busca jQuery para o selector passado como parâmetro e escopada
   * pelo container.
   *
   * @param {string} aSelector
   * @return {jQuery}
   */
  self.find = function(aSelector) {
    return _find(aSelector);
  };

  /**
   * Retorna uma busca jQuery baseada em data-attributes
   *
   * @param {string} aName Nome da chave usada no atributo data-*
   * @param {string} aValue Valor para match no selector
   * @return {jQuery}
   */
  self.findByData = function(aName, aValue) {
    return _findByData(aName, aValue);
  };

  /**
   * Retorna ou seta o valor de um data-attribute de aContainer
   *
   * @param {string} aName Nome do data attribute (data-nome)
   * @param {object} aValue Valor ou undefined para apenas recuperar o valor.
   * @return {object}
   */
  self.data = function(aName, aValue) {
    return _data(aName, aValue);
  };

  /**
   * Dispara o evento aEventType tendo o container como target
   *
   * @param {string} aEventType
   * @param {array,object} aEventData
   */
  self.fireEvent = function(aEventType, aEventData) {
    return _fireEvent(aEventType, aEventData);
  };

  /* privates */

  function _find(aSelector) {
    // encapsula no try catch para permitir busca com selector inválido
    try {
      return _container.find(aSelector);
    } catch(aException) {

    }

    return [];
  }

  function _findByData(aName, aValue) {
    var selector = '[data-' + aName + '=' + aValue + ']';

    return _find(selector);
  }

  function _fireEvent(aEventType, aEventData) {
    _container.trigger(aEventType, aEventData);
  }

  function _data(aName, aValue) {
    if (undefined === aValue) {
      return _container.data(aName);
    }

    return _container.data(aName, aValue);
  }
}
