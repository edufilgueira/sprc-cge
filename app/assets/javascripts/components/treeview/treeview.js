/**
 * Componente responsável por controlar e exibir árvores (Receitas, Despesas, ...)
 *
 */

function Treeview(aTreeviewContainer) {
'use strict';

  /* globals */
  var self = this,
      _domTreeviewContainer = $(aTreeviewContainer);

    /* Events */

  _domTreeviewContainer.on('click', 'tr[data-node]', function(e) {
    _onNodeClick(e)
  } );

  /* Privates */

  function _onNodeClick(aEvent) {
    var node = $(aEvent.currentTarget),
        nodeOpened = (node.attr('data-node-opened') === 'true');

    if (nodeOpened) {
      _closeNode(node);
    } else {
      _openNode(node);
    }
  }

  function _closeNode(aNode) {
    var node = aNode,
        nodeId = node.data('node'),
        childrenSelector = nodeId + '/',
        revenuesTable = _domTreeviewContainer.find('table'),
        removedNodes = revenuesTable.find("[data-node^='" + childrenSelector + "']").detach();

    node.data('cached-result', removedNodes);

     // importante usar o atributo em vez do data por conta do css
    node.attr('data-node-opened', 'false');
  }

  function _openNode(aNode) {
    var node = aNode,
      nodeChildrenUrl = node.data('node-children-url'),
      nodeLoading = !!(node.data('node-loading')),
      cachedResult = node.data('cached-result');

    if (nodeChildrenUrl !== '') {


      // importante usar o atributo em vez do data por conta do css
      node.attr('data-node-opened', 'true');

      if (cachedResult !== undefined) {
        cachedResult.insertAfter(node);
      } else {

        if (! nodeLoading) {

          // importante usar o atributo em vez do data por conta do css
          node.attr('data-node-loading', 'true');

          $.get(nodeChildrenUrl)
            .done(function(aData){
              var trs = $(aData);

              trs.insertAfter(node);
            })
            .always(function () {

              // importante usar o atributo em vez do data por conta do css
              node.attr('data-node-loading', 'false');
            });
        }
      }
    }
  }
}
