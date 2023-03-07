require 'rails_helper'

describe GlobalSearcher::ConvenantSearcher do
  include ActionView::Helpers::SanitizeHelper

  let(:url_helper) do
    Rails.application.routes.url_helpers
  end

  let!(:found_convenant) { create(:integration_contracts_convenant, isn_sic: 999999, descricao_objeto: "<p>#{'A'*(GlobalSearcher::Base::DESCRIPTION_TRUNCATE_SIZE + 10)}</p>") }
  let!(:another_convenant) { create(:integration_contracts_convenant, descricao_situacao: 'other') }

  let(:expected_result) do
    expected_description = strip_tags(found_convenant.descricao_objeto)&.truncate(GlobalSearcher::Base::DESCRIPTION_TRUNCATE_SIZE)

    {
      id: 'Integration::Contracts::Convenant',

      results: [{
        title: found_convenant.title,
        description: expected_description,
        link: url_helper.transparency_contracts_convenant_path(found_convenant, locale: I18n.locale)
      }],

      show_more_url: url_helper.transparency_contracts_convenants_path(search: search_term, anchor: 'search', locale: I18n.locale)
    }
  end

  describe 'isn_sic' do
    let(:search_term) { found_convenant.isn_sic }

    it 'search' do
      result = GlobalSearcher::ConvenantSearcher.call(found_convenant.isn_sic)
      expect(result).to eq(expected_result)
    end
  end

  describe 'num_contrato' do
    let(:search_term) { found_convenant.num_contrato }

    it 'search' do
      result = GlobalSearcher::ConvenantSearcher.call(found_convenant.num_contrato)
      expect(result).to eq(expected_result)
    end
  end

  describe 'plain_num_contrato' do
    let(:search_term) { found_convenant.plain_num_contrato }

    it 'search' do
      result = GlobalSearcher::ConvenantSearcher.call(found_convenant.plain_num_contrato)
      expect(result).to eq(expected_result)
    end
  end

  describe 'descricao_objeto' do
    let(:search_term) { found_convenant.descricao_objeto }

    it 'search' do
      result = GlobalSearcher::ConvenantSearcher.call(found_convenant.descricao_objeto)
      expect(result).to eq(expected_result)
    end
  end

  describe 'cpf_cnpj_financiador' do
    let(:search_term) { found_convenant.cpf_cnpj_financiador }

    it 'search' do
      result = GlobalSearcher::ConvenantSearcher.call(found_convenant.cpf_cnpj_financiador)
      expect(result).to eq(expected_result)
    end
  end

  describe 'sigla unidade' do
    let(:sigla) do
      organ_sigla = 'SDE'
      organ = create(:integration_supports_organ, sigla: organ_sigla, orgao_sfp: false)
      found_convenant.manager = organ
      found_convenant.save

      organ_sigla
    end

    let(:search_term) { sigla }

    it 'search' do
      result = GlobalSearcher::ConvenantSearcher.call(sigla)
      expect(result).to eq(expected_result)
    end
  end

  it 'limits to 5 results' do
    stub_const('GlobalSearcher::Base::SEARCH_LIMIT', 1)

    expect(GlobalSearcher::ConvenantSearcher::SEARCH_LIMIT).to eq(1)

    expect(GlobalSearcher::ConvenantSearcher.call(found_convenant.isn_sic)[:results].count).to eq(1)
  end
end
