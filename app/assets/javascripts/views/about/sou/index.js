$(function(){
'use strict';

  var _domMenu = $("[data-content=about-menu]"),
    _domItemMenu = _domMenu.find(".nav-link");

  _domItemMenu.on('click', _activeItemMenu);


  // private

  function _activeItemMenu() {
    var defaultItemMenu = _getDefaultItemMenu(),
      selectedMenu = this === undefined ? defaultItemMenu : $(this);

    _domItemMenu.removeClass('active');
    selectedMenu.addClass('active');
  }

  function _getAnchorId() {
    return window.location.hash.substr(1);
  }

  function _getDefaultItemMenu() {
    var anchorId = _getAnchorId(),
      defaultItemMenu = null;

    if (anchorId.length === 0) {
      defaultItemMenu = $(_domItemMenu.first());
    } else {
      defaultItemMenu = _domMenu.find(".nav-link[href$=" + anchorId + "]");
    }

    return defaultItemMenu;
  }

  function init() {
    _activeItemMenu();
  }

  init();

});
