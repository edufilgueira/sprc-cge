/*
 * Módulo para carregamento automatico de Treevore
 *
 * Utiliza os seguintes parâmetros:
 *
 *   <... data-toggle='treeview'>
 *
 */

//= require components/treeview

$(function() {
'use strict';

  $('[data-toggle=treeview]').each(function() {

    var container = $(this),
        treeview = new Treeview(container);
  });

});
