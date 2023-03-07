

/**
 * Componente responsável por controlar o embutido do GoogleMap
 *
 */

function ConstructionsDerMap(aGoogleMapContainer) {
'use strict';

  var self = this,
      _domGoogleMapContainer = $(aGoogleMapContainer),
      _dataPlaces = _domGoogleMapContainer.data('places'),
      _domHelper = new DomHelper(_domGoogleMapContainer),
      _googleMap = null;


  function _initMap() {

    var map = new google.maps.Map(_domGoogleMapContainer[0]),
        bounds = new google.maps.LatLngBounds(),
        icons = _icons();

    _dataPlaces.forEach(function(aDataPlace) {

      var dataPlace = aDataPlace,
          status = dataPlace.status,
          latitude = dataPlace.latitude,
          longitude = dataPlace.longitude,
          position = new google.maps.LatLng(latitude, longitude);

      var marker_info = {
        position: position,
        type: status
      };

      // Create marker
      var marker = new google.maps.Marker({
        position: marker_info.position,
        icon: icons[marker_info.type].icon,
        map: map
      });

      //extend the bounds to include each marker's position
      bounds.extend(marker.position);

      var infowindow = new google.maps.InfoWindow({
        content: _contentString(dataPlace)
      });

      marker.addListener('click', function() {
        infowindow.open(map, marker);
      });

    });

    //now fit the map to the newly inclusive bounds
    map.fitBounds(bounds);

    _domHelper.fireEvent('google-map:ready');

  }

  function _contentString(aDataPlace) {
    var dataPlace = aDataPlace,
        id = dataPlace.id,
        construtora = dataPlace.construtora,
        distrito = dataPlace.distrito,
        programa = dataPlace.programa,
        servicos = dataPlace.servicos,
        trecho = dataPlace.trecho,
        status = dataPlace.status,
        valorAprovado = 'R$ ' + dataPlace.valor_aprovado.toString().replace('.', ','),

        // XXX: isso não deveria ser feito dessa forma. Temos que passar a
        // url pronta para o javascript usar (via data-attribute de algum
        // element envolvido) ou passar pelo json (dataPlace.show_path)
        url = new UrlHelper().getShowUrl(id);

    var contentString =
        '<div style="padding-top: 10px;">'+
          '<p><b>' + servicos + '</b></p>' +
          '<p><b>Situação: </b>' + status + '</p>' +
          '<p><b>Construtora: </b>' + construtora + '</p>' +
          '<p><b>Programa: </b>' + programa + '</p>' +
          '<p><b>Distrito: </b>' + distrito + '</p>' +
          '<p><b>Trecho: </b>' + trecho + '</p>' +
          '<p><b>Valor: </b>' + valorAprovado + '</p>' +
          '<p><a href="' + url + '" target="_blank">Ver mais detalhes</a></p>' +
        '</div>';
    return contentString;
  }

  function _icons() {
    var iconBase = 'https://maps.google.com/mapfiles/ms/micons/',
        icons = {
          'EM ANDAMENTO': {
            icon: iconBase + 'green-dot.png'
          },

          'EM PROJETO': {
            icon: iconBase + 'ltblue-dot.png'
          },

          'EM LICITAÇÃO': {
            icon: iconBase + 'ltblue-dot.png'
          },

          'CONCLUÍDO': {
            icon: iconBase + 'blue-dot.png'
          },

          'PROJETO CONCLUÍDO': {
            icon: iconBase + 'green-dot.png'
          },

          'LICITADO/ CONTRATADO': {
            icon: iconBase + 'ltblue-dot.png'
          },

          'PARALISADO': {
            icon: iconBase + 'yellow-dot.png'
          },

          'NÃO INICIADO': {
            icon: iconBase + 'yellow-dot.png'
          },

          'CANCELADO': {
            icon: iconBase + 'red-dot.png'
          }
        };

    return icons;
  }

  function _init() {
    if (window.google !== undefined) {
      _initMap();
    }
  }

  _init();
}
