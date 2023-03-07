//= require modules/remote-select2

$(function(){
'use strict';
  var _domSubDepartment = $('[data-input=filter_sub_department]'),
    _domTopic = $('[data-input=filter_topic]'),
    _domServiceType = $('[data-input=filter_service_type]'),
    _domDepartment = $('[data-input=filter_department]'),
    _domOrgan = $('[data-input=filter_organ]'),
    _solicitSample = $('#solicit_sample');

  var _subDepartment = new RemoteSelect2(_domSubDepartment, true),
    _topic = new RemoteSelect2(_domTopic, true),
    _serviceType = new RemoteSelect2(_domServiceType, true),
    _department = new RemoteSelect2(_domDepartment, true);

  function _hideOrShowSolicitSample () {
    if( _domOrgan.val() == '' ){
      _solicitSample.hide();
    }else{
      _solicitSample.show();
    };
  }

  function init() {
    _hideOrShowSolicitSample();
  }

  init();

});
