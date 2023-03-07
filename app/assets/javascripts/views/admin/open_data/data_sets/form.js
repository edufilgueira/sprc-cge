$(function() {
'use strict';

  // globals

  var _container = $('[data-content=data-set-form]');

  // events

  _container.on('cocoon:after-insert', function(e, insertedItem) {
    _updateDataItemTypeContent(insertedItem);
  });

  _container.on('change', '[data-input=data-item-type]', function(e) {
    var dataItem = $(this).closest('[data-content=data-item]');

    _updateDataItemTypeContent(dataItem);
  });

  // privates

  function _updateDataItemTypeContent(aItem) {
    var item = $(aItem),
        dataItemSelect = item.find('[data-input=data-item-type]'),
        selected = dataItemSelect.val(),
        containers = item.find('[data-item-type]');

    containers.hide();

    if (selected !== '') {
      var selectedContainer = item.find('[data-item-type=' + selected + ']');
      selectedContainer.show();
    }
  }

  function _init() {
    _container.find('[data-content=data-item]').each(function() {
      _updateDataItemTypeContent(this);
    });
  }

  _init();
});
