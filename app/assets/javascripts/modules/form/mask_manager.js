/**
 * JavaScript central para tratamento das máscaras
 */

//= require maskedinput

function MaskManager() {
'use strict';

  // globals

  var self = this;

  // public

  /*
   * Atualiza as máscaras para os campos que estiverem dentro de aContainer.
   * Caso aContainer seja null, será considerado $(document).
   * aContainer é usado para nested inseridos depois do load.
   */
  self.initMasks = function(aContainer) {
    _initMasks(aContainer);
  }

  // privates

  function _initMasks(aContainer) {
    _initCpfMasks(aContainer);
    _initPhoneMasks(aContainer);
    _initZipcodeMasks(aContainer);
    _initDateTimePicker();
    _initMonthDateTimePicker();
    _initYearDateTimePicker();
    _initDateTimePickerWithTime();
  }

  /// masks / plugins

  function _initDateTimePicker() {
    _dateTimePicker('input.datetimepicker', 'DD/MM/YYYY', '99/99/9999');
  }

  function _initDateTimePickerWithTime() {
    _dateTimePicker('input.datetimepicker-time', 'DD/MM/YYYY HH:mm', '99/99/9999 99:99');
  }

  function _initMonthDateTimePicker() {
    _dateTimePicker('input.month-datetimepicker', 'MM/YYYY', '99/9999');
  }

  function _initYearDateTimePicker() {
    _dateTimePicker('input.year-datetimepicker', 'YYYY', '9999');
  }

  function _dateTimePicker(aSelector, aFormat, aMaskFormat) {
    var inputs = $(aSelector);

    inputs.datetimepicker({
      format: aFormat,
      icons: _dateTimePickerIcons(),
      sideBySide: true
    });

    _initMaskForInputs(aSelector, aMaskFormat);
  }

  function _dateTimePickerIcons() {
    return {
      time: 'fa fa-clock-o',
      date: 'fa fa-calendar',
      up: 'fa fa-arrow-up',
      down: 'fa fa-arrow-down',
      previous: 'fa fa-arrow-left',
      next: 'fa fa-arrow-right',
      today: 'fa fa-screenshot',
      clear: 'fa fa-trash',
      close: 'fa fa-remove'
    }
  }

  function _initCpfMasks(aContainer) {
    _initMaskForInputs('[data-mask=cpf]', '999.999.999-99');
  }

  function _initPhoneMasks(aContainer) {
    var inputs = aContainer.find('[data-mask=phone]');

    _initMaskForInputs('[data-mask=phone]', '(99) 9?9999-9999');

    inputs.on('blur', function() {
      var input = $(this);

      _initVariableLengthPhoneValue(input);
    });

    _initVariableLengthPhoneInputs(inputs);
  }

  function _initVariableLengthPhoneInputs(aInputs) {
    for (var i = 0; i < aInputs.length; i++) {
      _initVariableLengthPhoneValue($(aInputs[i]));
    }
  }

  /*
   * Ajusta o valor de campos de telefone com tamanhos variáveis
   * ex: (19) 1234-5678 e (19) 91234-5678 devem ser aceitos.
   */
  function _initVariableLengthPhoneValue(aInput) {
    var input = aInput,
        value = input.val(),
        last = value.substr( value.indexOf('-') + 1 );

    if (last.length === 3) {
      var move = value.substr( value.indexOf('-') - 1, 1 ),
          lastfour = move + last,
          first = value.substr( 0, 9 );

      input.val(first + '-' + lastfour);
    }
  }

  function _initZipcodeMasks(aContainer) {
    _initMaskForInputs('[data-mask=zipcode]', '99999-999');
  }

  function _initMaskForInputs(aInputs, aMask) {
    var inputs = $(aInputs);

    inputs.mask(aMask, { autoclear: false });
  }
}

/*
 * Autoloader para o componente.
 */
$(function() {
  /// setup

  function _init() {
    var maskManager = new MaskManager(),
        container = $(document);

    maskManager.initMasks(container);
  }

  _init();
});
