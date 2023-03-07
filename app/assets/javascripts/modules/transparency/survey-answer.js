/*
 *
 * Módulo que controla o front-end da pesquisa de satisfação de transparência
 *
 */

$(function() {
'use strict';

  var _domInputRadio = $('[data-content=transparency-survey-answer] input[type=radio]'),
    _domCancelButton = $('[data-content=transparency-survey-answer] [data-input=cancel-button]'),
    _domIconSurvey = $('[data-input=icon_survey]');

  // precisamos do evento no documento pois o conteúdo é renderizado via ajax
  // e os event_listeners se perdem.

  _domInputRadio.on('change', function() {
    var radio = $(this),
      container = radio.closest('[data-content=transparency-survey-answer]');

    _updateComplements(container);
    _changeAllgray();
    _removeGray(radio.parent().find('[data-input=icon_survey]'));
  });

  _domCancelButton.on('click', function() {
    var cancelButton = $(this),
      container = cancelButton.closest('[data-content=transparency-survey-answer]');

    _uncheckOptions(container);
    _updateComplements(container);
    _changeAllgray();
  });

  function _updateComplements(aContainer) {
    var container = aContainer,
        value = container.find('input[type=radio]:checked').val(),
        complementsContainer = container.find('[data-content=transparency-survey-answers-complements]');

    if (value === undefined) {
      complementsContainer.hide();
    } else {
      complementsContainer.show();
    }
  }

  function _uncheckOptions(aContainer) {
    var radio = aContainer.find('input[type=radio]');

    radio.prop('checked', false);
  }

  function _changeAllgray() {
    _domIconSurvey.each(function() {
      _grayscale($(this), '100');
    });
  }

  function _removeGray(element) {
    _grayscale(element, '0');
  }

  function _grayscale(element, value) {
    element.css("-webkit-filter", "grayscale(" + value + "%)");
  }

  function _init(){
    _changeAllgray();
  }

  _init();
});
