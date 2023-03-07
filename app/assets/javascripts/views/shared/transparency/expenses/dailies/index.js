/**
 * JavaScript de shared/transparency/expenses/dailies#index
 */

$(function(){
  hideExercicio();
  issueChange();
  $('#date_of_issue').on("change", function(){
    issueChange();
  })
});

function hideExercicio() {
  $('#exercicio').parent().hide();
  $('#exercicio').val('');
}

function issueChange() {
  var defaultInitialDate = "01/01/2019"
  var defaultFinalDate = "31/12/2019"
  if ($('#date_of_issue').val() == '') {
    $('#date_of_issue').val(initialDate + ' - ' + finalDate);
  }
}
