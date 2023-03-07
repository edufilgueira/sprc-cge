require 'rails_helper'

describe Integration::Supports::Creditor::Search do

  it 'codigo' do
    creditor = create(:integration_supports_creditor, codigo: '123')
    another_creditor = create(:integration_supports_creditor, codigo: '321')
    another_creditor
    creditors = Integration::Supports::Creditor.search('123')
    expect(creditors).to eq([creditor])
  end

  it 'nome' do
    creditor = create(:integration_supports_creditor, nome: 'MARIA TEREZA B DE MENEZES FONTENELE')
    another_creditor = create(:integration_supports_creditor, nome: 'PREFEITURA MUNICIPAL DE ANTONINA DO NORTE')
    another_creditor
    creditors = Integration::Supports::Creditor.search('Mar')
    expect(creditors).to eq([creditor])
  end

  it 'cpf_cnpj' do
    creditor = create(:integration_supports_creditor, cpf_cnpj: '123.456.789-21')
    another_creditor = create(:integration_supports_creditor, cpf_cnpj: '987.654.321-98')
    another_creditor
    creditors = Integration::Supports::Creditor.search('456')
    expect(creditors).to eq([creditor])
  end

  it 'email' do
    creditor = create(:integration_supports_creditor, email: 'maria@example.com')
    another_creditor = create(:integration_supports_creditor, email: 'prefeitura@example.com')
    another_creditor
    creditors = Integration::Supports::Creditor.search('ria')
    expect(creditors).to eq([creditor])
  end

  it 'telefone_contato' do
    creditor = create(:integration_supports_creditor, telefone_contato: '19 9 9999-9999')
    another_creditor = create(:integration_supports_creditor, telefone_contato: '11 9 1111-1111')
    another_creditor
    creditors = Integration::Supports::Creditor.search('99')
    expect(creditors).to eq([creditor])
  end

end

