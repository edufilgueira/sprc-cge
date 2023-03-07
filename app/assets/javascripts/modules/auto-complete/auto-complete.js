/**
 * Componente para carregar dados do usuário dinamicamente usando jQuery-flexdatalist
 *
 *
 * Utiliza os seguintes parâmetros:
 *
 * data-url: Url da requisição ajax
 * data-param-name: Nome do parâmetro usado para passar na requisição - obtem o valor do parâmetro buscando o elemento com "[data-input=${param-name}]"
 *
 *  Ex.:
 *    - No exemplo abaixo ao inserir algum valor no campo o componente bucará na url indicada dados passando como parâmetro "name"
 *
 *      <input name="name" data-url="/my/custom/search/url" data-param-name="name" />
 *
 *      - Nesse caso a requisição ficará
 *         GET: "/my/custom/search/url?name=something"
 *
 */

/**
 * @constructor
 *
 * @param {jQuery} aContainer Objeto jQuery que deve ser o elemento <input>
 * @return {AutoComplete}
 */
function AutoComplete(aContainer, aOptions) {
'use strict';

  var _container = aContainer,
      _options = aOptions || {},

      _input = _container.find('input'),
      _paramName = _input.data('param-name'),
      _url = _input.data('url'),
      _defaultVisibleProperties = ["name", "email", "document"],
      _visiblePropertiesData = _input.data('visible-properties'),
      _visibleProperties =  _visiblePropertiesData !== undefined ? _visiblePropertiesData : _defaultVisibleProperties,
      _loader = _container.find('[data-content=loading]'),

      DEFAULT_FLEXLIST_OPTIONS = {
        cache: true,
        cacheLifetime: 20,
        searchContain: true,
        visibleProperties: _visibleProperties,
        keywordParamName: _paramName,
        searchIn: _paramName,
        url: _url,
        noResultsText: 'Nenhum resultado encontrado para "{keyword}"',
        disabled: false,
        debug: false,
        normalizeString: function (aText) {
          return _latinize(aText);
       }
      },

      autoCompleteHelper = new AutoCompleteHelper();


  _container.on('select:flexdatalist', function(event, obj) {
    autoCompleteHelper.fillContactInfo(obj);
    autoCompleteHelper.fillUserInfo(obj);
  });


  _container.on('before:flexdatalist.data', function() {
    _showLoader();
  });

  _container.on('after:flexdatalist.data', function() {
    _hideLoader();
  });

  function _load(input) {
    input.flexdatalist($.extend(DEFAULT_FLEXLIST_OPTIONS, _options));
  }

  function _hideLoader() {
    _loader.hide();
  }

  function _showLoader() {
    _loader.show();
  }

  function _init() {
    _hideLoader();
    _load(_input);
  }

  function _latinize(text) {
    if (text !== undefined) {
      return text.normalize('NFD').replace(/[\u0300-\u036f]/g, "");
    } else {
      return text;
    }
  }

  _init();

}
