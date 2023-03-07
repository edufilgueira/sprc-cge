require 'rails_helper'

describe IntegrationContractsHelper do

  describe 'integration_contracts_accountability_visible?' do
    it 'date' do
      first = create(:integration_contracts_contract, accountability_status: "Prestação de Contas Reprovada", data_assinatura: Date.today)
      second = create(:integration_contracts_contract, accountability_status: "Prestação de Contas Reprovada", data_assinatura: Date.parse('01/01/2015'))

      expect(integration_contracts_accountability_visible?(first)).to be_truthy
      expect(integration_contracts_accountability_visible?(second)).to be_falsey
    end

    it 'status' do
      first = create(:integration_contracts_contract, accountability_status: nil)
      second = create(:integration_contracts_contract, accountability_status: "Prestação de Contas Reprovada")
      third = create(:integration_contracts_contract, accountability_status: "Sem Prestação de Contas")

      expect(integration_contracts_accountability_visible?(first)).to be_falsey
      expect(integration_contracts_accountability_visible?(second)).to be_truthy
      expect(integration_contracts_accountability_visible?(third)).to be_falsey
    end
  end

  it 'integration_contracts_object_type_for_select' do
    first = create(:integration_contracts_contract, tipo_objeto: 'Cargo 1')
    second = create(:integration_contracts_contract, tipo_objeto: 'A Cargo')

    expected = [
      [second.tipo_objeto, second.tipo_objeto],
      [first.tipo_objeto, first.tipo_objeto]
    ]

    expect(integration_contracts_object_type_for_select).to eq(expected)
  end

  it 'integration_contracts_object_type_for_select_with_all_option' do
    first = create(:integration_contracts_contract, tipo_objeto: 'Cargo 1')
    second = create(:integration_contracts_contract, tipo_objeto: 'A Cargo')

    expected = [
      [second.tipo_objeto, second.tipo_objeto],
      [first.tipo_objeto, first.tipo_objeto]
    ]

    expected.insert(0, ['Todos', ' '])

    expect(integration_contracts_object_type_for_select_with_all_option).to eq(expected)
  end

  it 'integration_contracts_decricao_modalidade_for_select' do
    first = create(:integration_contracts_contract, decricao_modalidade: 'Cargo 1')
    second = create(:integration_contracts_contract, decricao_modalidade: 'A Cargo')

    expected = [
      [second.decricao_modalidade, second.decricao_modalidade],
      [first.decricao_modalidade, first.decricao_modalidade]
    ]

    expect(integration_contracts_decricao_modalidade_for_select).to eq(expected)
  end

  it 'integration_contracts_decricao_modalidade_for_select_with_all_option' do
    first = create(:integration_contracts_contract, decricao_modalidade: 'Cargo 1')
    second = create(:integration_contracts_contract, decricao_modalidade: 'A Cargo')
    third = create(:integration_contracts_contract, decricao_modalidade: nil)

    expected = [
      [second.decricao_modalidade, second.decricao_modalidade],
      [first.decricao_modalidade, first.decricao_modalidade]
    ]

    expected.insert(0, ['Todas', ' '])

    expect(integration_contracts_decricao_modalidade_for_select_with_all_option).to eq(expected)
  end

  it 'integration_contracts_status_for_select' do
    [ :waiting_additive_publication,
      :concluded,
      :concluded_with_debts
    ].each {|n| create(:integration_contracts_situation, n)}

    expected = [
      ["Todos", " "], 
      "AGUARDANDO PUBLICAÇÃO DO ADITIVO", 
      "CONCLUÍDO", 
      "CONCLUÍDO COM DÍVIDA",
    ]
    
    expect(integration_contracts_status_for_select_with_all_option).to eq(expected)
  end

  it 'integration_contracts_infringement_status_for_select' do
    expected = [
      [I18n.t('integration/contracts/contract.infringement_statuses.adimplente'), :adimplente],
      [I18n.t('integration/contracts/contract.infringement_statuses.inadimplente'), :inadimplente]
    ]

    expect(integration_contracts_infringement_status_for_select).to eq(expected)
  end

  it 'integration_contracts_infringement_status_for_select_with_all_option' do
    expected = [
      [I18n.t('integration/contracts/contract.infringement_statuses.adimplente'), :adimplente],
      [I18n.t('integration/contracts/contract.infringement_statuses.inadimplente'), :inadimplente]
    ]

    expected.insert(0, ['Todos', ' '])

    expect(integration_contracts_infringement_status_for_select_with_all_option).to eq(expected)
  end

  describe 'integration_contracts_document_url' do
    it 'url' do
      expected = 'http://sacc.cge.ce.gov.br/UploadArquivos/20171204.1031557.Plano.Trabalho.CONVENIO.DESPESA.PDF'

      filename = '20171204.1031557.Plano.Trabalho.CONVENIO.DESPESA.PDF'

      result = integration_contracts_document_url(filename)

      expect(result).to eq(expected)
    end

    it 'nil' do
      expected = nil
      filename = nil

      result = integration_contracts_document_url(filename)

      expect(result).to eq(expected)
    end

    it 'Sem Pltrb' do
      expected = nil
      filename = 'Sem Pltrb'

      result = integration_contracts_document_url(filename)

      expect(result).to eq(expected)
    end

    it 'Sem DecInexg' do
      expected = nil
      filename = 'Sem DecInexg'

      result = integration_contracts_document_url(filename)

      expect(result).to eq(expected)
    end
  end

  describe 'integration_contracts_edital_url' do
    it 'url' do
      expected = 'https://s2gpr.sefaz.ce.gov.br/licita-web/paginas/licita/Publicacao.seam?nuPublicacao=2017/20004'
      num_certidao = '2017/20004'

      result = integration_contracts_edital_url(num_certidao)

      expect(result).to eq(expected)
    end

    it 'nil' do
      expected = nil
      num_certidao = nil

      result = integration_contracts_document_url(num_certidao)

      expect(result).to eq(expected)
    end

    it 'blank' do
      expected = nil
      num_certidao = ' '

      result = integration_contracts_document_url(num_certidao)

      expect(result).to eq(expected)
    end
  end

  describe 'integration_contracts_management_attachments' do
    it 'url' do
      expected = "http://integracao.cge.ce.gov.br/sccg/paginas/frmArquivoAcompanhamento.aspx?numSIC='1005273'"
      sacc = '1005273'

      result = integration_contracts_management_attachments(sacc)

      expect(result).to eq(expected)
    end

    it 'nil' do
      expected = nil
      sacc = nil

      result = integration_contracts_management_attachments(sacc)

      expect(result).to eq(expected)
    end

    it 'blank' do
      expected = nil
      sacc = ' '

      result = integration_contracts_management_attachments(sacc)

      expect(result).to eq(expected)
    end
  end

  describe 'integration_contracts_additive_url' do
    it 'url' do
      expected = 'http://sacc.cge.ce.gov.br/UploadArquivos/20171128.992078.Integra.2%C2%BAADITIVO.pdf'
      descricao_url = '~/UploadArquivos/20171128.992078.Integra.2%C2%BAADITIVO.pdf'

      result = integration_contracts_additive_url(descricao_url)

      expect(result).to eq(expected)
    end

    it 'nil' do
      expected = nil
      descricao_url = nil

      result = integration_contracts_additive_url(descricao_url)

      expect(result).to eq(expected)
    end

    it 'blank' do
      expected = nil
      descricao_url = ' '

      result = integration_contracts_additive_url(descricao_url)

      expect(result).to eq(expected)
    end
  end

  describe 'integration_contracts_adjustment_url' do
    it 'url' do
      expected = 'http://sacc.cge.ce.gov.br/UploadArquivos/20171117.1023810.Ajuste.100503AJUSTE.PDF'
      descricao_url = '~/UploadArquivos/20171117.1023810.Ajuste.100503AJUSTE.PDF'

      result = integration_contracts_adjustment_url(descricao_url)

      expect(result).to eq(expected)
    end

    it 'nil' do
      expected = nil
      descricao_url = nil

      result = integration_contracts_adjustment_url(descricao_url)

      expect(result).to eq(expected)
    end

    it 'blank' do
      expected = nil
      descricao_url = ' '

      result = integration_contracts_adjustment_url(descricao_url)

      expect(result).to eq(expected)
    end

    it 'Sem Íntegra' do
      expected = nil
      descricao_url = 'Sem Íntegra'

      result = integration_contracts_adjustment_url(descricao_url)

      expect(result).to eq(expected)
    end
  end
end
