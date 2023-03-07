//= require components/filter-bar
//= require components/remote-content

/**
 * Componente helper para remote-content com filter-bar.
 * recurso.
 *
 * A estrutura básica de um remote-content-with-filter-bar, deve ser:
 *
 *  .qualquer-coisa{'remote-content-with-filter-bar': 'identificador-de-seu-remote-e-do-filter-bar'}
 *
 *    [filter-bar-com-mesmo-identificador]
 *    ...
 *    [remote-content-com-mesmo-identificador]
 */

function RemoteContentWithFilterBar(aId) {
'use strict';

  /* instancia os components */

  var _domFilterBar = $('[data-filter-bar=' + aId + ']'),
      _domRemoteContent = $('[data-remote-content=' + aId + ']'),
      _filterBar = new FilterBar(_domFilterBar),
      _remoteContent = new RemoteContent(_domRemoteContent, _filterBar);
}
