$(function(){
  // Fazendo nested switches se comportarem em forma de array
  $('.edit_ticket').submit(function(){
    $('input[name$="[protected_attachment_ids]"]', $(this)).each(function(){
      $(this).attr('name', $(this).attr('name') + '[]');
    });
  })
});