$(function() {
'use strict';

  var themeSelect = $('[data-proposal-theme-select]'),
    objectiveRadio = $('[data-proposal-objective]');

  _hideObjectives();
  _loadSelected();

  themeSelect.on('change', function(){
    var theme = $(this).find('option:selected').text();
    _filterObjectives(theme);
  });


  objectiveRadio.on('change', function(){
    var objectiveId = $(this).val();
    _loadStrategies(objectiveId);
  });

  function _loadStrategies(objectiveId) {
    var strategiesContainer = $('[data-proposal-remote-container]'),
      url = $('[data-proposal-strategies-url]').data('proposal-strategies-url');

    if ( objectiveId ) {
      url = url.replace(/:id/, objectiveId)

      $.ajax({
        url: url,
        dataType: 'html',
        success: function(data){
          strategiesContainer.html(data);
        },
        error: function(jqXHR, textStatus, errorThrown){
          // TODO colocar um alert - igual flash[:alert] - na UI
          //   Existe um componente JS para isso?
        }
      });
    }
  }

  function _loadSelected() {
    var selectedRadio = $('[data-proposal-objective]:checked');

    if ( selectedRadio.length ) {
      selectedRadio.parents('[data-proposal-theme-name]').removeClass('d-none');
      $('[data-proposal-theme-prompt]').addClass('d-none');
    }

  }

  function _hideObjectives() {
    $('[data-proposal-theme-prompt]').removeClass('d-none');
    $('[data-proposal-theme-name]').addClass('d-none');
    $('[data-proposal-theme-name] h5').addClass('d-none');
  }

  function _filterObjectives(theme) {
    $('.objectives-container').removeClass('d-none');
    $('[data-proposal-theme-prompt]').addClass('d-none');
    $('[data-proposal-theme-name]').addClass('d-none');
    $('[data-proposal-theme-name="' + theme + '"]').removeClass('d-none');
  }

});

