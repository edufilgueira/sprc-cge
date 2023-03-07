/**
 *
 * Módulo que preenche os campos de endereço pelo CEP
 *
 *
 *  [construtor]
 *
 *  - aCepInput: Objeto jquery que possui CEP
 *
 *
 * Web Service utilizado:
 * - ViaCEP (https://viacep.com.br/)
 * - Gratuito e de alto desempenho
 *
 *
 * Utiliza os seguintes parâmetros:
 *
 *    [data-input=state]                          :    Input do Campo Estado
 *    [data-input=city]                           :    Input do Campo Município
 *    [data-input$="street"]                      :    Input do Campo Rua/Av.
 *    [data-input$="neighborhood"]                :    Input do Campo Bairro
 *
 *
 */
function AddressFiller(aCepInput) {
'use strict';

  // consts

  var WS_URL = 'https://viacep.com.br/ws/00000-000/json/';

  // globals

  var _domCepInput = aCepInput;

  var city = '';


  // event handlers

  /*
   *
   *
   * evento 'blur' é disparado quando o foco sai do campo
   *
   *
   */
  _domCepInput.on('blur', function() {

    // ex: 60822-325
    var value = $(this).val();

    if (value === '' || value.match(/\d/g).length !== 8) {
      /*
       *
       * o serviço não é acionado se o CEP estiver no formato incorreto
       *
       */
      return;
    }

    var url = WS_URL.replace('00000-000', value);

    _call(url);

  });


  // privates

  function _call(aURL) {
    $.get(aURL, function(aData) {
      if (!aData.erro) {
        _showResults(aData);
      }
    });
  }


  function _showResults(aData) {

    var _domAddressFieldsContent = aCepInput.parents('[data-content=address-fields]'),
        result = aData,
        location = _location(result),
        ufContainer = _domAddressFieldsContent.find('[data-input=state]'),
        ufCode = _findByCode(ufContainer, location.uf);

    // atualizando o select do estado
    ufContainer.val(ufCode).change();

    // variável global para evitar imutable variable dentro da trigger 'after:cities:load'
    city = location.city;

    // aguardando os municipios do estado serem carregados
    ufContainer.on('after:cities:load', function() {
      var cityContainer = $(this).parents('[data-content=address-fields]').find('[data-input=city]'),
          cityCode = _findByCode(cityContainer, city);

      // atualizando o select do minicípio
      cityContainer.val(cityCode).change();
    });

    _domAddressFieldsContent.find('[data-input$="street"]').val(location.street);
    _domAddressFieldsContent.find('[data-input$="neighborhood"]').val(location.neighborhood);
  }


  function _location(aData) {
    /*
     * Exemplo de retorno do ViaCEP:
     *
     *
     * GET: https://viacep.com.br/ws/60822325/json/
     *
     * {
     *   "cep": "60822-325",
     *   "logradouro": "Avenida General Afonso Albuquerque Lima",
     *   "complemento": "",
     *   "bairro": "Cambeba",
     *   "localidade": "Fortaleza",
     *   "uf": "CE",
     *   "unidade": "",
     *   "ibge": "2304400",
     *   "gia": ""
     * }
     *
     * OBS: Caso algum chave do WS se altere, o mapeamento deve ser alterado aqui:
     */
    var data = aData,
        location = {
          uf: data.uf,
          city: data.localidade,
          street: data.logradouro,
          neighborhood: data.bairro
        };

    return location;
  }

  /*
   *
   * Retorna o código da option do select
   *
   *   aCitySelect   :   select:input (Objeto Jquery)
   *   aLocation     :   string (Nome do objeto a ser buscado)
   *
   */
  function _findByCode(aCitySelect, aLocation) {
    return aCitySelect.find("option:contains('" + aLocation + "')").val();
  }

}
