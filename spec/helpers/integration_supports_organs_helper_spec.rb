require 'rails_helper'

describe IntegrationSupportsOrgansHelper do
  let(:organ) { build(:integration_supports_organ) }

  it 'supports_organs_for_select' do
    create(:integration_supports_organ, orgao_sfp: false)

    expected = Integration::Supports::Organ.order(:descricao_orgao).map do |organ|
      ["#{organ.acronym} - #{organ.title}", organ.id]
    end

    expect(supports_organs_for_select).to eq(expected)
  end

  it 'supports_organs_for_select_with_all_option' do
    create(:integration_supports_organ, orgao_sfp: false)

    expected = Integration::Supports::Organ.order(:descricao_orgao).map do |organ|
      ["#{organ.acronym} - #{organ.title}", organ.id]
    end

    expected.insert(0, ['Todos os órgãos', ' '])

    expect(supports_organs_for_select_with_all_option).to eq(expected)
  end

  it 'supports_organs_and_secretaries_from_executivo_for_select_with_all_option_codigo_orgao_as_id' do
    create(:integration_supports_organ, orgao_sfp: false)

    expected = Integration::Supports::Organ.order(:descricao_orgao).map do |organ|
      ["#{organ.acronym} - #{organ.title}", organ.codigo_orgao]
    end

    expected.insert(0, ['Todas', ' '])

    expect(supports_organs_and_secretaries_from_executivo_for_select_with_all_option_codigo_orgao_as_id).to eq(expected)
  end

  it 'returns orgao_sfp organs' do
    create(:integration_supports_organ, orgao_sfp: false)
    organ = create(:integration_supports_organ, orgao_sfp: true)

    expected = [
      ["#{organ.acronym} - #{organ.title}", organ.id]
    ]

    expect(supports_organs_for_select(true)).to eq(expected)
  end

  it 'organs with data_termino nil' do
    create(:integration_supports_organ, orgao_sfp: false, data_termino: Date.yesterday)
    organ = create(:integration_supports_organ, orgao_sfp: false, data_termino: nil)

    expected = [["#{organ.acronym} - #{organ.title}", organ.id]]

    expect(supports_organs_for_select).to eq(expected)
  end

  it 'ignores secretaries' do
    organ = create(:integration_supports_organ, orgao_sfp: false, data_termino: nil)
    secretary = create(:integration_supports_organ, orgao_sfp: false, data_termino: nil, codigo_orgao: '110001')

    expect(secretary).to be_secretary

    expected = [["#{organ.acronym} - #{organ.title}", organ.id]]

    expect(supports_organs_for_select).to eq(expected)
  end

  describe 'secretaries' do

    it 'supports_secretaries_for_select' do
      create(:integration_supports_organ, :secretary)

      expected = Integration::Supports::Organ.order(:descricao_orgao).map do |organ|
        ["#{organ.acronym} - #{organ.title}", organ.id]
      end

      expect(supports_secretaries_for_select).to eq(expected)
    end

    it 'supports_secretaries_for_select_with_all_option' do
      create(:integration_supports_organ, :secretary)

      expected = Integration::Supports::Organ.order(:descricao_orgao).map do |organ|
        ["#{organ.acronym} - #{organ.title}", organ.id]
      end

      expected.insert(0, ['Todas as secretarias', ' '])

      expect(supports_secretaries_for_select_with_all_option).to eq(expected)
    end

    it 'supports_secretaries_for_select_with_all_option_codigo_orgao_as_id' do
      create(:integration_supports_organ, :secretary)

      expected = Integration::Supports::Organ.order(:descricao_orgao).map do |organ|
        ["#{organ.acronym} - #{organ.title}", organ.codigo_orgao]
      end

      expected.insert(0, ['Todas as secretarias', ' '])

      expect(supports_secretaries_for_select_with_all_option_codigo_orgao_as_id).to eq(expected)
    end

  end

  describe 'organs_and_secretaries' do
    before do
      create(:integration_supports_organ, orgao_sfp: false)
      create(:integration_supports_organ, :secretary)
    end

    it 'supports_organs_and_secretaries_for_select' do
      expected = Integration::Supports::Organ.order(:descricao_orgao).map do |organ|
        ["#{organ.acronym} - #{organ.title}", organ.id]
      end

      expect(supports_organs_and_secretaries_for_select).to eq(expected)
    end

    it 'supports_organs_and_secretaries_for_select_with_all_option' do
      expected = Integration::Supports::Organ.order(:descricao_orgao).map do |organ|
        ["#{organ.acronym} - #{organ.title}", organ.id]
      end

      expected.insert(0, ['Todas', ' '])

      expect(supports_organs_and_secretaries_for_select_with_all_option).to eq(expected)
    end

    it 'supports_organs_and_secretaries_for_select_with_all_option_codigo_orgao_as_id' do
      expected = Integration::Supports::Organ.order(:descricao_orgao).map do |organ|
        ["#{organ.acronym} - #{organ.title}", organ.codigo_orgao]
      end

      expected.insert(0, ['Todas', ' '])

      expect(supports_organs_and_secretaries_for_select_with_all_option_codigo_orgao_as_id).to eq(expected)
    end
  end
end
