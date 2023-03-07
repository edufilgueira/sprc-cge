//= require components/utils/dom-helper
//= require components/utils/event-key-helper
//= require components/utils/url-helper


/**
 * Componente responsável por controlar um mapa svg.
 */

function SvgMap(aSvgMapContainer) {
'use strict';

  /* globals */
  var self = this,
      _domSvgMapContainer = $(aSvgMapContainer),
      _domHelper = new DomHelper(_domSvgMapContainer),
      _eventKeyHelper = new EventKeyHelper(),
      _urlHelper = new UrlHelper(),
      _svgDocument = null;


  /* public API */

  self.selectRegion = function(aRegionAcronym) {
    _selectedRegion(aRegionAcronym, false /* fireEvent? */);
  };

  self.clearSelection = function() {
    _clearSelectedRegion();
  };

  self.highlightRegions = function(aRegionAcronyms) {
    _highlightRegions(aRegionAcronyms);
  };

  self.clearHighlight = function() {
    _clearHighlight();
  };

  /* privates */

  function _highlightRegions(aRegionAcronyms) {
    _getMapRegionElements(aRegionAcronyms).attr('highlighted', 'true');
  }

  function _clearHighlight() {
    _getAllMapRegionElements().attr('highlighted', false);
  }

  function _clearSelectedRegion(aFireEvent) {
    _getAllMapRegionElements().attr('selected', false);

    if (aFireEvent === true) {
      _domHelper.fireEvent('ppa:map:selected', null);
    }
  }

  function _selectedRegion(aRegion, aFireEvent) {
    _getMapRegionElement(aRegion).attr('selected', true);

    if (aFireEvent === true) {
      _domHelper.fireEvent('ppa:map:selected', aRegion);
    }
  }

  function _getAllMapRegionElements() {
    return $(_svgDocument).find('.region');
  }

  function _getMapRegionElement(aRegion) {
    return $(_svgDocument).find('#' + aRegion);
  }

  function _getMapRegionElements(aRegionAcronyms) {
    return $(_svgDocument).find(_selectorForRegions(aRegionAcronyms));
  }

  function _selectorForRegions(aRegionAcronyms) {
    var result = '';

    for (var i = 0; i < aRegionAcronyms.length; i++) {
      result += '#' + aRegionAcronyms[i];
      if (i < aRegionAcronyms.length - 1) {
        result += ',';
      }
    }

    return result;
  }

  /* setup */

  /*
   * Event handlers do documento SVG que só devem ser inicializados após o load
   */
  function _initSvgEventHandlers() {
    _svgDocument = _domSvgMapContainer[0];

    if (_svgDocument === null) {
      return;
    }

    /* event handlers */

    // usuário clicou em alguma region

    _svgDocument.addEventListener('click', function(aEvent){
      var event = aEvent,
          regionNode = $(event.target).closest('.region'),
          region = regionNode.attr('id');

      _clearSelectedRegion(false /* fireEvent? */);
      _selectedRegion(region, true /* fireEvent? */);
    }, true);
  }

  function _init() {
    _initSvgEventHandlers();
  }

  _init();
}
