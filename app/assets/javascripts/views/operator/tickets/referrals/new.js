$(function() {
'use strict';

  var maskManager = new MaskManager();

  $('form').on('cocoon:after-insert', function(e, insertedItem) {
    maskManager.initMasks($(insertedItem));
  });

  $('form').on('cocoon:after-insert', '[data-container="sub-departments"]', function(e, insertedItem) {
    _initializeSelect2($(insertedItem).find('select'));
  });

  function _initializeSelect2(aElement) {
    var subDepartmentSelect = $(aElement),
      emptyOption = subDepartmentSelect.find('option[value=""]').text(),
      subDepartmentUrl = subDepartmentSelect.data('url');

    subDepartmentSelect.select2({
      initSelection: _select2InitSelection,
      placeholder: emptyOption,
      ajax: {
        delay: 250,
        url: subDepartmentUrl,
        data: function (params) {
          var query = {
            search: params.term,
            department_id: $(this).closest('[data-content=department]').find('[data-input="department"]').val() || '0'
          }
          return query;
        },

        processResults: function (data) {
          return {
            results: $(data).map(function(i, el) {el.text = el.name; return el;})
          };
        }
      }
    });
  }

  function _select2InitSelection(aElement, aCallback) {
    var selectedId = aElement.data('selected-id'),
        selectedText = aElement.data('selected-text'),
        emptyOption = aElement.find('option[value=""]').text();

    if (selectedId && selectedText) {
      aCallback({ id: selectedId, text: selectedText });
    } else {
      aCallback({ id: '', text: emptyOption });
    }
  }

  function _init() {
    $("[data-input='sub_department']").each(function(i, el){
      _initializeSelect2(el);
    });
  }

  _init();

});
