//= require modules/form/organ-select

/**
 * JavaScript para criar seleção de órgãos usando o componente OrganSelect
 *
 *
 * Estrutura esperada:
 *
 * <div data-content="organs">
 *
 *   <div data-content="organ">
 *   </div>
 *
 *   <div data-content="organ">
 *   </div>
 *
 * </div>
 *
 */
function OrgansSelect(aContainer) {
'use strict';

  // globals

  var self = this,
    _domContainer = aContainer;

  // public

  // events

  $(_domContainer).on('cocoon:after-insert', _cocoonAfterInsertOrgan);

  // privates


  function _initSelectOrgans() {
    _domContainer.find('[data-content=organ]').each(function() {
      _buildOrganSelect($(this));
    });
  }

  function _buildOrganSelect(aContainer) {
    OrganSelect(aContainer);
  }

  function _cocoonAfterInsertOrgan(aEvent, aElement) {
    _buildOrganSelect(aElement);
  }

  // setup

  function _init() {
    _initSelectOrgans();
  }

  _init();
}
