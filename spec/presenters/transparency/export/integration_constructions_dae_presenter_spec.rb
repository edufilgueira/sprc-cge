require 'rails_helper'

describe Transparency::Export::IntegrationConstructionsDaePresenter do
  subject(:dae_spreadsheet_presenter) do
    Transparency::Export::IntegrationConstructionsDaePresenter.new(dae)
  end

  let(:dae) { create(:integration_constructions_dae) }

  let(:klass) { Integration::Constructions::Dae }

  it 'spreadsheet_header' do
    expected = [
      klass.human_attribute_name(:id_obra),
      klass.human_attribute_name(:codigo_obra),
      klass.human_attribute_name(:contratada),
      klass.human_attribute_name(:data_fim_previsto),
      klass.human_attribute_name(:data_inicio),
      klass.human_attribute_name(:data_ordem_servico),
      klass.human_attribute_name(:descricao),
      klass.human_attribute_name(:dias_aditivado),
      klass.human_attribute_name(:latitude),
      klass.human_attribute_name(:longitude),
      klass.human_attribute_name(:municipio),
      klass.human_attribute_name(:numero_licitacao),
      klass.human_attribute_name(:numero_ordem_servico),
      klass.human_attribute_name(:numero_sacc),
      klass.human_attribute_name(:percentual_executado),
      klass.human_attribute_name(:prazo_inicial),
      klass.human_attribute_name(:secretaria),
      klass.human_attribute_name(:status),
      klass.human_attribute_name(:tipo_contrato),
      klass.human_attribute_name(:valor)
    ]

    expect(Transparency::Export::IntegrationConstructionsDaePresenter.spreadsheet_header).to eq(expected)
  end

  it 'spreadsheet_row' do
    expected = [
      dae.id_obra,
      dae.codigo_obra,
      dae.contratada,
      dae.data_fim_previsto,
      dae.data_inicio,
      dae.data_ordem_servico,
      dae.descricao,
      dae.dias_aditivado,
      dae.latitude,
      dae.longitude,
      dae.municipio,
      dae.numero_licitacao,
      dae.numero_ordem_servico,
      dae.numero_sacc,
      dae.percentual_executado,
      dae.prazo_inicial,
      dae.secretaria,
      dae.status,
      dae.tipo_contrato,
      dae.valor
    ]

    result = dae_spreadsheet_presenter.spreadsheet_row

    expect(result).to eq(expected)
  end
end
