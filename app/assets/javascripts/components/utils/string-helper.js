/**
 * Utilitário com helpers de String muito usados pelos componentes.
 *
 *
 *  - isEmpty(aString): verifica se a string é vazia removendo espaços
 *      duplicados e espeaços no início e fim
 *
 *  - isSameTerm(aTerm, aAnotherTerm): retorna se as strings passadas como
 *      parâmetro são consideradas o mesmo termo. É usado para garantir que
 *      duas buscas igual não sejam feitas. Por exemplo: '  t   e st e' e
 *      'teste' são considerados mesmo termo.
 *
 * [exemplo de uso]
 *
 * function MeuComponente(aContainerDoMeuComponente) {
 *    ...
 *
 *    var self = this,
 *        _containerDoMeuComponente = aContainerDoMeuComponente,
 *        _stringHelper = new StringHelper();
 *    ...
 *
 *    function _algumFunctionPrivada(aParametroString) {
 *       if (_stringHelper.isEmpty(aParametroString)){
 *         return false;
 *       }
 *       ...
 *    }
 *
 *    ...
 * }
 *
 */

/**
 * @constructor
 *
 * @return {StringHelper}
 */
function StringHelper() {
'use strict';

  var self = this;

  /* public API */

  /**
   * Verifica se a string é vazia removendo espaços duplicados e espeaços no
   * início e fim.
   *
   * @param {string} aString
   * @return {boolean}
   */
  self.isEmpty = function(aString) {
    return _isEmpty(aString);
  };

  /**
   * Verifica se dois termos são considerados equivalentes, como ' t e st e  ' e
   * 'teste'.
   *
   * @param {string} aTerm
   * @param {string} aAnotherTerm
   * @return {boolean}
   */
  self.isSameTerm = function(aTerm, aAnotherTerm) {
    return _isSameTerm(aTerm, aAnotherTerm);
  };


  /* privates */

  function _isEmpty(aString) {
    // remove todos os espaços para verificar se a busca é válida e não buscar
    // termos como '    '
    var clearedString = aString.replace(/\s/g, '');

    return (clearedString === '');
  }

  function _isSameTerm(aTerm, aAnotherTerm) {
    var isNullTerm =
        ( (aTerm && !aAnotherTerm) ||
          (aAnotherTerm && !aTerm) );

    if (isNullTerm) {
      return false;
    }

    return (_allTrim(aTerm) === _allTrim(aAnotherTerm));
  }

  /*
   * Limpa espaços duplicados no início e final da string, além dos espaçoes
   * duplicados.
   */
  function _allTrim(aString) {
    return aString.replace(/\s+/g,' ').replace(/^\s+|\s+$/,'');
  }
}
