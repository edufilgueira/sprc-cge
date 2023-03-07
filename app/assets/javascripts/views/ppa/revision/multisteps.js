// INICIO -- MULTISPTEPS
//Codigo referente ao form por steps
//Controle do mecanismo dos steps
$(document).ready(function(){
  $('#card-multisteps-flow').show(); //torna visivel depois de carregar tudo

  var current_fs, next_fs, previous_fs; //fieldsets
  var opacity;

  $(".next").click(function(){

    current_fs = $(this).parent();
    next_fs = $(this).parent().next();

    //Add Class Active
    $("#progressbar li").eq($("fieldset").index(next_fs)).addClass("active");

    //show the next fieldset
    next_fs.show();
    //hide the current fieldset with style
    current_fs.animate({opacity: 0}, {
      step: function(now) {
        // for making fielset appear animation
        opacity = 1 - now;

        current_fs.css({
          'display': 'none',
          'position': 'relative'
        });

        next_fs.css({'opacity': opacity});
      },
      duration: 600
    });

  });

  $(".previous").click(function(){

    current_fs = $(this).parent();
    previous_fs = $(this).parent().prev();

    //Remove class active
    $("#progressbar li").eq($("fieldset").index(current_fs)).removeClass("active");

    //show the previous fieldset
    previous_fs.show();

    //hide the current fieldset with style
    current_fs.animate({opacity: 0}, {
      step: function(now) {
        // for making fielset appear animation
        opacity = 1 - now;

        current_fs.css({
          'display': 'none',
          'position': 'relative'
        });
        previous_fs.css({'opacity': opacity});
      },
      duration: 600
    });
  });

  $('.radio-group .radio').click(function(){
    $(this).parent().find('.radio').removeClass('selected');
    $(this).addClass('selected');
  });

  $(".submit").click(function(){
    return false;
  })

  // FIM -- MULTISPTEPS

});


function _getInputRegion(){
  return $('.input_region :selected');
}

function _getSelectedRegion(){
  return _getInputRegion().val();
}

function _getThemeId(){
  return $(".item-theme.active").attr('theme_id');
}

function _getAxisId(){
  return $("#list-tab").children('.active').attr('axis_id');
}

// INICIO --Step de Região

// Pegando região e atualizando na tela do tema
// Só exibir botão Próximo ao selecionar uma região

//O correto seria implementar onchange usando _getInputRegion()
$('#ppa_revision_prioritization_region_code').change(function(){
  _eventsOnChangeRegion();
  $('.list-axis').html('');
  $('.list-axes').removeClass('active');
  $('.next-step2').hide();
});

function _eventsOnChangeRegion(){
  updateAxisAndThemeLabel();
  hideOrShowStepButton();
  loadCitiesOnReviewProblemSituation();
  $('.hidden_region_id').val(_getSelectedRegion());//Seta o id da reginal no form Region Theme
}


// Tratando do caso de edição - Regiao
$("#ppa_revision_review_problem_situation_strategy_region_code").ready(function(){
  if (_getSelectedRegion() != ''){
    _eventsOnChangeRegion();
    $('.next-step1').click(); //Avançando o step 1
  }
});

// // Tratando do caso de edição de eixo/tema
// $("list-tab").ready(function(){
//   // if (_getAxisUrlParam() != ''){
//   //   $("[axis_id="+ _getAxisUrlParam() +"]").click(); //Clicando no eixo
//   // }
// });

// function _getAxisUrlParam(){
//   $('#axis_id_url').val();
// }

function updateAxisAndThemeLabel() {
  var label=_getInputRegion().parent().attr('label');
  var label_prefix = $("#theme_title").text().split(":")[0];

  $("#theme_title").html(label_prefix + ": " + label);
  $("#revision_region").html(label);
}

function hideOrShowStepButton(){
  if ($("#ppa_revision_review_problem_situation_strategy_region_code").val() == ""){
    $(".next-step1").hide();
  }
  else{
    $(".next-step1").show();
  }
}

function loadCitiesOnReviewProblemSituation() {

  var data = {};

  data['region_id'] = _getSelectedRegion();

  $.ajax({
    url: $('#api_ppa_cities_for_region_url').val(),
    data: data,
    success: function(aData) {
     _showResults(aData);
    }
  });
}

function _showResults(aData) {
  var citiesContainer = $('.city_for_new_problem_situation'),
    data = aData,
    options = '<option value="">Todos</option>';

  $.each(data, function(index, city){
    options += '<option value="' + city.id + '">' + city.name + '</option>';
  });

  citiesContainer.html(options);

  // Para exibir a opção todos precisa desse refresh
  citiesContainer.trigger('change');
}

//  FIM --Step de Região



//-- eixos e temas 


$(function() {

'use strict';
  // INICIO -- Pagina de configuração de eixos e temas

  //Lista de eixos
  $('#list-tab a').on('click', function (e) {
    $('#list-tab a').removeClass('active');
    e.preventDefault();
    $(this).tab('show');
    $(".next-step2").hide();
    $('#list-theme a').removeClass('active');

    //Setando descrição do eixo na tela de revisão
    $("#revision_axis").html($(this).text());

  });

  // Lista de eixos
  $('a.list-axes').on('click', function (e) {
    var data = {};
    data['axis_id'] = $(this).attr('axis_id');
    data['region_id'] = _getSelectedRegion();

    // Ajax lista de temas por eixo.
    $.ajax({
      url: $('#url_themes_list').val(),
      data: data,
      success: function(html) {
        $('#list-axis_' + data['axis_id']).html(html);
      }
    });
  });

  $('input[name="check_new_regional_strategy"]').change(function(){
    if ($(this).val() == 'true'){
      $('.new_regional_strategies').show();
      $('.new_regional_strategies').find(':input:first').focus();
      $('.hidden_theme_id').val(_getThemeId);
      $('.hidden_region_id').val(_getSelectedRegion());
    } else {
      $('.new_regional_strategies :input').val('');
      $('.new_regional_strategies').hide();
    }
  });


  $('input[name="check_new_problem_situation"]').change(function(){
    if ($(this).val() == 'true'){
      $('.new_problem_situations').show();
      $('.new_problem_situations').find(':input:first').focus();
      $('.hidden_theme_id').val(_getThemeId);
      $('.hidden_region_id').val(_getSelectedRegion());
    } else {
      $('.new_problem_situations :input').val('');
      $('.new_problem_situations').hide();
    }
  });

  // FIM - Pagina de configuração de eixos e temas
});