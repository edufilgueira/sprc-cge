//= require modules/remote-content-with-filter-bar

$('form :input').blur(function() {
  $(this).closest('form').submit();
});
