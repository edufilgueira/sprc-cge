$(function() {
'use strict';

  if (Highcharts !== undefined) {
    Highcharts.setOptions({
      credits: {
        enabled: false,
      },

      accessibility: {
        keyboardNavigation: {
          enabled: false
        }
      },

      legend: {
        enabled: false
      },

      colors: ['#7cb5ec', '#008640', '#f7a35c', '#90ed7d', '#8085e9', '#f15c80', '#e4d354', '#2b908f', '#f45b5b', '#91e8e1'],

      lang: {
        months: ['Janeiro', 'Fevereiro', 'Março', 'Abril', 'Maio', 'Junho', 'Julho', 'Agosto', 'Setembro', 'Outubro', 'Novembro', 'Dezembro'],
        shortMonths: ['Jan', 'Fev', 'Mar', 'Abr', 'Mai', 'Jun', 'Jul', 'Ago', 'Set', 'Out', 'Nov', 'Dez'],
        weekdays: ['Domingo', 'Segunda', 'Terça', 'Quarta', 'Quinta', 'Sexta', 'Sábado'],
        loading: ['Atualizando o gráfico...aguarde'],
        contextButtonTitle: 'Exportar gráfico',
        decimalPoint: ',',
        thousandsSep: '.',
        downloadJPEG: 'Baixar imagem JPEG',
        downloadPDF: 'Baixar arquivo PDF',
        downloadPNG: 'Baixar imagem PNG',
        downloadSVG: 'Baixar vetor SVG',
        downloadCSV: 'Baixar arquivo CSV',
        downloadXLS: 'Baixar arquivo XLS',
        viewData: 'Visualizar tabela de dados',
        printChart: 'Imprimir gráfico',
        rangeSelectorFrom: 'De',
        rangeSelectorTo: 'Para',
        rangeSelectorZoom: 'Zoom',
        resetZoom: 'Limpar Zoom',
        resetZoomTitle: 'Voltar Zoom para nível 1:1',
        numericSymbols: [ " mil", " milhões", " bilhões", " trilhões", " quatrilhões", " quintilhões"]
      }
    });
  }

  /*
   * Precisamos dar reflow no highchart pois os gráficos escondidos
   * não são atualizados no resize da janela e quando uma aba é selecionada,
   * depois de um resize, o gráfico está do tamanho errado.
   */

  $(document).on('shown.bs.tab', 'a[data-toggle="tab"], a[data-toggle="pill"]', function() {
    $('.chart').each(function() {
        $(this).highcharts().reflow();
    });
  });
});
