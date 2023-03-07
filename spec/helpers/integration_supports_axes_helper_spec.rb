require 'rails_helper'

describe IntegrationSupportsAxesHelper do

  let!(:axix) { create(:integration_supports_axis, descricao_eixo: 'Eixo 2') }
  let!(:other_axis) { create(:integration_supports_axis, descricao_eixo: 'Eixo 1') }

  it 'supports_axes_for_select_with_all_option' do
    axes = Integration::Supports::Axis.order(:descricao_eixo)

    expected = axes.map do |axis|
      ["#{axis.descricao_eixo}", axis.id]
    end.insert(0, [I18n.t('axis.select.all'), ' '])

    expect(supports_axes_for_select_with_all_option).to eq(expected)
  end
end
