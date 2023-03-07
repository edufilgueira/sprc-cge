$(function(){
  'use strict';

  var DEFAULT_MILLISECONDS = 5000,
    _mainStatus = 'checking',

    _domContainer = $('[data-main-container]'),
    _domStatusSou = _domContainer.find('[data-type=sou]'),
    _domStatusSic = _domContainer.find('[data-type=sic]'),
    _domFormSou = _domContainer.find('[data-form=sou]'),
    _domFormSic = _domContainer.find('[data-form=sic]'),

    _intervalSou = null,
    _intervalSic = null;

  _domFormSou.on('ajax:success', function(e, data){
    _domFormSou.hide();
    _updateStatsTicketSou(data);
  });

  _domFormSic.on('ajax:success', function(e, data){
    _domFormSic.hide();
    _updateStatsTicketSic(data);
  });

  _domContainer.on('ajax:error', function(){
    window.location.reload();
  });

  function _updateStatsTicketSou(aData) {
    _updateStatusData(_domStatusSou, aData);
    _updateIntervalSou();
  }

  function _updateStatsTicketSic(aData) {
    _updateStatusData(_domStatusSic, aData);
    _updateIntervalSic();
  }

  function _updateIntervalSou() {
    _domStatusSou.show();
    _intervalSou = setInterval(_checkStatusSou, DEFAULT_MILLISECONDS);
  }

  function _updateIntervalSic() {
    _domStatusSic.show();
    _intervalSic = setInterval(_checkStatusSic, DEFAULT_MILLISECONDS);
  }

  function _checkStatusSic() {
    _checkStatus(_domStatusSic, _intervalSic);
  }

  function _checkStatusSou() {
    _checkStatus(_domStatusSou, _intervalSou);
  }

  function _updateStatusData(aStatusContainer, aData) {
    aStatusContainer.data('status', aData.status);
    aStatusContainer.data('path', aData.path);
  }

  function _checkStatus(aContainerStatus, aInterval) {
    var path = aContainerStatus.data('path'),
      currentStatus = aContainerStatus.data('status');

    if (_mainStatus === 'checking') {
      _updateStatus(currentStatus, path, aInterval);
    }
  }


  function _updateStatus(aStatus, aPath, aInterval){
    if (aStatus === "created" || aStatus === "ready") {
      clearInterval(aInterval);
    } else {
      _getNewStatus(aPath);
    }
  }

  function _getNewStatus(aPath) {
    $.get(aPath, function(aData) {
      if (aData.status === "created") {
        _mainStatus = 'done';
        window.location.reload();
      }
    });
  }

  function _init() {
    _intervalSou = setInterval(_checkStatusSou, DEFAULT_MILLISECONDS);
    _intervalSic = setInterval(_checkStatusSic, DEFAULT_MILLISECONDS);
  }

  _init();

});
