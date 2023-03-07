require 'rails_helper'

describe Integration::Revenues::RegisteredRevenuesTreeNodes::Revenue do

  describe 'initialization' do
    it 'returns empty array for empty scope' do
      nodes = Integration::Revenues::RegisteredRevenuesTreeNodes::Revenue.new(Integration::Revenues::Revenue.none)

      expect(nodes.nodes).to eq([])
    end
  end

  describe 'calculations' do

    # Regras documentadas:
    #
    # natureza_conta = 'DÉBITO    ' e codigo = '9' faça (valor_debito - valor_credito)
    # natureza_conta = 'DÉBITO    ' e codigo = '8' faça (valor_debito - valor_credito)
    # natureza_conta = 'DÉBITO    ' e codigo = '1' faça (valor_debito - valor_credito)

    # natureza_conta = 'CRÉDITO   ' e codigo = '9' faça (valor_credito - valor_debito)
    # natureza_conta = 'CRÉDITO   ' e codigo = '8' faça (valor_credito - valor_debito)
    # natureza_conta = 'CRÉDITO   ' e codigo = '1' faça (valor_credito - valor_debito)
    #
    # - 4.1.1.2.1.03.01 IPVA
    # - 4.1.1.2.1.97.01 (-) Restituições da Receita com IPVA
    # - 4.1.1.2.1.97.11 (-) Deduções do IPVA para o FUNDEB
    #
    # Valor lançado = IPVA - Restituições da Receita com IPVA -  Deduções do IPVA para o FUNDEB
    # Valor Atualizado = (5211 + 52121) – 52129
    # Valor Arrecadado = 6212 - 6213
    #

    let(:year) { 2018 }

    let(:another_year) { 2019 }

    let(:ipva_revenue) do
      create(:integration_revenues_revenue, ipva_attributes)
    end

    let(:another_month_ipva_revenue) do
      create(:integration_revenues_revenue, another_month_ipva_attributes)
    end

    let(:another_year_ipva_revenue) do
      create(:integration_revenues_revenue, another_year_ipva_attributes)
    end

    let(:restituicoes_ipva_revenue) do
      create(:integration_revenues_revenue, restituicoes_ipva_attributes)
    end

    let(:deducoes_ipva_revenue) do
      create(:integration_revenues_revenue, deducoes_ipva_attributes)
    end

    let(:ipva_attributes) do
      {
        conta_contabil: '4.1.1.2.1.03.01', # IPVA
        natureza_da_conta: 'CRÉDITO',
        titulo: 'IPVA',
        valor_inicial: 100,
        valor_credito: 200,
        valor_debito: 50,
        month: 1,
        year: year
      }
    end

    let(:another_month_ipva_attributes) do
      ipva_attributes.merge({
        month: 2,
        year: year
      })
    end

    let(:another_year_ipva_attributes) do
      ipva_attributes.merge({
        month: 1,
        year: another_year
      })
    end

    let(:restituicoes_ipva_attributes) do
      {
        conta_contabil: '4.1.1.2.1.97.01',
        titulo: 'Restituições da Receita com IPVA',
        natureza_da_conta: 'DÉBITO',
        valor_inicial: 10,
        valor_credito: 20,
        valor_debito: 30,
        month: 1,
        year: year
      }
    end

    let(:deducoes_ipva_attributes) do
      {
        conta_contabil: '4.1.1.2.1.97.11',
        titulo: 'Deduções do IPVA para o FUNDEB',
        natureza_da_conta: 'DÉBITO',
        valor_inicial: 5,
        valor_credito: 10,
        valor_debito: 15,
        month: 1,
        year: year
      }
    end

    it 'returns nodes' do
      # OBS: não filtramos por ano pois o initial_scope já vem do controller
      # com esse filtro.

      month = 1
      ipva_revenue
      restituicoes_ipva_revenue
      deducoes_ipva_revenue

      another_month = 2
      another_month_ipva_revenue

      another_year_ipva_revenue

      # Esperado:

      valor_ipva = (100) + (200 - 50) # 250
      valor_restituicoes = (10) + (30 - 20) # 20
      valor_deducoes = (5) + (15 - 10) # 10

      valor_lancado = (valor_ipva - valor_restituicoes - valor_deducoes)

      initial_scope = Integration::Revenues::Revenue.where(year: year)

      parent_path = "month/1"
      nodes = Integration::Revenues::RegisteredRevenuesTreeNodes::Revenue.new(initial_scope, parent_path).nodes

      expect(nodes.length).to eq(3)

      first_node = nodes.first

      expect(first_node[:resource]).to eq(ipva_revenue.conta_contabil)
      expect(first_node[:id]).to eq(ipva_revenue.conta_contabil)
      expect(first_node[:type]).to eq(:revenue)
      expect(first_node[:title]).to eq(ipva_revenue.titulo)
      expect(first_node[:valor_lancado]).to eq(valor_ipva)

      second_node = nodes.second

      expect(second_node[:resource]).to eq(restituicoes_ipva_revenue.conta_contabil)
      expect(second_node[:id]).to eq(restituicoes_ipva_revenue.conta_contabil)
      expect(second_node[:type]).to eq(:revenue)
      expect(second_node[:title]).to eq(restituicoes_ipva_revenue.titulo)
      expect(second_node[:valor_lancado]).to eq(-1 * valor_restituicoes)

      third_node = nodes.third

      expect(third_node[:resource]).to eq(deducoes_ipva_revenue.conta_contabil)
      expect(third_node[:id]).to eq(deducoes_ipva_revenue.conta_contabil)
      expect(third_node[:type]).to eq(:revenue)
      expect(third_node[:title]).to eq(deducoes_ipva_revenue.titulo)
      expect(third_node[:valor_lancado]).to eq(-1 * valor_deducoes)
    end
  end
end
