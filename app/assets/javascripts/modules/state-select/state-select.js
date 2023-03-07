/**
 *
 * Módulo que carrega municipios por Estado
 *
 *
 *  [construtor]
 *
 *  - aContainer: Objeto jquery que possui componente
 *
 *
 * Utiliza os seguintes parâmetros:
 *
 *   [data-cities-container] : id do container que exibirá os municipios
 *   [data-url]              : url da requisição ajax
 *   [data-content=loading]  : Loader para exibir durante a requisição ajax
 *
 */
function StateSelect(aContainer) {
'use strict';

  // globals

  var _domContainer = aContainer,
      _domCitiesContainer = $('#' + _domContainer.data('cities-container')),

    _url = _domContainer.data('url'),
    _domLoader = _domContainer.parent().find('[data-content=loading]');

  // event handlers

  _domContainer.on('change', function() {
    _getCities();
  });

  // privates

  function _startLoading() {
    _domLoader.removeClass('hidden-xs-up');
  }

  function _stopLoading() {
    _domLoader.addClass('hidden-xs-up');
  }

  function _getCities() {
    $.ajax({
      url: _url,
      data: { state: _domContainer.val() },
      beforeSend: function() {
        _clearCities();
        _startLoading();
      },
      success: function(aData) {
        _showResults(aData);
      },
      complete: function() {
        _stopLoading();
      }
    });
  }

  function _showResults(aData) {
    var container = _domContainer,
      citiesContainer = _domCitiesContainer,
      data = aData,
      options = '<option value=""></option>';

    $.each(data, function(index, city){
      options += '<option value="' + city.id + '">' + city.name + '</option>';
    });

    citiesContainer.html(options);

    if (data.length > 0) {
      _enableCitiesContainer();
    }

    container.trigger('after:cities:load');
  }

  function _clearCities() {
    var citiesContainer = _domCitiesContainer;

    citiesContainer.val('').html('').change();
    _disableCitiesContainer();
  }

  function _disableCitiesContainer() {
    var citiesContainer = _domCitiesContainer;

    if (citiesContainer.val() === '' || citiesContainer.val() === null) {
      citiesContainer.prop("disabled", true);
    }
  }

  function _enableCitiesContainer() {
    var citiesContainer = _domCitiesContainer;

    if (citiesContainer.val() === '') {
      citiesContainer.prop("disabled", false);
    }
  }

  function _init() {
    if (_domContainer.val() === '') {
      _disableCitiesContainer();
    }
  }

  _init();
}
