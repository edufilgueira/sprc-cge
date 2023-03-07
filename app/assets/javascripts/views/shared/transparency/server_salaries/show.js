//= require components/utils/url-helper

/**
 * JavaScript de shared/transparency/server_salaries#show
 */

$(function() {
'use strict';

  var _domServerSalarySelect = $('[data-input=server_salary_select]'),
      _domServerSalaryContent = $('[data-input=server_salary_content]'),
      _domBtnPrint = $('[data-input=btn-print]'),
      _urlHelper = new UrlHelper();

  // usuário selecionou outro mês para exibição dos proventos...

  _domServerSalarySelect.on('change', function() {
    var serverSalaryUrl = _domServerSalarySelect.val();

    $.get(serverSalaryUrl, function(aResult) {

      _urlHelper.updateUrl(serverSalaryUrl);
      _domServerSalaryContent.html(aResult);
      _domBtnPrint.attr("href", serverSalaryUrl + '&print=true')

    });
  });
});
