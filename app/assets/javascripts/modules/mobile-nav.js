$(function () {
  'use strict';

  $('[data-menu], [data-close-mobile-menu]').on('click', function(){
    $('[data-mobile-menu]').toggleClass('show');
    $('body').toggleClass('navbar-mobile-active');
  });

});
