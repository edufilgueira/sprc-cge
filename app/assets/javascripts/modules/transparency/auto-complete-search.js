//= require modules/auto-complete

/*
 *
 * Módulo que controla o front-end da busca com auto complete
 *
 */

$(function() {
  'use strict';

  var _domCreditorNameInput = $('[data-content=creditor]'),
      creditorNameAutoComplete = new AutoComplete(_domCreditorNameInput, { searchDelay: 1000 });
});
