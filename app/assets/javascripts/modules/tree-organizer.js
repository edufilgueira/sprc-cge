// Módulo usado para inclusão e inicialização do componente tree-organizer

//= require components/tree-organizer

$(function() {
'use strict';

  var _domTreeOrganizers = $('[data-tree-organizer]');

  _domTreeOrganizers.each(function() {
      var treeOrganizer = new TreeOrganizer($(this));
  });
});
