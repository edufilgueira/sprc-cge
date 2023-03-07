/**
*
* Workaround para corrigir problema do Bootstrap de seleção de raio-buttons pelo teclado quando usado com btn-group
*
* @see https://github.com/twbs/bootstrap/issues/18874
* @see https://github.com/twbs/bootstrap/issues/23728
*
*
* Parâmetros necessários:
*   [data-toggle=radio-buttons] = wrapper dos botões
*
*
* Ex.:
*
*   <div class="btn-group" data-toggle="radio-buttons">
*     <label class="btn btn-outline-primary">
*       <input type="radio" name="radio_1" value="1">
*       Radio 1
*     </label>
*     <label class="btn btn-outline-primary">
*       <input type="radio" name="radio_2" value="2">
*       Radio 2
*     </label>
*     <label class="btn btn-outline-primary">
*       <input type="radio" name="radio_3" value="3">
*       Radio 3
*     </label>
*   </div>
*
*/
$(function() {
'use strict';

  // @see Bootstrap.Button.Event
  var Event = {
    CLICK_DATA_API: 'click.bs.button.data-api',
    FOCUS_BLUR_DATA_API: 'focus.bs.button.data-api blur.bs.button.data-api'
  };

  // @see Bootstrap.Button.Selector
  var Selector = {
    DATA_TOGGLE: '[data-toggle="radio-buttons"]',
    FOCUS_BLUR_DATA_API: 'focus.bs.button.data-api blur.bs.button.data-api',
    INPUT: 'input[type=radio]',
    ACTIVE: '.active',
    BUTTON: '.btn'
  };

  // @see Bootstrap.Button.ClassName
  var ClassName = {
    ACTIVE: 'active',
    BUTTON: 'btn',
    FOCUS: 'focus'
  };

  // event handlers

  $('form').on('cocoon:after-insert', _initRadioButtonGroup);

  // private

  function _initRadioButtonGroup() {
    var buttons = $(Selector.DATA_TOGGLE).find(Selector.BUTTON),
      inputs = $(Selector.DATA_TOGGLE).find(Selector.INPUT);

    buttons.on(Event.CLICK_DATA_API, function (event) {
      var button = event.target;

      if (!$(button).hasClass(ClassName.BUTTON)) {
        button = $(button).closest(Selector.BUTTON);
      }

      _radioToggle(button);
    });

    inputs.on(Event.FOCUS_BLUR_DATA_API, function (event) {
      var button = $(event.target).closest(Selector.BUTTON)[0];
      $(button).toggleClass(ClassName.FOCUS, /^focus(in)?$/.test(event.type));
    });
  }


  // @see Bootstrap.Button.prototype.toogle
  function _radioToggle(aContainer) {
    var container = aContainer,
      button = $(container),
      rootElement = button.closest(Selector.DATA_TOGGLE)[0],
      input = button.find(Selector.INPUT)[0],
      activeButton = button.hasClass(ClassName.ACTIVE);

    if (rootElement && input) {
        var triggerChangeEvent = !(input.checked && activeButton),
          activeElement = $(rootElement).find(Selector.ACTIVE)[0];

      if (triggerChangeEvent) {

        if (activeElement) {
          $(activeElement).removeClass(ClassName.ACTIVE);
        }

        input.checked = !activeButton;
        $(input).trigger('change');

        button.toggleClass(ClassName.ACTIVE);
      }

      input.focus();

      button.attr('aria-pressed', !activeButton);
      button.siblings().attr('aria-pressed', activeButton);
    }
  }

  // setup
  function _init() {
    _initRadioButtonGroup();
  }

  _init();
});
