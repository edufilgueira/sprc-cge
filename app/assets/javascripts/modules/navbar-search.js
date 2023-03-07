$(function(){
  'use strict';

  var gSearchContainer  = $('#searchContainer'),
      gNavbar           = $('#mainNavbar');

  gNavbar.on('click', '[data-toggle="dropdown"]', function(e){
    gSearchContainer.removeClass('show'); // force close without effect
  });

  // auto focus search input after shown searchbar
  gSearchContainer.on('shown.bs.collapse ', function () {
    $(this).find('input').focus();
  })
});
