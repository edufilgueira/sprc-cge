/**
 * JavaScript com handlers para select2 com ajax
 */

$(function() {
'use strict';

  // event_handlers

  $('form').on('cocoon:after-insert', _cocoonAfterInsert);

  $(document).on('remote-form:after', _initSelectAfterEvent);
  $(document).on('remote-content:after', _initSelectAfterEvent);

  // privates

  /// cocoon handlers

  function _cocoonAfterInsert(aEvent, aElement) {
    _initAllSelect2(aElement);
  }

  // handler para eventos jQuery específicos para _reload_ de conteúdo (via XHR)
  // eg. 'remote-form:after', 'remote-content:after', ...
  function _initSelectAfterEvent(aEvent) {
    var container = $(this);

    _initAllSelect2(container);
  }

  function _getRemoteSelect2Nodes(aContainer) {
    return aContainer.find('[data-remote-select2]');
  }

  function _getSelect2Nodes(aContainer) {
    // como os select2 do tipo ajax não podem user o elemento 'select',
    // todos são selecionados para serem select2
    return aContainer.find('select');
  }

  function _initSelect2(aContainer) {
    var inputs = _getSelect2Nodes(aContainer);

    for (var i = 0; i < inputs.length; i++) {
      var input = $(inputs[i]),
          searchOptions = input.data('select2-search'),
          minimumResultsForSearch = searchOptions === 'hidden' ? Infinity : 0,
          select2Options = {
            minimumResultsForSearch: minimumResultsForSearch
          };

      // Checando se já não foi inicializado
      if (! input.hasClass("select2-hidden-accessible"))
        input.select2(select2Options);
    }
  }

  function _initRemoteSelect2(aContainer) {
    var inputs = _getRemoteSelect2Nodes(aContainer);

    for (var i = 0; i < inputs.length; i++) {
      var input = $(inputs[i]),
          multiple = input.data('multiple'),
          emptyOption = input.find('option[value=""]'),
          placeholder = input.data('placeholder') || emptyOption.text() || ' ';

      input.select2({
        ajax: _getRemoteSelect2AjaxOptions(),
        multiple: multiple,
        minimumInputLength: 1,
        placeholder: placeholder,
        formatInputTooShort: function () { return ''; },

        initSelection: _select2InitSelection
      });
    }
  }

  function _select2InitSelection(aElement, aCallback) {
    var selectedId = aElement.data('selected-id'),
        selectedText = aElement.data('selected-text');

    if (selectedId && selectedText) {
      if (multiple) {

        // precisa limpar o valor do input pois o select2 coloca o valor
        // inicial no array de selected ids
        aElement.select2('val', '');

        aCallback(_getMultipleSelections(selectedId, selectedText));
      } else {
        aCallback({ id: selectedId, text: selectedText });
      }
    }
  }

  function _getRemoteSelect2AjaxOptions() {
    return {
      dataType: 'json',
      delay: 250,
      data: function (search, page) {
        return {
          search: search,
          page: page
        };
      },

      processResults: function (data) {
        return {
          results: data
        };
      }
    };
  }

  function _getMultipleSelections(aSelectedIds, aSelectedTexts) {
    // espera-se um array do mesmo tamanho para os ids e textos.
    var selections = [];

    for (var i = 0; i < aSelectedIds.length; i++) {
      selections.push( {id: aSelectedIds[i], text: aSelectedTexts[i]} );
    }

    return selections;
  }

  /// setup

  function _setDefaultSelect2Options() {
    var defaults = $.fn.select2.defaults;

    defaults.set("language", "pt-BR");
    defaults.set("width", "style");
  }

  function _initAllSelect2(aContainer) {
    _initSelect2(aContainer);
    _initRemoteSelect2(aContainer);
  }

  function _init() {
    if ($.fn.select2 !== undefined) {
      _setDefaultSelect2Options();
      _initAllSelect2($(document));
    }
  }

  _init();
});
