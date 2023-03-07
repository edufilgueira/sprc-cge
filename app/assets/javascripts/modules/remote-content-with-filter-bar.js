/*
 * Módulo para carregamento automatico dos RemoteContentWithFilterBar.
 *
 * Utiliza os seguintes parâmetros:
 *
 *   <... data-toggle='remote-content-with-filter-bar'>
 *
 *      <... 'data-remote-content'...
 *
 *         <... 'data-filter-bar'...
 *
 *         <... 'data-remote-content-result'...
 *   [data-content=loading]: Loader para exibir durante a requisição ajax
 */

//= require components/remote-content-with-filter-bar

$(function() {
'use strict';

  // XXX esse carregamento automático tem uma estrutura diferente da sugerida pelo componente/classe
  // RemoteContentWithFilterBar.
  // Para um exemplo dessa estrutura "automática", veja:
  // - admin/organs/index.html.haml
  // Para um exemplo com o componente explícito RemoteContentWithFilterBar, veja:
  // - shared/transparency/covenants/index.html.haml
  $('[data-toggle=remote-content-with-filter-bar]').each(function() {

    var mainContainer = $(this),
        remoteContentContainer = mainContainer.find('[data-remote-content]'),
        filterBarContainer = mainContainer.find('[data-filter-bar]'),
        filterBar = new FilterBar(filterBarContainer),
        remoteContent = RemoteContent(remoteContentContainer, filterBar);
  });
});
