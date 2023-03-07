// @see https://stackoverflow.com/a/34656625
$(function(){
'use strict';

  var $affectedElements = $("a, label, p, span, h1, h2, h3, h4, h5, h6"); // Can be extended, ex. $("div, p, span.someClass")

  // Storing the original size in a data attribute so size can be reset
  $affectedElements.each(function () {
    var $this = $(this);
    $this.data("orig-font-size", $this.css("font-size") );
  });

  $(".btn-a11y-increase-font-size").click(function () {
    changeFontSize(1);
  });

  $(".btn-a11y-decrease-font-size").click(function () {
    changeFontSize(-1);
  });

  $(".btn-a11y-reset-font-size").click(function () {
    $affectedElements.each(function () {
      var $this = $(this);
      $this.css("font-size", $this.data("orig-font-size"));
    });
  });


  function changeFontSize(amount) {
    $affectedElements.each(function () {
      var $this = $(this);
      $this.css("font-size", parseInt($this.css("font-size")) + amount);
    });
  }

});
