$(document).ready(function(){
  $('#card-multisteps-flow').show();
  $("#fieldset_revision" ).addClass("active");
  $("#fieldset_revision" ).show();
	$("#fieldset_region").hide();
  $('#payment').addClass("active");
  $('#personal').addClass("active");

  $('input[name="check_new_regional_strategy"]').change(function(){
    if ($(this).val() == 'true'){
      $('.new_regional_strategies').show();
      $('.new_regional_strategies').find(':input:first').focus();
    } else {
      $('.new_regional_strategies :input[type="text"], select').val('');
      $('.new_regional_strategies').hide();
    }
  });

  $('input[name="check_new_problem_situation"]').change(function(){
    if ($(this).val() == 'true'){
      $('.new_problem_situations').show();
      $('.new_problem_situations').find(':input:first').focus();
    } else {
      $('.new_problem_situations :input[type="text"], select').val('');
      $('.new_problem_situations').hide();
    }
  });
});