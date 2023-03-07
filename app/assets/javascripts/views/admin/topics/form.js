//= require modules/remote-select2

$(function() {
'use strict';

  var _domTargetTopic = $('[data-input=topic]'),
    _domTargetSubtopics = $('[data-input=subtopic]'),

    _targetSubtopics = [];

  _domTargetTopic.on('change', function() {
    _clearSubtopics();
  });

  function _loadSubtopics() {
    _domTargetSubtopics.each(function() {
      _targetSubtopics.push(new RemoteSelect2($(this)));
    });
  }

  function _clearSubtopics() {
    $.each(_targetSubtopics, function() {
      this.clear();
    });
  }

  function _init() {
    _loadSubtopics();
  }

  _init();
});
