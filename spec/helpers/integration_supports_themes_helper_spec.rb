require 'rails_helper'

describe IntegrationSupportsThemesHelper do

  let!(:axix) { create(:integration_supports_theme, descricao_tema: 'Tema 2') }
  let!(:other_theme) { create(:integration_supports_theme, descricao_tema: 'Tema 1') }

  it 'supports_themes_for_select_with_all_option' do
    themes = Integration::Supports::Theme.order(:descricao_tema)

    expected = themes.map do |theme|
      ["#{theme.descricao_tema}", theme.id]
    end.insert(0, [I18n.t('theme.select.all'), ' '])

    expect(supports_themes_for_select_with_all_option).to eq(expected)
  end
end
