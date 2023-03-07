//= require modules/answer-form

/*
 * JavaScript de shared/answers/form
 */
 $(function() {

  var _domAnswerForm = $('[data-content=answer-form]'),
    _domParentContainer = _domAnswerForm.closest('[data-content=ticket_logs]');

  // event_handlers

  _domParentContainer.on('remote-form:after', function() {
    _domAnswerForm = _domParentContainer.find('[data-content=answer-form]');

    _init(_domAnswerForm);
  });

  // privates

  function _init(aContainer) {
    AnswerForm(aContainer);
  }

  _init(_domAnswerForm);

});

CKEDITOR.on('dialogDefinition', function (element) {
  var dialogName = element.data.name;
  var dialogDefinition = element.data.definition;

  // Verifica se o botao clicado foi o de link
  if (dialogName == 'link'){
      // Padrao link deve abrir em nova aba
      var targetField = dialogDefinition.getContents('target').get('linkTargetType');
      targetField['default'] = '_blank';

      // Remove abas desnecessarias
      dialogDefinition.removeContents('advanced');
      // dialogDefinition.removeContents('target');
      dialogDefinition.removeContents('upload');

      // Variavel com referencia para a aba de informacoes
      var infoTab = dialogDefinition.getContents('info');

      // Removendo componentes desnecessarios da aba de informacoes
      // infoTab.remove('linkType');
      infoTab.remove('browse');
  }
});