//= require ./chart/highcharts
//= require ./chart/chart

$(function(){
'use strict';

  // precisamos carregar gráficos que podem ter vindo de remote-content

  $(document).on('remote-content:after', '[data-remote-content]', function() {
    var remoteContent = $(this),
        selector = remoteContent.find('.chart');

    // só podemos iniciar os charts filhos do próprio remote-content que
    // disparou o evento para que possa haver 2 remote-content na mesma view.

    _initCharts(selector);
  });

  function _initCharts(aSelector) {
    var selector = (aSelector === undefined ? '.chart' : aSelector),
        charts = $(selector);

    charts.each(function() {
      var chart = $(this);

      Chart(chart);
    });
  }

  _initCharts();
});
