

/**
 * Componente responsável por controlar o embutido do GoogleMap
 *
 */

function ConstructionsDaeMap(aGoogleMapContainer) {
'use strict';

  var self = this,
      _domGoogleMapContainer = $(aGoogleMapContainer),
      _dataPlaces = _domGoogleMapContainer.data('places'),
      _dataIndexPath = _domGoogleMapContainer.data('index-path'),
      _domHelper = new DomHelper(_domGoogleMapContainer),
      _googleMap = null,
      _lastWindow = null;


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
        content: _contentString(dataPlace),
        maxWidth: 320,
        maxHeight: 320
      });

      marker.addListener('click', function() {
        if (_lastWindow) {
          _lastWindow.close();
        }

        infowindow.open(map, marker);

        _lastWindow = infowindow;
      });

    });

    //now fit the map to the newly inclusive bounds
    map.fitBounds(bounds);

    _domHelper.fireEvent('google-map:ready');

  }

  function _contentString(aDataPlace) {
    var dataPlace = aDataPlace,
        id = dataPlace.id,
        secretaria = dataPlace.secretaria,
        contratada = dataPlace.contratada,
        descricao = dataPlace.descricao,
        municipio = dataPlace.municipio,
        status = dataPlace.status,
        valor = 'R$ ' + dataPlace.valor.toString().replace('.', ','),

        // XXX: isso não deveria ser feito dessa forma. Temos que passar a
        // url pronta para o javascript usar (via data-attribute de algum
        // element envolvido) ou passar pelo json (dataPlace.show_path)
        showPath = _dataIndexPath.replace('?', '/' + id + '?')

    var contentString =
        '<div style="padding-top: 10px;">'+
          '<p><b>' + descricao + '</b></p>' +
          '<p><b>Situação: </b>' + status + '</p>' +
          '<p><b>Secretaria: </b>' + secretaria + '</p>' +
          '<p><b>Município: </b>' + municipio + '</p>' +
          '<p><b>Contratada: </b>' + contratada + '</p>' +
          '<p><b>Valor: </b>' + valor + '</p>' +
          '<p><a href="' + showPath + '" target="_blank">Ver mais detalhes</a></p>' +
        '</div>';
    return contentString;
  }

  function _icons() {
    var iconBase = 'https://maps.google.com/mapfiles/ms/micons/',
        icons = {
          'Em Execução': {
            icon: iconBase + 'green-dot.png'
          },

          'Concluída': {
            icon: iconBase + 'blue-dot.png'
          },

          'Concluida': {
            icon: iconBase + 'blue-dot.png'
          },

          'Finalizada': {
            icon: iconBase + 'blue-dot.png'
          },

          'Aguardando OS': {
            icon: iconBase + 'ltblue-dot.png'
          },

          'Paralisada': {
            icon: iconBase + 'yellow-dot.png'
          },

          'Cancelada': {
            icon: iconBase + 'red-dot.png'
          },

          'Execução Fisíca Concluída': {
            icon: iconBase + 'orange-dot.png'
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
