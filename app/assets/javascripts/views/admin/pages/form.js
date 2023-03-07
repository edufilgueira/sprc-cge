$(function() {
  var _container = $('[data-chart-container');

  _container.on('cocoon:after-insert', function(e, insertedItem) {
      var item = $(insertedItem),
          firstInput = item.find('input[type=text]').first();

      firstInput.focus();
  });
});
