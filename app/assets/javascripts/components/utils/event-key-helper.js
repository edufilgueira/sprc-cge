/**
 * Componente utilitário para tratamento de teclas.
 */

function EventKeyHelper() {
'use strict';

  /* consts */
  var KEY_CODES = {
    'enter': 13,
    'esc': 27,
    'key_up': 38,
    'key_down': 40
  };

  /* globals */

  var self = this;

  /* public API */

  self.keyCode = function(aKeyCode) {
    return _keyCode(aKeyCode);
  };

  self.isCharKeyCode = function(aKeyCode) {
    return _isCharKeyCode(aKeyCode);
  };

  self.isEnterKeyCode = function(aKeyCode) {
    return (aKeyCode === KEY_CODES.enter);
  };

  self.isEscKeyCode = function(aKeyCode) {
    return (aKeyCode === KEY_CODES.esc);
  };

  self.isKeyUpKeyCode = function(aKeyCode) {
    return _isKeyUpKeyCode(aKeyCode);
  };


  self.isKeyDownKeyCode = function(aKeyCode) {
    return _isKeyDownKeyCode(aKeyCode);
  };

  self.isDirectionalKeyCode = function(aKeyCode) {
    return (_isDirectionalKeyCode(aKeyCode));
  };

  /* private */

  /*
   * Retorna o código da tecla de determinado evento (cross-browser).
   */
  function _keyCode(aEvent) {
    return (aEvent.keyCode ? aEvent.keyCode : aEvent.which);
  }

  /*
   * Retorna se a tecla pressionada é alguma das direcionais
   */
  function _isDirectionalKeyCode(aKeyCode) {
    return (_isKeyDownKeyCode(aKeyCode) || _isKeyUpKeyCode(aKeyCode));
  }

  function _isKeyDownKeyCode(aKeyCode) {
    return (aKeyCode === KEY_CODES.key_down);
  }

  function _isKeyUpKeyCode(aKeyCode) {
    return (aKeyCode === KEY_CODES.key_up);
  }

  /*
   * Retorna se a tecla pressionada corresponde a algum caracter visívei
   */
  function _isCharKeyCode(aKeyCode) {
    return (aKeyCode >= 65 && aKeyCode <= 90);
  }
}
