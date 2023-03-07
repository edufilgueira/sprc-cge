$(function(){
'use strict';

  var domForm = $('[data-filter-bar=comment] form'),
    loader = domForm.find('[data-content=loader]');

  domForm.on('ajax:success', function() {
    this.reset();
  });

  domForm.on('ajax:beforeSend', function() {
    loader.addClass('fa-spinner');
  });

  domForm.on('ajax:complete', function() {
    loader.removeClass('fa-spinner');
  });

});
