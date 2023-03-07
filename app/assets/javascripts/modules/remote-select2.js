/**
 * Componente para carregar conteúdo dinamicamente usando select2
 *
 * Utiliza os seguintes parâmetros:
 *
 * data-url: Url da requisição ajax
 * data-placeholder: Placeholder usado no select2
 * data-text: Label do valor selecionado
 * data-param-name: Nome do parâmetro usado para passar na requisição - obtem o valor do parâmetro buscando o elemento com "[data-input=${param-name}]"
 *
 *  Ex.:
 *    - No exemplo abaixo o campo "subtopic" depende do valor de "topic" para carregar
 *
 *    <input name="topic" data-input="topic" />
 *    <input name="subtopic" data-url="<url>" data-placeholder="placeholder" data-text="Selected text" ata-input="subtopic" data-param-name="topic" />
 *
 */

/**
 * @constructor
 *
 * @param {jQuery} aContainer Objeto jQuery que deve ser o elemento select
 * @return {RemoteSelect2}
 */
function RemoteSelect2(aContainer, aSearchAjax) {
'use strict';

  var self = this,
      _container = aContainer,
      _searchAjax = aSearchAjax;


  self.clear = function() {
    _container.val(null).trigger('change');
  };


  function _getRemoteSelect2AjaxOptions(aSelect) {
    return {
      url: aSelect.data('url'),
      dataType: 'json',
      data: function () {
        var data = {};
        data[_getParamName()] = _getParamValue();

        return data;
      },
      processResults: function (data) {
        return _buildResult(data);
      },
      cache: true
    };
  }

  function _buildResult(data) {
    var results = [];

    $.each(data, function(key, value) {
      results.push({ id: value, text: key });
    });

    return { results: results };
  }

  function _getRemoteDataAjaxSelect2(aSelect) {
    return {
      url: aSelect.data('url'),
      dataType: 'json',
      delay: 250,
      data: function (params) {
        var data = {};
        data[_getParamName()] = _getParamValue();
        data["term"] = params.term
        data["page"] = params.page

        return data;
      },
      processResults: function (data, params) {
        return _buildResultSearch(data, params);
      },
      cache: true
    };
  }

  function _buildResultSearch(data, params) {
    var results = [];
    params.page = params.page || 1;

    $.each(data.results, function(key, value) {
      results.push({ id: value, text: key });
    });

    return {
      results: results ,
      pagination: {
        more: (params.page * 10) < data.count_filtered
      }
    };
  }



  function _load(input, searchAjax) {
    var emptyOption = input.find('option[value=""]'),
        placeholder = input.data('placeholder') || emptyOption.text() || ' ',
        loaderType = searchAjax ? _getRemoteDataAjaxSelect2(input) : _getRemoteSelect2AjaxOptions(input);


    input.select2({
      placeholder: {
        id: '',
        text: placeholder
      },
      ajax: loaderType
    });
  }

  function _getParamValue() {
    return $('[data-input="'+ _getParamName() + '"]').val();
  }

  function _getParamName() {
    return _container.data('param-name');
  }

  function _init() {
    _load(_container, _searchAjax);
  }

  _init();
}
