$('#list-theme a').on('click', function (e) {
  e.preventDefault()

  $(this).parent().find('.active').removeClass('active')
  $(this).tab('show')
});

$('.card-steps-list input').on('click', function (e) {
  if ($('#list-theme a.active i').length == 0) {
    $('#list-theme a.active').append('<i class="fa fa-check text-green ml-2"></i>');
  }
});

$(document).ready(function(){
  $('input[type=radio]:checked').each(function(){
    // Add $(this).val() to your list
    var numberPattern = /\d+/g;
    var theme_id = $(this).attr('name').match( numberPattern );
    $('#list-theme a[href="#list-' + theme_id + '"]').append('<i class="fa fa-check text-green ml-2"></i>');
  });
});
