/**
 * Componente para buscar modelo de resposta usando jQuery-flexdatalist
 *
 *
 * Utiliza os seguintes parâmetros:
 *
 * data-url: Url da requisição ajax
 * data-target: Nome do campo que será preenchido com o modelo - elemento com "[data-input=${target}]"
 *
 */

/**
 * @constructor
 *
 * @param {jQuery} aContainer Objeto jQuery que deve ser o elemento <input>
 * @return {AutoComplete}
 */
function AnswerTemplate(aContainer) {
'use strict';

  var self = this,
    _container = aContainer,

    _input = _container.find('input'),
    _url = _container.data('url'),
    _loader = _container.find('[data-content=loading]'),
    _target = $('[data-input=' + _container.data('target') + ']'),

    DEFAULT_FLEXLIST_OPTIONS = {
      cache: true,
      cacheLifetime: 20,
      searchContain: true,
      visibleProperties:['name'],
      keywordParamName: 'name',
      searchIn: 'name',
      url: _url,
      noResultsText: 'Nenhum resultado encontrado para "{keyword}"',
      disabled: false,
      debug: false
    };


  _container.on('select:flexdatalist', function(event, obj) {
    _setContent(obj['content']);
  });


  _container.on('before:flexdatalist.data', function() {
    _showLoader();
  });

  _container.on('after:flexdatalist.data', function() {
    _hideLoader();
  });

  function _load(aInput) {
    aInput.flexdatalist(DEFAULT_FLEXLIST_OPTIONS);
  }

  function _hideLoader() {
    _loader.hide();
  }

  function _showLoader() {
    _loader.show();
  }

  function _setContent(aContent) {
    var id = _target.attr('id');

    CKEDITOR.instances[id].setData(aContent);
  }

  function _init() {
    _hideLoader();
    _load(_input);
  }

  _init();

}
