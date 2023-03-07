//= require components/utils/dom-helper

/*
 *
 * Módulo que manipula eventos de requisições ajax de formulários remotos
 *
 *
 *  [construtor]
 *
 *  - aContainer: Objeto jquery que possui formulário
 *
 *
 * Utiliza os seguintes parâmetros:
 *
 *   [data-content=loading]: Loader para exibir durante a requisição ajax
 *
 */
function RemoteForm(aContainer) {
'use strict';

  // globals

  var _domContainer = aContainer,
      _domHelper = new DomHelper(_domContainer);

  // event handlers

  _domContainer.on('ajax:before', function(aEvent) {
    _startLoading($(aEvent.target));
  });

  _domContainer.on('ajax:success', function(aEvent, aData) {
    _showResults($(this), aData);
  });

  _domContainer.on('ajax:remotipartComplete', function(aEvent, aData) {
    _showResults($(this), aData.responseText);
  });

  // privates

  function _startLoading(aContainer) {
    _getLoader(aContainer).removeClass('hidden-xs-up');
  }

  function _stopLoading(aContainer) {
    _getLoader(aContainer).addClass('hidden-xs-up');
  }

  function _getLoader(aContainer) {
    return aContainer.find('[data-content=loading]');
  }

  function _showResults(aContainer, aData) {
    var container = aContainer;

    container.html(aData);
    _stopLoading(container);

    _domHelper.fireEvent('remote-form:after');
  }
}

/*
 * Inicializador via data-toggle
 *
 *
 *  [construtor]
 */
$(function() {
'use strict';

  $('[data-toggle=remote-form]').each(function() {
    var remoteFormContainer = $(this),
        remoteForm = RemoteForm(remoteFormContainer);
  });

});
