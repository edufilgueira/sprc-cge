/**
 * Componente auxiliar para preencher dados do usuário
 */

/**
 * @constructor
 *
 * @return {AutoCompleteHelper}
 */
function AutoCompleteHelper() {
'use strict';

  var self = this,

      _domPersonType = $('[data-input=person_type]'),
      _domIndividualName = $('[data-input=individual_name]'),
      _domLegalName = $('[data-input=legal_name]'),
      _domDocumentType = $('[data-input=document_type]'),
      _domDocument = $('[data-input=document]'),

      _domEmail = $('[data-input=email]'),
      _domAnswerPhone = $('[data-input=answer_phone]'),
      _domAnswerCellPhone = $('[data-input=answer_cell_phone]'),
      _domState = $('[data-input=state]'),
      _domCity = $('[data-input=city]'),
      _domAnswerAdressStreet = $('[data-input=answer_address_street]'),
      _domAnswerAdressNumber = $('[data-input=answer_address_number]'),
      _domAnswerAdressNeighborhood = $('[data-input=answer_address_neighborhood]'),
      _domAnswerAdressComplement = $('[data-input=answer_address_complement]'),
      _domAnswerAdressZipCode = $('[data-input=answer_address_zipcode]'),
      _domAnswerTwitter = $('[data-input=answer_twitter]'),
      _domAnswerFacebook = $('[data-input=answer_facebook]'),
      _domAnswerInstagram = $('[data-input=answer_instagram]');

  self.fillUserInfo = function(aData) {
    var selectedPersonType = _domPersonType.find(':checked').val();

    if (selectedPersonType === "individual") {
      _setIndividualPersonInfo(aData);
    } else if (selectedPersonType === "legal") {
      _setLegalPersonInfo(aData);
    }
  };

  self.fillContactInfo = function(aData) {
    _setEmail(aData) ;
    _setAnswerPhone(aData) ;
    _setAnswerCellPhone(aData);
    _setState(aData);
    _setAnswerAdressStreet(aData);
    _setAnswerAdressNumber(aData);
    _setAnswerAdressNeighborhood(aData);
    _setAnswerAdressComplement(aData);
    _setAnswerAdressZipCode(aData);
    _setAnswerTwitter(aData);
    _setAnswerFacebook(aData);
    _setAnswerInstagram(aData);
  };


  function _setIndividualPersonInfo(aData) {
    _setName(_domIndividualName, aData);
    _setDocument(aData);
  }

  function _setLegalPersonInfo(aData) {
    _setName(_domLegalName, aData);
    _setDocument(aData);
  }


  function _setName(aNameContainer, aData) {
    if (aNameContainer.val() === '') {
      aNameContainer.val(aData.name);
    }
  }

  function _setDocument(aData) {
    if (_domDocument.val() === '') {
      _domDocument.val(aData.document);

      _setDocumentType(aData);
    }
  }

  function _setDocumentType(aData) {
    if (aData.document_type !== '' && aData.document_type !== undefined) {
      _domDocumentType.val(aData.document_type).trigger('change');
    }
  }

  function _setEmail(aData) {
    if (_domEmail.val() === '') {
      _domEmail.val(aData.email);
    }
  }

  function _setAnswerPhone(aData) {
    if (_domAnswerPhone.val() === '') {
      _domAnswerPhone.val(aData.answer_phone);
    }
  }

  function _setAnswerCellPhone(aData) {
    if (_domAnswerCellPhone.val() === '') {
      _domAnswerCellPhone.val(aData.answer_cell_phone);
    }
  }

  function _setCity(aData) {
    if (_domCity.val() === '') {
      _domCity.val(aData.city_id);
      _domCity.change();
    }
  }

  function _setState(aData) {
    if (_domCity.val() === '') {
      _domState.val(aData.state_id);
      _domState.change();

      _domState.one('after:cities:load', function() {
        _setCity(aData);
      });
    }
  }

  function _setAnswerAdressStreet(aData) {
    if (_domAnswerAdressStreet.val() === '') {
      _domAnswerAdressStreet.val(aData.answer_address_street);
    }
  }

  function _setAnswerAdressNumber(aData) {
    if (_domAnswerAdressNumber.val() === '') {
      _domAnswerAdressNumber.val(aData.answer_address_number);
    }
  }

  function _setAnswerAdressNeighborhood(aData) {
    if (_domAnswerAdressNeighborhood.val() === '') {
      _domAnswerAdressNeighborhood.val(aData.answer_address_neighborhood);
    }
  }

  function _setAnswerAdressComplement(aData) {
    if (_domAnswerAdressComplement.val() === '') {
      _domAnswerAdressComplement.val(aData.answer_address_complement);
    }
  }

  function _setAnswerAdressZipCode(aData) {
    if (_domAnswerAdressZipCode.val() === '') {
      _domAnswerAdressZipCode.val(aData.answer_address_zipcode);
    }
  }

  function _setAnswerTwitter(aData) {
    if (_domAnswerTwitter.val() === '') {
      _domAnswerTwitter.val(aData.answer_twitter);
    }
  }

  function _setAnswerFacebook(aData) {
    if (_domAnswerFacebook.val() === '') {
      _domAnswerFacebook.val(aData.answer_facebook);
    }
  }

  function _setAnswerInstagram(aData) {
    if (_domAnswerInstagram.val() === '') {
      _domAnswerInstagram.val(aData.answer_instagram);
    }
  }

}
