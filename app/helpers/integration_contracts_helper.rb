module IntegrationContractsHelper

  IGNORED_URL_VALUES = ['Sem Pltrb', 'Sem DecInexg', 'Sem Íntegra', 'Sem DecDisp']
  DOCUMENT_URL_PREFIX = 'http://sacc.cge.ce.gov.br/UploadArquivos'
  EDITAL_URL_PREFIX = 'https://s2gpr.sefaz.ce.gov.br/licita-web/paginas/licita/Publicacao.seam?nuPublicacao='
  MANAGEMENT_ATTACHMENTS_URL_PREFIX = 'http://integracao.cge.ce.gov.br/sccg/paginas/frmArquivoAcompanhamento.aspx?numSIC='

  def integration_contracts_object_type_for_select
    sorted_contract_objects.map do |contract|
      [contract.tipo_objeto, contract.tipo_objeto]
    end
  end

  def exceptions
    [:descricao_url, :edital_url, :descricao_url_ddisp, :descricao_url_inexg]
  end

  def blank_contract
    [:descricao_url, :num_contrato]
  end

  def object_option_values
    {
      :descricao_situacao => "col-12 col-sm-12",
      :descricao_nome_credor => "col-12 col-sm-6",
      :cpf_cnpj_financiador => "col-12 col-sm-3",
      :tipo_objeto => "col-12",
      :descricao_objeto => "col-12",
      :descricao_justificativa => "col-12"
    }
  end

  def date_attributes
    [
      :data_publicacao_doe, 
      :data_assinatura, 
      :data_termino_original, 
      :data_termino, 
      :data_rescisao
    ]
  end

  def date_attributes_convenants
    [
      :data_publicacao_portal,
      :data_publicacao_doe,
      :data_assinatura,
      :data_termino_original, 
      :data_termino, 
      :data_rescisao
    ]
  end

  def contract_values_attributes
    [:valor_contrato, :calculated_valor_aditivo, :valor_ajuste, :valor_can_rstpg, :valor_atualizado_concedente, :calculated_valor_empenhado, :calculated_valor_pago]
  end

  def integration_contracts_object_type_for_select_with_all_option
    integration_contracts_object_type_for_select.insert(0, [t('messages.filters.select.all.male'), ' '])
  end

  def integration_contracts_decricao_modalidade_for_select
    contract_decricao_modalidades.pluck(:decricao_modalidade).compact.sort.map { |m| [m, m] }
  end

  def integration_contracts_decricao_modalidade_for_select_with_all_option
    integration_contracts_decricao_modalidade_for_select.insert(0, [t('messages.filters.select.all.female'), ' '])
  end

  # def integration_contracts_status_for_select
  #   [
  #     [I18n.t('integration/contracts/contract.statuses.concluido'), :concluido],
  #     [I18n.t('integration/contracts/contract.statuses.vigente'), :vigente]
  #   ]
  # end

  def integration_contracts_status_for_select_with_all_option
    return [] unless Integration::Contracts::Situation.any?
    Integration::Contracts::Situation
      .order(:description)
      .pluck(:description)
      .insert(0, [t('messages.filters.select.all.male'), ' '])
  end

  def integration_contracts_infringement_status_for_select
    [
      [I18n.t('integration/contracts/contract.infringement_statuses.adimplente'), :adimplente],
      [I18n.t('integration/contracts/contract.infringement_statuses.inadimplente'), :inadimplente]
    ]
  end

  def integration_contracts_infringement_status_for_select_with_all_option
    integration_contracts_infringement_status_for_select.insert(0, [t('messages.filters.select.all.male'), ' '])
  end

  def integration_contracts_document_url(filename)
    contract_document_url(filename)
  end

  def integration_contracts_work_plan(filename, isn_sic, cod_plano_trabalho)
    url = contract_document_url(filename) # url sacc
    (url.nil? and cod_plano_trabalho.present?) ? url_work_plan_from_eparcerias(isn_sic) : url
  end

  def url_work_plan_from_eparcerias(isn_sic)
    "https://e-parcerias.cge.ce.gov.br/scc-ws-web/paginas/home/visualizaAnexoPT.seam?numeroConvenio=#{isn_sic}"
  end

  def integration_contracts_edital_url(num_certidao)
    return nil if num_certidao.blank?

    "#{EDITAL_URL_PREFIX}#{num_certidao}"
  end

  def integration_contracts_management_attachments(sacc)
    return nil if sacc.blank?

    "#{MANAGEMENT_ATTACHMENTS_URL_PREFIX}'#{sacc}'"
  end

  def integration_contracts_additive_url(descricao_url)
    # Ex: ~/UploadArquivos/20171128.992078.Integra.2%C2%BAADITIVO.pdf

    contract_document_url(descricao_url)
  end

  def integration_contracts_adjustment_url(descricao_url)
    # Ex: ~/UploadArquivos/20171117.1023810.Ajuste.100503AJUSTE.PDF

    contract_document_url(descricao_url)
  end

  def integration_contracts_accountability_visible?(contract)
    return false if contract.accountability_status.blank? || contract.accountability_status == "Sem Prestação de Contas"

    range = Date.parse('01/11/2014')..Date.parse('31/08/2015')

    ! range.include?(contract.data_assinatura.to_date)
  end

  private

  def sorted_contract_objects
    filtered_objects.order(:tipo_objeto)
  end

  def filtered_objects
    contract_objects.where.not(tipo_objeto: [nil, ''])
  end

  def contract_objects
    Integration::Contracts::Contract.select(:tipo_objeto).distinct
  end

  def contract_decricao_modalidades
    Integration::Contracts::Contract.select(:decricao_modalidade).distinct
  end

  def contract_document_url(value)
    return nil if value.blank? || value.in?(IGNORED_URL_VALUES)
    plain_value = value.gsub(/^~\/UploadArquivos\//, '')

    "#{DOCUMENT_URL_PREFIX}/#{plain_value}"
  end
end
