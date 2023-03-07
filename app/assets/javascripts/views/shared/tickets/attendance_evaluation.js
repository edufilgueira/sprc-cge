//= require views/operator/tickets/attendance_evaluations/attendance_evaluation

/*
 * JavaScript de shared/tickets/attendance_evaluation
 */

$(function(){
'use strict';

  // globals

  var _domContainer = $("[data-content=attendance_evaluation]"),
      _attendanceEvaluation = new AttendanceEvaluation(_domContainer);

  // event handlers


  _domContainer.on('ajax:before', function() {
    _startLoading($(this));
  });

  _domContainer.on('ajax:success', function(aEvent, aData) {
    _showResults($(this), aData);
  });

  _domContainer.on('ajax:remotipartComplete', function(aEvent, aData) {
    _showResults($(this), aData.responseText);
  });

  // privates

  function _startLoading(aContainer) {
    _getLoader(aContainer).removeClass('hidden-xs-up');
  }

  function _stopLoading(aContainer) {
    _getLoader(aContainer).addClass('hidden-xs-up');
  }

  function _getLoader(aContainer) {
    return aContainer.find('[data-content=attendance_evaluation-loader]');
  }

  function _showResults(aContainer, aData) {
    var container = aContainer;

    container.html(aData);
    _stopLoading(container);

    _attendanceEvaluation = new AttendanceEvaluation(_domContainer);
  }

});
