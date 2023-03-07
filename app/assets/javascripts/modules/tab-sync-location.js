/**
 *
 * Módulo responsável por controlar e permitir o comportamento de âncora
 * nas abas de navegações
 *
 */
$(function() {
  'use strict';

  // implementado este comportamento pois por padrão o bootstrap previne a atribuição do hash
  $('#tabs a').click(function (e) {
    window.location.hash = this.hash;
  });


  function _setWindowLocation() {
    var hash = window.location.hash;

    if (hash === '') {
      var firstTabLink = $('nav#tabs').find('a:first');
      hash = firstTabLink.prop('hash');
    }

    $('nav a[href="' + hash + '"]').tab('show');
    $('#tabs-content').removeClass('d-none');
  }

  function _init() {
    _setWindowLocation();
  }

  _init();

});

