// Módulo usado para inclusão e inicialização do componente search-box

//= require components/search-box

$(function() {
'use strict';

  var _domSearchBoxes = $('[data-search-box]');

  _domSearchBoxes.each(function() {
      var searchBox = new SearchBox($(this));
  });
});
