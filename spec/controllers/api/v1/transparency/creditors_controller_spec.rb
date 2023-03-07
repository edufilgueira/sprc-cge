require 'rails_helper'

describe Api::V1::Transparency::CreditorsController do
  include ResponseSpecHelper

  describe '#search' do

    let!(:creditor) { create(:integration_supports_creditor) }
    let!(:creditor_named) { create(:integration_supports_creditor, nome: 'Caiêna com Acento') }

    it 'by name with accent' do
      get(:search, params: { nome: 'caíE' })

      expect(json.length).to eq(1)
      expect(json[0]['nome']).to eq creditor_named.nome
    end

    it 'not_exist' do
      get(:search, params: { nome: 'not exist' })

      expect(json).to eq([])
    end

    it 'without params_creditor_name' do
      get(:search)

      expect(json).to eq([])
    end

    it 'filters by specific table' do
      # Algumas consultas possuem uma coluna explítica para credores, como
      # contracts.descricao_nome_credor. Esse comportamento está no método de
      # classe 'creditors_name_column'.
      #
      # Portanto, essa API deve procurar no DISTINCT dessa coluna, sendo que o
      # padrão é integration_supports_creditors.nome

      # integration_contracts_contracts.descricao_nome_credor
      column = Integration::Contracts::Contract.creditors_name_column


      contract = create(:integration_contracts_contract, descricao_nome_credor: 'ABCDEFGH')
      another_contract = create(:integration_contracts_contract, descricao_nome_credor: 'ABCDEFGH')

      get(:search, params: { nome: 'def', group: :contracts })

      expect(json.length).to eq(1)
      expect(json[0]['nome']).to eq contract.descricao_nome_credor
    end
  end
end
