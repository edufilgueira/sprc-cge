$('#ppa_revision_participant_profile_genre').change(function(){
  var disabled = true;

  if ($(this).val() == 'other_genre'){
    disabled = false;
  } else {
    $('#ppa_revision_participant_profile_other_genre').val('');
  }

  $('#ppa_revision_participant_profile_other_genre').attr('disabled', disabled);
});

$('#ppa_revision_participant_profile_sexual_orientation').change(function(){
  var disabled = true;

  if ($(this).val() == 'other_sexual_orientation'){
    disabled = false;
  } else {
    $('#ppa_revision_participant_profile_other_sexual_orientation').val('');
  }

  $('#ppa_revision_participant_profile_other_sexual_orientation').attr('disabled', disabled);
});

$('#ppa_revision_participant_profile_deficiency').change(function(){
  var disabled = true;

  if ($(this).val() == 'other_deficiency'){
    disabled = false;
  } else {
    $('#ppa_revision_participant_profile_other_deficiency').val('');
  }

  $('#ppa_revision_participant_profile_other_deficiency').attr('disabled', disabled);
});

$("input[type='radio'][name='check_collegiate']").change(function(){
  var disabled = true;

  if ($(this).val() == 'true') {
    disabled = false
  } else {
    $('#ppa_revision_participant_profile_collegiate').val('');
  }

  $('#ppa_revision_participant_profile_collegiate').attr('disabled', disabled);
});