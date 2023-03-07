//= require components/google-map/constructions-dae-map

$(function() {
  'use strict';

  waitForGoogleAsync(loadMap);

  function loadMap() {
    var _domGoogleMapContainer = $('[data-google-map=map]'),
        _googleMap = new ConstructionsDaeMap(_domGoogleMapContainer);
  }

  function waitForGoogleAsync(callback){
   if(typeof google !== 'undefined') {
      return callback();
    } else {
      setTimeout(function(){
        ((function(callback){
            waitForGoogleAsync(callback)
          }
        )(callback))
      }, 500);
      }
    }

  $('#firstTab li').click(function (e) {
    window.location.hash = $(this).attr('href');
  });

  function _setWindowLocation() {
    var hash = window.location.hash;

    if (hash === '') {
      hash = $('ul#firstTab').find('li:first').attr('href');
    }

    $('ul li[href="' + hash + '"]').tab('show');
    $('#firstTabContent').removeClass('d-none');
  }

  function _init() {
    _setWindowLocation();
  }

  _init();
});
