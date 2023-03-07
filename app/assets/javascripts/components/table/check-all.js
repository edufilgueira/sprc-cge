function CheckAll(aContainer) {
'use strict';

  var _domContainer = aContainer,
    _domCheckAll = _domContainer.find('[data-input=check-all]'),
    _domCheckboxes = _domContainer.find('input[type=checkbox]');


  // event handlers

  _domCheckAll.on('click', function () {
    var checked = $(this).prop('checked');

    _domCheckboxes.prop('checked', checked);
  });
}
