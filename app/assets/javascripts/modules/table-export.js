/**
 *
 * Módulo responsável por inicializar os table-export com 'data-toggle'
 */
$(function() {
  'use strict';

  /* default charset encoding (UTF-8) */
  TableExport.prototype.charset = "charset=utf-8";

  /* default `filename` property if "id" attribute is unset */
  TableExport.prototype.defaultFilename = "dados";

  /* default class to style buttons when not using Bootstrap or the built-in export buttons, i.e. when (`bootstrap: false` & `exportButtons: true`)  */
  TableExport.prototype.defaultButton = "btn btn-small c-pointer ml-2 btn-link";

  /* row delimeter used in all filetypes */
  TableExport.prototype.rowDel = "\r\n";

  // Remove conversão de data forçada para o padrão americano no xlsx (mes/dia/ano)
  TableExport.prototype.typeConfig.date.assert = function(value){ return false; };

  TableExport.prototype.formatConfig = {
    'xlsx': {
      defaultClass: 'xlsx',
      buttonContent: 'Baixar XLSX',
      mimeType: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
      fileExtension: '.xlsx'
    },

    'csv': {
      defaultClass: 'csv',
      buttonContent: 'Baixar CSV',
      separator: ',',
      mimeType: 'text/csv',
      fileExtension: '.csv',
      enforceStrictRFC4180: true
    }
  };

  $(document).on('remote-content:after', '[data-remote-content]', function() {
    $(this).each(function() {
      var table = $(this).find('[data-toggle="table-export"]');

      if (table.length > 0) {
        _createLinks(table);
      }
    });
  });

  $('[data-toggle="table-export"]').each(function() {
    var table = $(this);

    _createLinks(table);
  });


  function _createLinks(aTable) {
    var table = aTable,
        filename = table.attr('data-filename'),
        // excel não aceita shhets com nome > 31 e o tableexport usa o filename
        sanitizedName = (filename.length > 31 ? filename.substr(filename.length - 31) : filename),
        tableParent = table.parent(),
        wrapper = $("<div class='table-export-comands' />");

    table.tableExport({
      filename: sanitizedName,
      formats: ['xlsx', 'csv']
    });

    wrapper.append(table.find('caption').children());


    if (tableParent.hasClass('table-responsive')) {
      wrapper.insertAfter(tableParent);
    } else {
      wrapper.insertAfter(table);
    }

    table.find('caption').remove();
  }
});
