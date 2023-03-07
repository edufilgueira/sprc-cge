$(document).ready(function(){
  //Lista de temas
  $('#list-theme a').on('click', function (e) {
    $('#list-theme a').removeClass('active');
    e.preventDefault();
    $(this).tab('show');
    $(".next-step2").show();

    //Setando descrição do tema na tela de revisão
    $("#revision_theme").html($(this).text());
    $('.hidden_theme_id').val(_getThemeId());//Seta o id do theme no form Region Theme
  });

  // Entrando na terceira fase
  $('#list-theme a').on('click', function (e) {
    //_getStrategicResult();
    //_getThemeDescription();
    //_getProblemSituations();
    //_getRegionalStrategic();
    //_theme_has_report();

    _loadPriorizationOperationalStep();       
  });

  function _loadPriorizationOperationalStep(){
    var region_id = _getSelectedRegion();
    var theme_id = _getThemeId();
    var axis_id = _getAxisId();

    var data = {};
    data['theme_id'] = theme_id;
    data['region_id'] = region_id;
    data['axis_id'] = axis_id;


    // Ajax busca resultado estratégico.

    $.ajax({
      url: $('#url_for_prioritization_step').val(),
      data: data,
      success: function(aData) {
        $('#fieldset_revision').empty().html(aData);
      }
    });
  }  


  function _theme_has_report(){
    var theme_id = _getThemeId();
    var data = {};
    data['theme_id'] = theme_id;

    // Ajax busca se o tema tem report

    $.ajax({
      url: $('#url_api_has_theme_report').val(),
      data: data,
      success: function(aData) {
        if(aData == "true"){
          $('#report_link_id').show();
          _setReportLink();
        }
        else{
          $('#report_link_id').hide();
        }
      }
    });
  }

  // Ajax para buscar Resultado Estratégico
  function _getStrategicResult() {
    var region_id = _getSelectedRegion();
    var theme_id = _getThemeId();

    var data = {};
    data['theme_id'] = theme_id;
    data['region_id'] = region_id;

    // Ajax busca resultado estratégico.

    $.ajax({
      url: $('#url_api_strategic_result').val(),
      data: data,
      success: function(aData) {
        $("#revision_strategic_result").html(aData[0][1]);
      }
    });
  }


  // Ajax busca descrição do tema.
  function _getThemeDescription() {
    var theme_id = _getThemeId();

    var data = {};
    data['theme_id'] = theme_id;

    $.ajax({
      url: $('#url_api_theme_description').val(),
      data: data,
      success: function(aData) {
        $("#revision_theme_description").html(aData);
      }
    });
  }

  // Ajax para buscar Situtação Problema
  function _getProblemSituations() {
    var region_id = _getSelectedRegion();
    var theme_id = _getThemeId();
    var axis_id = _getAxisId();

    var data = {};
    data['theme_id'] = theme_id;
    data['region_id'] = region_id;
    data['axis_id'] = axis_id;


    // Ajax busca resultado estratégico.

    $.ajax({
      url: $('#url_api_problem_situations').val(),
      data: data,
      success: function(aData) {
        $("#problem_situation_tbody").empty();

        $.each(aData, function( index, value ) {
          var name = value[0];
          var id = value[1];

          var radio_name = 'ppa_revision_review_problem_situation_strategy[region_themes_attributes][0][problem_situations_attributes][' + index + '][persist]';

          var radio_markup_yes = '<input type="radio" value="true" name="' + radio_name + '" class="radio_buttons optional"/>';
          var radio_markup_no = '<input type="radio" value="false" name="' + radio_name + '" class="radio_buttons optional"/>';

          var span_markup_yes = '<span class="radio">' + radio_markup_yes + ' Sim</span>';
          var span_markup_no = '<span class="radio">' + radio_markup_no + ' Não</span>';

          var input_id = 'ppa_revision_review_problem_situation_strategy[region_themes_attributes][0][problem_situations_attributes][' + index + '][problem_situation_id]';
          var input_hidden = '<input type="hidden" name="' + input_id + '" value="' + id + '">';

          var markup_radio = '<div class="form-group radio_buttons optional">' + span_markup_yes + span_markup_no + input_hidden + '</div>';
          var markup = "<tr><td>" + name + "</td><td>" + markup_radio +"</td></tr>";
          $("#problem_situation_tbody").append(markup);
        });
      }
    });
  }

    // Ajax para buscar Estratégia Regional
    function _getRegionalStrategic(){
      var region_id = _getSelectedRegion();
      var theme_id = _getThemeId();

      var data = {};
      data['theme_id'] = theme_id;
      data['region_id'] = region_id;

      $.ajax({
        url: $('#url_api_regional_strategy').val(),
        data: data,
        success: function(regional_strategies) {
          $("#tbody_regional_strategy").empty();

          $.each(regional_strategies, function(index, regional_strategy) {
            var name = regional_strategy.name;
            var id = regional_strategy.id;

            var radio_name = 'ppa_revision_review_problem_situation_strategy[region_themes_attributes][0][regional_strategies_attributes][' + index + '][persist]';

            var radio_markup_yes = '<input type="radio" value="true" name="' + radio_name + '" class="radio_buttons optional"/>';
            var radio_markup_no = '<input type="radio" value="false" name="' + radio_name + '" class="radio_buttons optional"/>';

            var span_markup_yes = '<span class="radio">' + radio_markup_yes + ' Sim</span>';
            var span_markup_no = '<span class="radio">' + radio_markup_no + ' Não</span>';

            var input_id = 'ppa_revision_review_problem_situation_strategy[region_themes_attributes][0][regional_strategies_attributes][' + index + '][strategy_id]';
            var input_hidden = '<input type="hidden" name="' + input_id + '" value="' + id + '">';
            var markup_radio = '<div class="form-group radio_buttons optional">' + span_markup_yes + span_markup_no + input_hidden + '</div>';
            var markup = "<tr><td>" + name + "</td><td>" + markup_radio +"</td></tr>";

            $("#tbody_regional_strategy").append(markup);
          });
        }
      });
    }

    function _setReportLink(){
      var data = {};
      data['region_id'] = _getSelectedRegion();
      data['theme_id'] = _getThemeId();
      data['axis_id'] = _getAxisId();

      $.ajax({
        url: $('#url_api_link_report').val(),
        data: data,
        success: function(link) {
          $('#report_link_id').attr('href', link);
        }
      });
    }
});