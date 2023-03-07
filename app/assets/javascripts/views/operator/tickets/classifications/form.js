//= require modules/remote-select2
//= require modules/utils/content-utils
//= require components/helper/classification-helper

$(function() {
'use strict';

  var _domForm = $('form'),
    _domTopic = $('[data-input=topic]'),
    _domSubtopic = $('[data-input=subtopic]'),
    _domDepartment = $('[data-input=classification_department]'),
    _domSubdepartment = $('[data-input=classification_sub_department]'),
    _domServiceType = $('[data-input=service_type]'),

    _subtopic = new RemoteSelect2(_domSubtopic, true),
    _subdepartment = new RemoteSelect2(_domSubdepartment, true),
    _topic = new RemoteSelect2(_domTopic, true),
    _serviceType = new RemoteSelect2(_domServiceType, true),
    _department = new RemoteSelect2(_domDepartment, true),

    _classificationHelper = new ClassificationHelper(_domForm);


  _domTopic.on('change', function() {
    _subtopic.clear();
  });

  _domDepartment.on('change', function() {
    _subdepartment.clear();
  });

});
