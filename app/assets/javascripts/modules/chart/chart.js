/* Módulo que usa o highcharts para plotar gráficos
 *
 *  [construtor]
 *
 *  - aContainer: Objeto jquery que possui atributo data-chart com JSON
 *    dos dados necessários para o gráfico.
 *
 *  Padrão de dados necessários para o gráfico
 *
 *   data-title: titulo do gráfico
 *   data-unit: unidade dos dados no eixo y
 *   - Os proximos parametros são Arrays[], para fazer a construção de várias series
 *   data-series-name[]: nome da serie do eixo x
 *   data-series-type[]: tipo do gráfico (line, column, area, pie) padrão é column
 *   data-series-data-keys[]: nomes dos valores eixo x
 *   data-series-data-values[]: valores eixo y
 *
 *   Ou
 *
 *    data-series: com o um array de objetos nesse padrão:
 *    [{
 *       name: nome do grafico,
 *       type: tipo do gráfico (line, column, area),
 *       data: [{
 *           name: nome da coluna eixo x,
 *           y: valor da coluna eixo y
 *       }]
 *    }]
 */
function Chart(aContainer, aSeries) {
'use strict';

  var self              = this,
      _container        = aContainer,
      _title            = _container.data('title') || "",
      _yAxisTitle       = _container.data('unit') || "",
      _chartType       = _container.data('type') || "column",
      MAX_LENGTH_LABEL  = 30;

  function _renderChart() {
    if (_container.length === 0) return;

    _buildChart();
    _renderTableAccesibility();
  }

  function _buildChart(){
    _container.highcharts(_chartOptions());
    // adiciona no gráfico para o leitor de tela ignorar
    _container.attr('aria-hidden', 'true');
  }

  function _renderTableAccesibility() {
    var highchart   = Highcharts.charts[_container.data('highchartsChart')],
        div         = $("<div class='sr-only'></div>"),
        table       = _buildTable(highchart);

    _container.parent().append(table);
  }

  function _buildTable(highchart){
    var div = $("<div class='sr-only'></div>"),
        table = $(highchart.getTable());

    // remove os atributos que não são necessários
    table.removeAttr('summary');
    table.removeAttr('tabindex');
    table.find('thead tr th:first').text("");

    div.append(table);

    return div;
  }

  function _chartOptions() {

    return {
      chart: {
        plotBackgroundColor: null,
        plotBorderWidth: null,
        plotShadow: false,
        type: _chartType
      },

      title: {
        text: _title
      },

      yAxis: {
        title: {
          text: _yAxisTitle
        }
      },

      xAxis: {
        uniqueNames: false, // não agrupar colunas por nome
        type: 'category',
        labels: {
          formatter: function(){
            return _truncate(MAX_LENGTH_LABEL, this.value);
          }
        }
      },

      series: _getSeries(_container),


      plotOptions: {
        series: {
          colorByPoint: _colorfulColumn(_container)
        },
        pie: {
          allowPointSelect: true,
          cursor: 'pointer',
          dataLabels: {
            enabled: true,
            format: '<b>{point.name}</b>: {point.percentage:.2f}%'
          }
        }
      },

      tooltip: {
        pointFormat: _getSeriesTooltipPointFormat(),
        shared: true
      }

    };
  }

  function _getSeriesTooltipPointFormat() {
    if (_isPercentageShown()) {
      return '<span style="color:{point.color}">●</span> {series.name}: <b>{point.y} ({point.percentage:.2f}%)</b><br/>';
    }
    return '<span style="color:{point.color}">●</span> {series.name}: <b>{point.y}</b><br/>';
  }

  function _getPieTooltipPointFormat() {
    if (_isPercentageShown()) {
      return '<b>{point.name}</b>: {point.percentage:.2f}%';
    }
    return undefined; // valor padrão do highcharts
  }

  function _getSeries(aContainer) {
    var series = aContainer.data('series');

    if (series === undefined) {
      series = _buildSeries(aContainer);
    } else {
      series = _convertSeriesValuesToNumber(series);
    }

    return series;
  }

  function _buildSeries(aContainer) {
    var seriesName        = aContainer.data('series-name'),
        seriesType        = aContainer.data('series-type') || [],
        seriesDataKeys    = aContainer.data('series-data-keys'),
        seriesDataValues  = aContainer.data('series-data-values'),
        seriesDataPercentages  = aContainer.data('series-data-percentages') || [],
        series            = [];

    $.each(seriesName, function(i, name) {
      var dataKeys    = seriesDataKeys[i],
          dataValues  = seriesDataValues[i],
          dataPercentages  = seriesDataPercentages[i] || [],
          data        = [];

      $.each(dataKeys, function(k, key) {
        var value = dataValues[k],
          percentage = dataPercentages[k] || 0,
          serie = { name: key, y: value, percentage: percentage };

        data.push(serie);
      });

      series.push({ name: name, colorByPoint: !_hasMultipleSeries(), data: data });
    });

    return series;
  }

  function _convertSeriesValuesToNumber(aSeries) {
    var series = aSeries;

    for (var i = series.length - 1; i >= 0; i--) {
      var data = series[i].data;

      for (var x = data.length - 1; x >= 0; x--) {
        data[x].y = Number(data[x].y);
      }
    }

    return series;
  }

  function _colorfulColumn(aContainer) {
    var colorful        = aContainer.data('colorful');
    return colorful;
  }

  function _truncate(maxLength, label) {
    return label.length > maxLength ? label.substr(0, maxLength) + '...' : label;
  }

  function _isPercentageShown() {
    return _container.data('show-percentage') !== undefined;
  }

  function _hasMultipleSeries() {
     var series = _container.data('series-name');
     return series.length > 1;
  }

  _renderChart();
}
