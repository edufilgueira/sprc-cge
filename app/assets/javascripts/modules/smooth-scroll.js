$(function () {
  'use strict';

  $('a[data-smooth-scroll="true"]').click(function(event) {
    var target = $(this).data('smooth-scroll-target');
    target = target.length ? $(target) : null;

    if (target.length) {
      event.preventDefault();
      $('html, body').animate({
        scrollTop: target.offset().top
      }, 1000, function() {
        target.focus();
        if (target.is(":focus")) {
          return false;
        } else {
          target.attr('tabindex','-1');
          target.focus();
        };
      });
    }
  });

});
