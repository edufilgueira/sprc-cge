/**
 * Utilitário de tratamento de conteúdo
 */
function ContentUtils() {
  'use strict';

  var self = this;

  /* API pública */

  self.updateContents = _updateContents;

  self.updateContent = _updateContent;

  self.updateInput = _updateInput;

  self.updateInputs = _updateInputs;

  /* privates */

  /**
   * @param {aContents} - Array de conteúdos
   * @param {aAction} - ação sobre o conteúdo { 'hide_and_disable' || 'show_and_enable' }
   */
  function _updateContents(aContents, aAction) {
    aContents.forEach(function (content, index) {
      _updateContent(content, aAction);
    });
  }

  /**
   * @param {aContent} - conteúdo
   * @param {aAction} - ação sobre o conteúdo { 'hide_and_disable' || 'show_and_enable' }
   */
  function _updateContent(aContent, aAction) {
    var content = _getContent(aContent),
        inputs = content.find(':input'),
        disabled = (aAction === 'hide_and_disable'),
        hidden = disabled;

    inputs.prop('disabled', disabled);

    content.toggle(! hidden);

    _updateCKEditorInputs(inputs, disabled);
  }

  /**
   * Habilita/Desabilita o input
   * @param  aInput - input
   * @param  aDisabled - boolean (habilitado/desabilitado)
   */
  function _updateInput(aInput, aDisabled) {
    var input = aInput,
        disabled = aDisabled;

    input.prop('disabled', disabled);
  }

  /**
   * Habilita/Desabilita um conjunto de inputs
   * @param  aDataInputs - array de inputs
   * @param  aDisabled - boolean (habilitado/desabilitado)
   */
  function _updateInputs(aDataInputs, aDisabled) {
    var inputs = aDataInputs,
        disabled = aDisabled;

    $.each(inputs, function() {
      var input = $(this);
      _updateInput(input, disabled);
    });

    _updateCKEditorInputs($(inputs), disabled);
  }

  function _getContent(aContent) {
    if(!(aContent instanceof jQuery)) {
      aContent = $('[data-content=' + aContent + ']');
    }

    return aContent;
  }

  function _updateCKEditorInputs(aInputs, aDisabled) {
    var inputs = aInputs.filter(".ckeditor"),
      disabled = aDisabled;

      inputs.each(function() {
        var input = $(this),
          id = input.attr("id"),
          editor = CKEDITOR.instances[id];

          if (editor !== undefined && editor.status === 'ready') {
            editor.setReadOnly(disabled);
          }
      });
  }

}
