//= require components/remote-content-with-filter-bar
//= require components/google-map/constructions-dae-map

/**
 * JavaScript de shared/transparency/constructions/daes#index
 */

$(function() {
'use strict';

  var _daes = new RemoteContentWithFilterBar('daes'),
      _daesStats = new RemoteContentWithFilterBar('daes_stats');

  $('[data-remote-content=constructions_daes]').on('remote-content:after', function() {
    var _domGoogleMapContainer = $('[data-google-map=map]'),
        _googleMap = new ConstructionsDaeMap(_domGoogleMapContainer);
  });
});
