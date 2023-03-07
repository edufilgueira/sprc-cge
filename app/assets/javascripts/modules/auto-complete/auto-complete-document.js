/**
 * Componente para carregar dados do usuário dinamicamente usando jQuery-flexdatalist pelo campo [data-input=document]
 *
 *
 * Utiliza os seguintes parâmetros:
 *
 * data-url: Url da requisição ajax
 * data-action="search": Botão que fará a requisição no evento "click"
 * data-content="loader": Icone do botão para exibir o "loading" durante a requisição ajax
 *
 *  Ex.:
 *    - No exemplo abaixo ao inserir algum valor no campo o componente bucará na url indicada dados passando como parâmetro "document"
 *    - aContainer = $('[data-content=document]')
 *
 *      <div data-content="document" data-url="/api/v1/operator/tickets/search"/>
 *        <input name="name" data-url="/my/custom/search/url"/>
 *        <a href="javascript:void(0)" data-action="search">
 *          <i aria-hidden="true" class="fa fa-search" data-content="loader"/>
 *        </a>
 *      </div>
 *
 *      - Nesse caso a requisição ficará
 *         GET: "/my/custom/search/url?document=something"
 *
 */

/**
 * @constructor
 *
 * @param {jQuery} aContainer Objeto jQuery que deve ser o container que possui o botão com [data-action=search]
 * @return {AutoCompleteDocument}
 */
function AutoCompleteDocument(aContainer) {
'use strict';

  var _container = aContainer,
      _button = _container.find('[data-action=search]'),
      _loader = _button.find('[data-content=loader]'),

      _domDocument = _container.find('[data-input=document]'),

      _url = _container.data('url'),

      _autoCompleteHelper = new AutoCompleteHelper();


  _container.on('ajax:before', function() {
    _startLoading($(this));
  });

  _container.on('ajax:success', function() {
    _stopLoading($(this));
  });

  _button.on('click', function() {
    var button = $(this);

    $.ajax({
      url: _url,
      dataType: 'json',
      data: {
        document: _domDocument.val()
      },
      success: function(aData) {
        if (aData !== null) {
          _autoCompleteHelper.fillContactInfo(aData);
          _autoCompleteHelper.fillUserInfo(aData);
        }
      },
      beforeSend: function() {
        _startLoading(button);
      },
      complete: function() {
        _stopLoading(button);
      }
    });
  });


  function _startLoading(aContainer) {
    aContainer.addClass('disabled');
    _showLoader();
  }

  function _stopLoading(aContainer) {
    aContainer.removeClass('disabled');
    _hideLoader();
  }

  function _hideLoader() {
    _loader.addClass('fa-search');
    _loader.removeClass('fa-spin');
    _loader.removeClass('fa-spinner');
  }

  function _showLoader() {
    _loader.removeClass('fa-search');
    _loader.addClass('fa-spin');
    _loader.addClass('fa-spinner');
  }
}
