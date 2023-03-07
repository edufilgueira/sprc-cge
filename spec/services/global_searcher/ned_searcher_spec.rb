require 'rails_helper'

describe GlobalSearcher::NedSearcher do
  include ActionView::Helpers::SanitizeHelper

  let(:url_helper) do
    Rails.application.routes.url_helpers
  end

  let(:management_unit) { create(:integration_supports_management_unit, poder: 'EXECUTIVO', sigla: 'SIGLA1234456', codigo: '9393929299299393939') }

  let!(:found_ned) { create(:integration_expenses_ned, unidade_gestora: management_unit.codigo, natureza: 'Ordinária', numero: '1234', especificacao_geral: "<p>#{'A'*(GlobalSearcher::Base::DESCRIPTION_TRUNCATE_SIZE + 10)}</p>") }
  let!(:not_found_ned) { create(:integration_expenses_ned, numero: '5678') }

  let(:expected_result) do
    expected_description = strip_tags(found_ned.especificacao_geral)&.truncate(GlobalSearcher::Base::DESCRIPTION_TRUNCATE_SIZE)

    {
      id: 'Integration::Expenses::Ned',

      results: [{
        title: found_ned.title,
        description: expected_description,
        link: url_helper.transparency_expenses_ned_path(found_ned, locale: I18n.locale)
      }],

      show_more_url: url_helper.transparency_expenses_neds_path(search: search_term, anchor: 'search', locale: I18n.locale)
    }
  end

  describe 'numero' do
    let(:search_term) { found_ned.numero }

    it 'search' do
      result = GlobalSearcher.call(:ned, search_term)

      expect(result).to eq(expected_result)
    end
  end

  it 'limits to 5 results' do
    stub_const('GlobalSearcher::Base::SEARCH_LIMIT', 1)

    expect(GlobalSearcher::NedSearcher::SEARCH_LIMIT).to eq(1)

    expect(GlobalSearcher::NedSearcher.call('23')[:results].count).to eq(1)
  end
end
