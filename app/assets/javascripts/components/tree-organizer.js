//= require components/utils/dom-helper

/**
 * Componente responsável pela reorganização de árvores em ferramentas de
 * receitas ou despesas.

 /* global DomHelper
  */

function TreeOrganizer(aTreeOrganizerContainer) {
'use strict';

  var self = this,
      _domTreeOrganizerContainer = aTreeOrganizerContainer,
      _domHelper = new DomHelper(_domTreeOrganizerContainer);

  /* public API */


  /* event handlers */

  _domTreeOrganizerContainer.on('click', '[data-restore-default]', function() {
    _restoreDefault();
    _triggerChange();
  });

  _domTreeOrganizerContainer.on('click', '[data-remove]', function() {
    var nodeTypeElement = $(this).closest('[data-node-type]');

    _removeElement(nodeTypeElement);
    _triggerChange();
  });

  _domTreeOrganizerContainer.on('click', '[data-selected-value-container]', function() {
    _toggleBox();
  });

  _domTreeOrganizerContainer.on('click', '[data-close]', function() {
    _closeBox();
  });

  _domTreeOrganizerContainer.on('change', '[data-select-node-types]', function() {
    var selectedValue = $(this).val();

    _addElement(selectedValue);
    _triggerChange();
  });

  /* privates */

  function _updateItemsIndex() {
    var _visibleItems = _getVisibleItems();

    _visibleItems.each(function(aIndex, aElement) {
      var item = $(aElement);

      item.attr('data-node-level', aIndex);

      item.find('[data-position]').html(aIndex + 1);
    });
  }

  function _removeElement(aNodeTypeElement) {
    $(aNodeTypeElement).attr('data-removed', 'true');

    _updateState();
  }

  function _removeAll() {
    _getVisibleItems().each(function(aIndex, aElement) {
      _removeElement(aElement);
    });
  }

  function _addElement(aNodeType) {
    var element = _domHelper.find('[data-node-type=' + aNodeType + ']');

    if (element.attr('data-removed') === 'true') {
      element.attr('data-removed', null);

      _updateState();
    }
  }

  function _updateSelectedValue() {
    var value = _getSelectedValue();

    _getSelectedNodesInput().val(value);

    _domTreeOrganizerContainer.attr('data-selected', value);

    // Atualiza campo com a forma de exibição
    _domHelper.find('[data-selected-value-message]').html(_getSelectedValueName());
  }

  function _restoreDefault() {
    var defaultNodeTypes = _domTreeOrganizerContainer.attr('data-default-node-types'),
        nodeTypes = defaultNodeTypes.split('/');

    _removeAll();

    $(nodeTypes).each(function() {
      _addElement(this);
    });

    $(_getAllItems()).sort(function(a, b) {
      var firstNodeType = $(a).data('node-type'),
          secondNodeType = $(b).data('node-type'),
          firstPosition = nodeTypes.indexOf(firstNodeType),
          secondPosition = nodeTypes.indexOf(secondNodeType);

      return parseInt(firstPosition) - parseInt(secondPosition);
    }).appendTo( _domHelper.find('[data-list]') );

    _updateState();
  }

  function _restoreInitialSelection() {
    var selectedVal = _getSelectedNodesInput().val(),
        currentSelect = selectedVal.split('/');

    _removeAll();

    if (selectedVal !== '' && currentSelect.length > 0) {
      $(currentSelect).each(function() {
        _addElement(this);
      });

      _updateState();

    } else {
      _restoreDefault();
    }
  }

  function _toggleBox() {
    var container = _domHelper.find('[data-container]');

    container.slideToggle();
  }

  function _showBox() {
    var container = _domHelper.find('[data-container]');

    container.slideDown();
  }

  function _closeBox() {
    var container = _domHelper.find('[data-container]');

    container.slideUp();
  }

  function _getSelectedValue() {
    var selecteds = _getVisibleItems(),
        result = [];

    selecteds.each(function() {
      result.push($(this).attr('data-node-type'));
    });

    return result.join('/');
  }

  function _getSelectedValueName() {
    var selecteds = _getVisibleItems(),
        firstItem = _getFirstItem();

    if (selecteds.length > 0) {
      return $(selecteds[0]).find('.node-title').html();
    } else {
      return firstItem.find('.node-title').html();
    }
  }

  function _triggerChange() {
    _getSelectedNodesInput().trigger('change');
  }

  function _getSelectedNodesInput() {
    return _domTreeOrganizerContainer.find('[data-tree-selected-nodes]');
  }

  function _getDefaultMessage() {
    return _domTreeOrganizerContainer.find('[data-default-message]').html();
  }

  function _updateState() {
    _updateItemsIndex();
    _updateSelectedValue();
  }

  function _getAllItems() {
    return _domHelper.find('[data-node-type]');
  }

  function _getVisibleItems() {
    return _domHelper.find('[data-node-type]:not([data-removed=true])');
  }

  function _getFirstItem() {
    return _domHelper.find('[data-node-type]:first');
  }

  /** setup */

  function _init() {
    _initTreeOrganizer();
  }

  function _initTreeOrganizer() {
    // parametros iniciais devem ser a seleção inical!

    _domTreeOrganizerContainer.find('[data-list]').sortable({
      tolerance: 'pointer',
      containment: 'parent',
      helper: 'clone',
      cursor: 'grabbing',
      update: function() {
        _updateState();
        _triggerChange();
      }
    });

    _domTreeOrganizerContainer.find('[data-list]').disableSelection();

    _restoreInitialSelection();
  }

  _init();
}
