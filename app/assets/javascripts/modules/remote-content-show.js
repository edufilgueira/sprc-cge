function RemoteContentShow(aContainer) {

  var _container = aContainer,
      _url = _container.data('url'),
      _domHelper = new DomHelper(_container),
      _remoteContentId = _container.data('remote-content'),
      _domResult = _domHelper.findByData('remote-content-result', _remoteContentId),
      _domLoading = _container.find('[data-loading]'),
      _domResultContent = _container.find('.remote-content-result');

  $.get(_url, function(aData) {
    before: {
      _startLoading();
    }
    success: {
      _showResults(aData);
    }
  });

  _container.on('ajax:before', function(aEvent, aData) {
    _startLoading();
  });

  _container.on('ajax:success', function(aEvent, aData) {
    _showResults(aData);
  });

  /* privates */

  function _showResults(aData) {
    var data = $(aData),
        wrapper = $('<div>');

    wrapper.html(data);

    _domResult.html(wrapper);

    _stopLoading();

    _domHelper.fireEvent('remote-content:after');
  }

  /** loading */

  function _startLoading() {
    _domResultContent.hide();
    _domLoading.show();
  }

  function _stopLoading() {
    _domResultContent.show();
    _domLoading.hide();
  }

}
