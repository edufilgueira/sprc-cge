/*
 * JavaScript de shared/mobile_apps/filters
 */
$(function(){
'use strict';

  var _domMobileTagFilters = $("[data-content='mobile_tags_filter']"),
    _domMobileTagFiltersInput = _domMobileTagFilters.find("input[type=checkbox]"),
    _domMobileApp = $("[data-content='mobile_app']");


  _domMobileTagFiltersInput.on('change', _filterApps);


  // private


  function _filterApps() {
    var selectedTags = _getSelectedTags();

    if (selectedTags.length === 0) {
      _domMobileApp.show();
      return;
    }

    _domMobileApp.hide();

    _domMobileApp.each(function() {
      var mobileApp = $(this),
        mobileTags = mobileApp.data('tags');

      $.each(mobileTags, function() {
        var mobileTag = this;

        if (selectedTags.indexOf(mobileTag) !== -1) {
          mobileApp.show();
        }
      });
    });
  }

  function _getSelectedTags() {
    var tagInput = _domMobileTagFilters.find(':checked');

    return tagInput.map(function (_, el) { return $(el).data('filter'); }).get();
  }


  function init() {
    _filterApps();
  }

  init();

});
