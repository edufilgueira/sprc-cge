//= require modules/remote-content-show

$(function() {

  $('[data-remote-content]').each(function() {
    var container = $(this);

    new RemoteContentShow(container);
  });
});
