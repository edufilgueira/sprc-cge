//= require components/svg-map

$(function() {
'use strict';
  
  var gDomSvgMap      = $('[data-svg-map=br]'),
      gSvgMap = new SvgMap(gDomSvgMap),
      gRegionSelect   = $('[data-region-select]'),
      // gBienniumSelect = $('[data-biennium-select]'),
      gMonitoringLink = $('[data-monitoring-link]');


  gRegionSelect.on('change', function(){
    var regionCode = $(this).val(),
        regionDataId = 'r' + regionCode;

    _reloadSvgMap(regionDataId);
    _toggleRegionCard(regionDataId);
    _updateLink();
  });

  // gBienniumSelect.on('change', function(){
  //   var bienniums = $('[data-biennium]'),
  //       currentBiennium = $('[data-biennium="' + $(this).val() + '"]');

  //   bienniums.hide();
  //   currentBiennium.show();
  //   _updateLink();
  // });

  gMonitoringLink.on('click', function(event){
    
    var url = $(this).attr('href');
    if ( !url.match(/\/ppa\/[0-9]{1}\/[0-9]{2}\/+/) ) {
      event.preventDefault();
      window.location.href = url;
    }

  });

  $(document).on('ppa:map:selected', function(aEvent, aRegionCode) {
    var regionCode = aRegionCode ? aRegionCode.substring(1) : null; //removes "r" prefix

    if (regionCode) {
      _updateRegionInput(regionCode);
    }
  });

  function _updateLink() {
    var regionCode = $('[data-region-select]').val(),
        //bienniumId = $('[data-biennium-select]').val(),
        link = $('[data-monitoring-link]'),
        url;

    url = link.data('monitoring-link');

    /*if (bienniumId) {
      url = url.replace(':biennium', bienniumId.replace(/ /g,''));
    }*/

    if (regionCode) {
      url = url.replace(':region', regionCode);
    }

    link.attr('href', url)
  }

  function _reloadSvgMap(aRegionCode) {
    gSvgMap.clearSelection();
    gSvgMap.selectRegion(aRegionCode);
  }

  function _updateRegionInput(aRegionCode) {
    gRegionSelect.val(aRegionCode).trigger('change');
  }

  function _toggleRegionCard(aRegionCode) {
    $('[data-region-code]').hide();
    $('[data-region-code="' + aRegionCode + '"]').show();
  }
});
