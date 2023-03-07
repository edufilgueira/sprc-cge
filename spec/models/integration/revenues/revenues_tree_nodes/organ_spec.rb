require 'rails_helper'

describe Integration::Revenues::RevenuesTreeNodes::Organ do


  describe 'initialization' do
    it 'returns empty array for empty scope' do
      nodes = Integration::Revenues::RevenuesTreeNodes::Organ.new(Integration::Revenues::Account.none)

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

    let(:revenue_nature) { create(:integration_supports_revenue_nature, codigo: '112109953')}

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

        nodes = Integration::Revenues::RevenuesTreeNodes::Organ.new(Integration::Revenues::Account.all).nodes

        node = nodes.first

        expect(node[:resource]).to eq(organ)
        expect(node[:id]).to eq(organ.id)
        expect(node[:type]).to eq(:organ)
        expect(node[:title]).to eq(organ.title)
        expect(node[:valor_previsto_inicial]).to eq(valor_previsto_inicial)
      end

      it 'returns nodes for initial_scope' do

        scope = Integration::Revenues::Account.joins({ revenue: :organ }).where('integration_supports_organs.codigo_entidade': secretary.codigo_entidade)

        previsao_inicial_revenue

        # Esperado:

        valor_previsto_inicial = (100) + (200 - 50) # 250

        nodes = Integration::Revenues::RevenuesTreeNodes::Organ.new(scope).nodes

        node = nodes.first

        expect(node[:resource]).to eq(organ)
        expect(node[:type]).to eq(:organ)
        expect(node[:title]).to eq(organ.title)
        expect(node[:valor_previsto_inicial]).to eq(valor_previsto_inicial)
      end

      it 'does not sum from others contas contabeis' do
        previsao_inicial_revenue

        another_attributes = previsao_inicial_attributes.merge({
          conta_contabil: '5.2.1.6.5.2'
        })

        another_account = create(:integration_revenues_revenue, another_attributes)

        # Esperado:

        valor_previsto_inicial = (100) + (200 - 50) # 250

        nodes = Integration::Revenues::RevenuesTreeNodes::Organ.new(Integration::Revenues::Account.all).nodes

        node = nodes.first

        expect(node[:valor_previsto_inicial]).to eq(valor_previsto_inicial)
      end

      it 'sums inverse when natureza_da_conta is DÉBITO' do
        previsao_inicial_revenue
        previsao_inicial_revenue.update_attributes(natureza_da_conta: 'DÉBITO')

        # Esperado:

        valor_previsto_inicial = (100) + (50 - 200) # -50

        nodes = Integration::Revenues::RevenuesTreeNodes::Organ.new(Integration::Revenues::Account.all).nodes

        node = nodes.first

        expect(node[:valor_previsto_inicial]).to eq(valor_previsto_inicial)
      end
    end

    describe 'valor_previsto_atualizado' do

      # Valor Atualizado = (5211 + 52121) – 52129
      # 5211 – Previsão de Receita
      # 52121 – Previsão de Receita Adicional
      # 52129 – Anulação de Previsão de Receita

      let(:previsao_receita_adicional_attributes) do
        {
          # Previsão receita adicional vem das contas '5.2.1.2.1.0.1' (Previsão de Receita Adicional)

          organ: organ,
          poder: 'EXECUTIVO',
          unidade: organ.codigo_orgao,
          conta_contabil: '5.2.1.2.1.0.1',
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

        nodes = Integration::Revenues::RevenuesTreeNodes::Organ.new(Integration::Revenues::Account.all).nodes
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

        previsao_inicial_revenue
        receita_corrente_revenue
        deducao_receita_revenue

        # Esperado:

        receita_corrente = (100) + (200 - 50) # 250
        deducoes = (50 + 100 - 25) # 125

        valor_arrecadado = (receita_corrente - deducoes)

        nodes = Integration::Revenues::RevenuesTreeNodes::Organ.new(Integration::Revenues::Account.all).nodes
        node = nodes.first

        expect(node[:valor_arrecadado]).to eq(valor_arrecadado)
      end
    end


    #
    # Permite passar um path do parent para que as contas sejam filtradas.
    # Ex: secretary/426
    # Irá retornar os nós de órgãos da árvore de receitas que forem da secretary com codigo_entidade 426.
    # Ex: secretary/426/consolidado/100000000 (da secretaria e que a natureza de receita seja 1000000)
    #
    describe 'parent_node_path' do

      let(:another_secretary) { create(:integration_supports_organ, :secretary, orgao_sfp: false) }
      let(:another_organ) { create(:integration_supports_organ, codigo_entidade: another_secretary.codigo_entidade, orgao_sfp: false) }

      let(:another_revenue_nature) { create(:integration_supports_revenue_nature, codigo: '912109953')}

      let(:another_previsao_inicial_revenue) do
        create(:integration_revenues_revenue, another_previsao_inicial_attributes)
      end

      let(:another_previsao_inicial_attributes) do
        previsao_inicial_attributes.merge({
          organ: another_organ,
          poder: 'EXECUTIVO',
          unidade: another_organ.codigo_orgao,
          accounts_attributes: [
            {
              conta_corrente: "#{another_revenue_nature.codigo}.20500",
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
              valor_inicial: 50,
              valor_credito: 50,
              valor_debito: 12.5
            }
          ]
        })
      end

      it 'returns nodes from parent' do
        previsao_inicial_revenue
        another_previsao_inicial_revenue

        # Esperado:

        valor_previsto_inicial = (75) + (100 - 25) # 150

        nodes = Integration::Revenues::RevenuesTreeNodes::Organ.new(Integration::Revenues::Account.all).nodes

        # Todos os nós.
        expect(nodes.count).to eq(2)

        # Apenas os nós de determinada secretaria.
        parent_path = "secretary/#{another_secretary.id}"
        nodes = Integration::Revenues::RevenuesTreeNodes::Organ.new(Integration::Revenues::Account.all, parent_path).nodes

        expect(nodes.count).to eq(1)

        node = nodes.first

        expect(node[:resource]).to eq(another_organ)
        expect(node[:valor_previsto_inicial]).to eq(valor_previsto_inicial)
      end

      it 'returns nodes from multiple parents' do
        previsao_inicial_revenue
        another_previsao_inicial_revenue

        # fingimos um 'unique_id_consolidado' para não ter que gerar toda
        # a árvore no teste.
        another_revenue_nature.unique_id_consolidado = '123456'
        another_revenue_nature.save

        # Esperado: somente os de determinada secretaria e que o código da natureza de
        # receita tenha o mesmo unique_id (sha256 gerado a partir do full_title)

        valor_previsto_inicial = (25) + (50 - 12.5) # 62.5

        nodes = Integration::Revenues::RevenuesTreeNodes::Organ.new(Integration::Revenues::Account.all).nodes

        # Todos os nós.
        expect(nodes.count).to eq(2)

        # Apenas os nós de determinada secretaria.
        parent_path = "secretary/#{another_secretary.id}/consolidado/#{another_revenue_nature.unique_id_consolidado}"
        nodes = Integration::Revenues::RevenuesTreeNodes::Organ.new(Integration::Revenues::Account.all, parent_path).nodes

        expect(nodes.count).to eq(1)

        node = nodes.first

        expect(node[:resource]).to eq(another_organ)
        expect(node[:valor_previsto_inicial]).to eq(valor_previsto_inicial)
      end
    end

  end
end
