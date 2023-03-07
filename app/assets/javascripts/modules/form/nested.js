/**
 * JavaScript com handlers padrão para todos os nested_forms
 */

$(function() {
  'use strict';


  // globals

  var self = this,
      _maskManager = new MaskManager();

  // event_handlers

  $('form').on('cocoon:after-insert', _cocoonAfterInsert);

  // privates

  /// cocoon handlers

  function _cocoonAfterInsert(aEvent, aElement) {

    // atualiza os componentes (máscara, plugins, ...) para o elemento inserido.

    _initMasks(aElement);
  }


  /// masks / plugins

  /*
   * Inicia máscaras e plugins dentro de um container, que é o nested adicionado.
   */
  function _initMasks(aContainer) {
    _maskManager.initMasks(aContainer);
  }

});
