/**
 * JavaScript de shared/transparency/expenses/
 */

$(function(){
  issueChange();
  $('#date_of_issue').on("change", function(){
    issueChange();
  })
})

function issueChange() {
  year = $('#year').parent()
  if ($('#date_of_issue').val() == '') {
    year.show();
  }else {
    year.hide();
  }
}
