//= require components/remote-content-with-filter-bar
//= require components/google-map/constructions-der-map

/**
 * JavaScript de shared/transparency/constructions/ders#index
 */

$(function() {
'use strict';

  var _ders = new RemoteContentWithFilterBar('ders'),
      _dersStats = new RemoteContentWithFilterBar('ders_stats');

  $('[data-remote-content=constructions_ders]').on('remote-content:after', function() {
    var _domGoogleMapContainer = $('[data-google-map=map]'),
        _googleMap = new ConstructionsDerMap(_domGoogleMapContainer);
  });

});
