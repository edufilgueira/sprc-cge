require 'rails_helper'

describe Integration::Revenues::RevenuesTreeNodes::Secretary do


  describe 'initialization' do
    it 'returns empty array for empty scope' do
      nodes = Integration::Revenues::RevenuesTreeNodes::Secretary.new(Integration::Revenues::Account.none)

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
    # 5211 – Previsão de Receita
    # 52121 – Previsão de Receita Adicional
    # 52129 – Anulação de Previsão de Receita
    # 6212 – Receita Corrente
    # 6213 – Deduções da Receita
    #
    # Valor Previsto = 5211
    # Valor Atualizado = (5211 + 52121) – 52129
    # Valor Arrecadado = 6212 - 6213
    #
    #
    # Integration::Revenues::Revenue possui relação com órgão/secretaria, além
    # de possuir os códigos.
    #
    # A soma deve ser feita no model Integration::Revenues::Account, que possui
    # a classificação da natureza da receita.
    #

    let(:secretary) { create(:integration_supports_organ, :secretary, orgao_sfp: false) }
    let(:organ) { create(:integration_supports_organ, codigo_entidade: secretary.codigo_entidade, orgao_sfp: false) }

    let(:another_secretary) { create(:integration_supports_organ, :secretary) }
    let(:another_organ) { create(:integration_supports_organ, codigo_entidade: another_secretary.codigo_entidade, orgao_sfp: false) }

    let(:previsao_inicial_revenue) do
      create(:integration_revenues_revenue, previsao_inicial_attributes)
    end

    let(:other_previsao_inicial_revenue) do
      create(:integration_revenues_revenue, other_previsao_inicial_attributes)
    end

    let(:revenue_nature) { create(:integration_supports_revenue_nature, codigo: '112109953')}

    let(:other_previsao_inicial_attributes) do
      {
        # Valor previsto inicial vem das contas '5.2.1.1' (Previsão inicial)
        # e é calculada da seguinte forma:
        #
        # (valor_inicial + (valor_credito - valor_debito))

        organ: organ,
        poder: 'EXECUTIVO',
        unidade: organ.codigo_orgao,
        conta_contabil: '5.2.1.1', # Previsão inicial
        titulo: 'Previsão inicial',
        natureza_da_conta: 'CRÉDITO',
        valor_inicial: 100,
        valor_credito: 200,
        valor_debito: 50,
        month: 1,
        year: 2018,

        accounts_attributes: [
          {
            conta_corrente: "#{revenue_nature.codigo}.20500",
            natureza_debito: 'CRÉDITO',
            natureza_credito: 'DÉBITO',
            mes: 1,
            valor_inicial: 50,
            valor_credito: 100,
            valor_debito: 25
          },

          {
            conta_corrente: "#{revenue_nature.codigo}.27000",
            natureza_debito: 'CRÉDITO',
            natureza_credito: 'DÉBITO',
            mes: 1,
            valor_inicial: 50,
            valor_credito: 100,
            valor_debito: 25
          }
        ]
      }
    end

    let(:previsao_inicial_attributes) do
      {
        # Valor previsto inicial vem das contas '5.2.1.1.1' (Previsão inicial)
        # e é calculada da seguinte forma:
        #
        # (valor_inicial + (valor_credito - valor_debito))

        organ: organ,
        poder: 'EXECUTIVO',
        unidade: organ.codigo_orgao,
        conta_contabil: '5.2.1.1.1', # Previsão inicial
        titulo: 'Previsão inicial',
        natureza_da_conta: 'CRÉDITO',
        valor_inicial: 100,
        valor_credito: 200,
        valor_debito: 50,
        month: 1,
        year: 2018,

        accounts_attributes: [
          {
            conta_corrente: "#{revenue_nature.codigo}.20500",
            natureza_debito: 'CRÉDITO',
            natureza_credito: 'DÉBITO',
            mes: 1,
            valor_inicial: 50,
            valor_credito: 100,
            valor_debito: 25
          },

          {
            conta_corrente: "#{revenue_nature.codigo}.27000",
            natureza_debito: 'CRÉDITO',
            natureza_credito: 'DÉBITO',
            mes: 1,
            valor_inicial: 50,
            valor_credito: 100,
            valor_debito: 25
          }
        ]
      }
    end

    describe 'valor_previsto_inicial' do
      it 'returns nodes' do

        previsao_inicial_revenue

        # Esperado:

        valor_previsto_inicial = (100) + (200 - 50) # 250

        nodes = Integration::Revenues::RevenuesTreeNodes::Secretary.new(Integration::Revenues::Account.all).nodes

        node = nodes.first

        expect(node[:resource]).to eq(secretary)
        expect(node[:id]).to eq(secretary.id)
        expect(node[:type]).to eq(:secretary)
        expect(node[:title]).to eq(secretary.title)
        expect(node[:valor_previsto_inicial]).to eq(valor_previsto_inicial)
      end

      it 'returns nodes with more than one revenues' do

        previsao_inicial_revenue
        other_previsao_inicial_revenue

        # Esperado:

        valor_previsto_inicial = ((100) + (200 - 50)) * 2 # 500

        nodes = Integration::Revenues::RevenuesTreeNodes::Secretary.new(Integration::Revenues::Account.all).nodes

        node = nodes.first

        expect(node[:resource]).to eq(secretary)
        expect(node[:id]).to eq(secretary.id)
        expect(node[:type]).to eq(:secretary)
        expect(node[:title]).to eq(secretary.title)
        expect(node[:valor_previsto_inicial]).to eq(valor_previsto_inicial)
      end

      it 'does not sum from others contas contabeis' do
        previsao_inicial_revenue

        another_attributes = previsao_inicial_attributes.merge({
          conta_contabil: '5.2.1.6.5.2'
        })

        another_revenue = create(:integration_revenues_revenue, another_attributes)

        # Esperado:

        valor_previsto_inicial = (100) + (200 - 50) # 250

        nodes = Integration::Revenues::RevenuesTreeNodes::Secretary.new(Integration::Revenues::Account.all).nodes

        node = nodes.first

        expect(node[:valor_previsto_inicial]).to eq(valor_previsto_inicial)
      end

      it 'sums inverse when natureza_da_conta is DÉBITO' do
        previsao_inicial_revenue
        previsao_inicial_revenue.update_attributes(natureza_da_conta: 'DÉBITO')

        # Esperado:

        valor_previsto_inicial = (100) + (50 - 200) # -50

        nodes = Integration::Revenues::RevenuesTreeNodes::Secretary.new(Integration::Revenues::Account.all).nodes

        node = nodes.first

        expect(node[:valor_previsto_inicial]).to eq(valor_previsto_inicial)
      end

      it 'sums for more than one secretary' do
        previsao_inicial_revenue

        another_revenue_attributes = previsao_inicial_attributes.merge({
          organ: another_organ,
          unidade: another_organ.codigo_orgao
        })

        another_revenue = create(:integration_revenues_revenue, another_revenue_attributes)

        nodes = Integration::Revenues::RevenuesTreeNodes::Secretary.new(Integration::Revenues::Account.all).nodes

        expect(nodes.count).to eq(2)

        node = nodes.last

        expect(node[:title]).to eq(another_secretary.title)
      end
    end

    describe 'valor_previsto_atualizado' do

      # Valor Atualizado = (5211 + 52121) – 52129
      # 5211 – Previsão de Receita
      # 52121 – Previsão de Receita Adicional
      # 52129 – Anulação de Previsão de Receita

      let(:previsao_receita_adicional_attributes) do
        {
          # Previsão receita adicional vem das contas '5.2.1.2.1.0.2' (Previsão de Receita Adicional)

          organ: organ,
          poder: 'EXECUTIVO',
          unidade: organ.codigo_orgao,
          conta_contabil: '5.2.1.2.1.0.2',
          natureza_da_conta: 'CRÉDITO',
          valor_inicial: 100,
          valor_credito: 200,
          valor_debito: 50,
          month: 1,
          year: 2018,

          accounts_attributes: [
            {
              conta_corrente: "#{revenue_nature.codigo}.20500",
              natureza_debito: 'CRÉDITO',
              natureza_credito: 'DÉBITO',
              mes: 1,
              valor_inicial: 50,
              valor_credito: 100,
              valor_debito: 25
            },

            {
              conta_corrente: "#{revenue_nature.codigo}.27000",
              natureza_debito: 'CRÉDITO',
              natureza_credito: 'DÉBITO',
              mes: 1,
              valor_inicial: 50,
              valor_credito: 100,
              valor_debito: 25
            }
          ]
        }
      end

      let(:anulacao_previsao_receita_attributes) do
        {
          # Anulação da receita adicional vem das contas '5.2.1.2.9' (Anulação de Previsão de Receita)

          organ: organ,
          poder: 'EXECUTIVO',
          unidade: organ.codigo_orgao,
          conta_contabil: '5.2.1.2.9',
          natureza_da_conta: 'CRÉDITO',
          valor_inicial: 50,
          valor_credito: 100,
          valor_debito: 25,
          month: 1,
          year: 2018,

          accounts_attributes: [
            {
              conta_corrente: "#{revenue_nature.codigo}.20500",
              natureza_debito: 'CRÉDITO',
              natureza_credito: 'DÉBITO',
              mes: 1,
              valor_inicial: 25,
              valor_credito: 50,
              valor_debito: 12.5
            },

            {
              conta_corrente: "#{revenue_nature.codigo}.27000",
              natureza_debito: 'CRÉDITO',
              natureza_credito: 'DÉBITO',
              mes: 1,
              valor_inicial: 25,
              valor_credito: 50,
              valor_debito: 12.5
            }
          ]
        }
      end

      let(:previsao_receita_adicional_revenue) do
        create(:integration_revenues_revenue, previsao_receita_adicional_attributes)
      end

      let(:anulacao_previsao_receita_revenue) do
        create(:integration_revenues_revenue, anulacao_previsao_receita_attributes)
      end

      it 'returns nodes' do

        previsao_inicial_revenue
        previsao_receita_adicional_revenue
        anulacao_previsao_receita_revenue

        # Esperado:

        valor_previsto_inicial = (100) + (200 - 50) # 250
        valor_previsto_adicional = (100 + 200 - 50) # 250
        valor_previsto_anulado = (50 + 100 - 25) # 125

        valor_previsto_atualizado = (valor_previsto_inicial + valor_previsto_adicional - valor_previsto_anulado)

        nodes = Integration::Revenues::RevenuesTreeNodes::Secretary.new(Integration::Revenues::Account.all).nodes
        node = nodes.first

        expect(node[:valor_previsto_atualizado]).to eq(valor_previsto_atualizado)
      end
    end

    describe 'valor_arrecadado' do

      # Valor Arrecadado = 6212 - 6213
      # 6212 – Receita Corrente
      # 6213 – Deduções da Receita

      let(:receita_corrente_attributes) do
        {
          # Receita corrente vem das contas '6.2.1.2' (Receita Corrente)

          organ: organ,
          poder: 'EXECUTIVO',
          unidade: organ.codigo_orgao,
          conta_contabil: '6.2.1.2',
          natureza_da_conta: 'CRÉDITO',
          valor_inicial: 100,
          valor_credito: 200,
          valor_debito: 50,
          month: 1,
          year: 2018,

          accounts_attributes: [
            {
              conta_corrente: "#{revenue_nature.codigo}.20500",
              natureza_debito: 'CRÉDITO',
              natureza_credito: 'DÉBITO',
              mes: 1,
              valor_inicial: 50,
              valor_credito: 100,
              valor_debito: 25
            },

            {
              conta_corrente: "#{revenue_nature.codigo}.27000",
              natureza_debito: 'CRÉDITO',
              natureza_credito: 'DÉBITO',
              mes: 1,
              valor_inicial: 50,
              valor_credito: 100,
              valor_debito: 25
            }
          ]
        }
      end

      let(:deducao_receita_attributes) do
        {
          # Deduções da Receita vem das contas '6.2.1.3' (Deduções da Receita)

          organ: organ,
          poder: 'EXECUTIVO',
          unidade: organ.codigo_orgao,
          conta_contabil: '6.2.1.3',
          natureza_da_conta: 'CRÉDITO',
          valor_inicial: 50,
          valor_credito: 100,
          valor_debito: 25,
          month: 1,
          year: 2018,

          accounts_attributes: [
            {
              conta_corrente: "#{revenue_nature.codigo}.20500",
              natureza_debito: 'CRÉDITO',
              natureza_credito: 'DÉBITO',
              mes: 1,
              valor_inicial: 25,
              valor_credito: 50,
              valor_debito: 12.5
            },

            {
              conta_corrente: "#{revenue_nature.codigo}.27000",
              natureza_debito: 'CRÉDITO',
              natureza_credito: 'DÉBITO',
              mes: 1,
              valor_inicial: 25,
              valor_credito: 50,
              valor_debito: 12.5
            }
          ]
        }
      end

      let(:receita_corrente_revenue) do
        create(:integration_revenues_revenue, receita_corrente_attributes)
      end

      let(:deducao_receita_revenue) do
        create(:integration_revenues_revenue, deducao_receita_attributes)
      end

      it 'returns nodes' do
        receita_corrente_revenue
        deducao_receita_revenue

        # Esperado:

        receita_corrente = (100) + (200 - 50) # 250
        deducoes = (50 + 100 - 25) # 125

        valor_arrecadado = (receita_corrente - deducoes)

        nodes = Integration::Revenues::RevenuesTreeNodes::Secretary.new(Integration::Revenues::Account.all).nodes
        node = nodes.first

        expect(node[:valor_arrecadado]).to eq(valor_arrecadado)
      end
    end
  end
end
