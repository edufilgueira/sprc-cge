$(function () {
  var chartContainer = $('#ppa_budget_chart_container');

  // checking if chart (and data) is available to be plotted
  if (!chartContainer.length) return;

  var title      = chartContainer.data('title');
  var categories = chartContainer.data('categories');
  var yTitle     = chartContainer.data('label');
  var series     = chartContainer.data('series');

  var myChart = Highcharts.chart('ppa_budget_chart_container', {
    chart: {
      type: 'bar'
    },
    title: {
      text: title
    },
    xAxis: {
      categories: categories
    },
    yAxis: {
      title: {
        text: yTitle
      }
    },
    series: series,
    tooltip: {
      // @see http://jsfiddle.net/gh/get/library/pure/highcharts/highcharts/tree/master/samples/highcharts/tooltip/valuedecimals/
      // pointFormat: '{series.name}: <b>{point.y}</b><br/>',
      // valueDecimals: 2,
      valuePrefix: 'R$ ',
      // valueSuffix: ' mil'
    },
  });
});
