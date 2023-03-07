require 'rails_helper'

describe Integration::Revenues::RevenuesTreeNodes::Subfonte do


  describe 'initialization' do
    it 'returns empty array for empty scope' do
      nodes = Integration::Revenues::RevenuesTreeNodes::Subfonte.new(Integration::Revenues::Account.none)

      expect(nodes.nodes).to eq([])
    end
  end

  describe 'calculations' do

    # Regras documentadas:
    #
    # natureza_conta = 'DÉBITO    ' e codigo = '9' faça (valor_credito - valor_debito) * -1
    # natureza_conta = 'DÉBITO    ' e codigo = '8' faça (valor_credito - valor_debito) * -1
    # natureza_conta = 'DÉBITO    ' e codigo = '1' faça  valor_debito - valor_credito
    # natureza_conta = 'CRÉDITO   ' e codigo = '9' faça (valor_debito - valor_credito) * -1
    # natureza_conta = 'CRÉDITO   ' e codigo = '8' faça (valor_debito - valor_credito) * -1
    # natureza_conta = 'CRÉDITO   ' e codigo = '1' faça valor_credito - valor_debito
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


    let(:secretary) { create(:integration_supports_organ, :secretary, orgao_sfp: false) }
    let(:organ) { create(:integration_supports_organ, codigo_entidade: secretary.codigo_entidade, orgao_sfp: false) }

    let(:previsao_inicial_revenue) do
      create(:integration_revenues_revenue, previsao_inicial_attributes)
    end

    let(:first_revenue_nature_subalinea) { create(:integration_supports_revenue_nature, codigo: '112109953')}
    let(:first_revenue_nature_subfonte) { create(:integration_supports_revenue_nature, codigo: '112100000')}

    let(:second_revenue_nature_subalinea) { create(:integration_supports_revenue_nature, codigo: '813250199')}
    let(:second_revenue_nature_subfonte) { create(:integration_supports_revenue_nature, codigo: '813200000')}

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
        natureza_da_conta: 'CRÉDITO',
        valor_inicial: 100,
        valor_credito: 200,
        valor_debito: 50,
        month: 1,
        year: 2018,

        accounts_attributes: [
          {
            conta_corrente: "#{first_revenue_nature_subalinea.codigo}.20500",
            natureza_debito: 'CRÉDITO',
            natureza_credito: 'DÉBITO',
            mes: 1,
            valor_inicial: 50,
            valor_credito: 100,
            valor_debito: 25
          },

          {
            conta_corrente: "#{second_revenue_nature_subalinea.codigo}.27000",
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

        first_revenue_nature_subfonte
        second_revenue_nature_subfonte

        previsao_inicial_revenue

        # Esperado:

        first_valor_previsto_inicial = (50) + (100 - 25) # 125
        second_valor_previsto_inicial = (50) + (100 - 25) # 125

        nodes = Integration::Revenues::RevenuesTreeNodes::Subfonte.new(Integration::Revenues::Account.all).nodes

        expect(nodes.count).to eq(2)

        first_node = nodes.first

        expect(first_node[:type]).to eq(:subfonte)
        expect(first_node[:title]).to eq(first_revenue_nature_subfonte.title)
        expect(first_node[:valor_previsto_inicial]).to eq(first_valor_previsto_inicial)

        second_node = nodes.second

        expect(second_node[:type]).to eq(:subfonte)
        expect(second_node[:title]).to eq(second_revenue_nature_subfonte.title)
        expect(second_node[:valor_previsto_inicial]).to eq(second_valor_previsto_inicial)
      end
    end
  end
end
