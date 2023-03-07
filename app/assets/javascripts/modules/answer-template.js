//= require ./answer-template/answer-template
$(function() {
'use strict';

  // event_handlers

  $(document).on('remote-form:after', _initSelectAfterEvent);


  // private

  function _initSelectAfterEvent(aEvent) {
    _init(aEvent.target);
  }

  function _init(aContainer) {
    $(aContainer).find('[data-content=answer_template]').each(function() {
      AnswerTemplate($(this));
    });
  }

  _init(document);
});
