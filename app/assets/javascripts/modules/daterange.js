$(function() {
'use strict';

  var _domDateRangeInput = $('[data-input="daterangepicker"]');

  _domDateRangeInput.daterangepicker({
    'autoUpdateInput': false,

    'locale': {
      'format': 'DD/MM/YYYY',
      'separator': ' - ',
      'applyLabel': 'Aplicar',
      'cancelLabel': 'Cancelar',
      // 'fromLabel': 'From',
      // 'toLabel': 'To',
      // 'customRangeLabel': 'Custom',
      'daysOfWeek': [
        'Dom',
        'Seg',
        'Ter',
        'Qua',
        'Qui',
        'Sex',
        'Sab'
      ],
      'monthNames': [
        'Janeiro',
        'Fevereiro',
        'Março',
        'Abril',
        'Maio',
        'Junho',
        'Julho',
        'Agosto',
        'Setembro',
        'Outubro',
        'Novembro',
        'Dezembro'
      ],
      'firstDay': 1
    }
  });

  // events

  _domDateRangeInput.on('apply.daterangepicker', function(ev, picker) {
    $(this).val(picker.startDate.format('DD/MM/YYYY') + ' - ' + picker.endDate.format('DD/MM/YYYY'));
  });

  _domDateRangeInput.on('cancel.daterangepicker', function(ev, picker) {
    $(this).val('');
  });
});
