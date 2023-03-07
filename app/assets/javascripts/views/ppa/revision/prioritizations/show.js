//= require modules/remote-content-show

$(document).ready(function(){
  // Adicionando azul nos menus anteriores
  $("#progressbar li:not(:first, :last)").addClass('active');

  // $('.problem_situation_strategy_theme').on('ajax:success', function(evt, html) {
  //   $('#div-region-theme-result').html(html);
  // });

  $(".show_resume").removeClass('d-none');


});


$(function() {

  $('[data-remote-content]').each(function() {
    var container = $(this);

    new RemoteContentShow(container);
  });
});
