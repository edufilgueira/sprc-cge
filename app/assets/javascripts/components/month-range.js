/*
 * Componente responsável em controlar o range de meses
 *
 * params:
 * aContainer       :     input do elemento alterado
 *
 */
function MonthRange(aContainer) {
  'use strict';


  /* globals */

  var self = this,
      aInputChanged = aContainer;


  /* API pública */

  self.validate = _validate;


  /* privates */

  // garante que o mês de inicio não será maior que o mês final no filtro de estatísticas de transparência
  function _validate() {
    var inputChanged = aInputChanged,
        monthStart = (inputChanged.data('stats-month') == 'start'),
        inputChangedVal = parseInt(inputChanged.val()),
        inputChangedSiblingPosition = (monthStart == true) ? 'end' : 'start',
        inputChangedSibling = inputChanged.parents('[data-container=month-range]').find('[data-stats-month=' + inputChangedSiblingPosition + ']'),
        inputChangedSiblingVal = parseInt(inputChangedSibling.val());

    // se o mês inicial setado for maior que o mês final, o mês final fica igual ao inicial setado.
    // se o mês final setado for menor que o mês inicial, o mês inicial fica igual ao final setado.
    if (((inputChangedVal > inputChangedSiblingVal) && (monthStart == true)) || ((inputChangedVal < inputChangedSiblingVal) && (monthStart == false))) {
      inputChangedSibling.val(inputChangedVal);
      inputChangedSibling.trigger('change.select2');
    }
  }
}
