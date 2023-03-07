/*
 * Módulo com funções básicas de filtros (limpar filtros, ...)
 */

$(function(){
'use strict';

  // globals

  var _domClearFilter = $('[data-input=clear-filter]'),
      _domFilterForm = _getFilterForm(_domClearFilter);

  // event handlers

  /// usuário clicou em 'Limpar filtro'

  _domClearFilter.on('click', function() {
    _clearFilter();
  });

  // privates

  function _clearFilter() {
    _resetForm();
    _submitForm();
  }

  function _resetForm() {
    var inputs = _getFormInputsToReset(),
        selects = _domFilterForm.find('select, [data-remote-select2]');

    _clearInput(inputs);
    _clearSelect(selects);
  }

  function _getFormInputsToReset() {
    var selector = 'input:text, input:checkbox, input:hidden:not([data-filter=permanent])';

    return _domFilterForm.find(selector);
  }

  function _clearInput(aInput) {
    aInput.val('');
  }

  function _submitForm() {
    _domFilterForm.submit();
  }

  function _clearSelect(aSelect) {
    // jeito normal para limpar...
    aSelect.val('');

    // jeito select2 para limpar...
    aSelect.select2('val', '');
    aSelect.find('option').prop('selected', false);
  }

  function _getFilterForm() {
    var form = _domClearFilter.closest('form');

    if (form.length > 0) {
      return form;
    }

    return _getFormFromRemoteContent();
  }

  function _getFormFromRemoteContent() {
    // caso esteja em um remote-content, o 'clear' está fora do form.

    var remoteContent = _domClearFilter.closest('[data-remote-content]'),
        form = remoteContent.find('form');

    return form;
  }

});
