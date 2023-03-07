class Integration::Contracts::Contract < Integration::BaseDataChange
  include ::Integration::Contracts::Contract::Search
  include ::Sortable

  # Constants

  NOTIFICABLE_CHANGED_ATTRIBUTES = [
    :descricao_situacao,
    :data_termino,
    # :status           - não é atributo do banco para controlar a edição (controlamos no service)

    # Notas de Empenho  - callback em Integration::Contracts::Financial
    # Nota de Pagamento - callback em Integration::Contracts::Financial
    # Aditivo           - callback em Integration::Contracts::Additive
    # Ajuste            - callback em Integration::Contracts::Adjustment
  ]

  KIND = { contrato: [51, 52, 54], convenio: [49, 53] }

  # Enums

  enum contract_type: [:contrato, :convenio, :unknown]

  enum infringement_status: [:adimplente, :inadimplente]

  # Associations

  belongs_to :manager,
    -> { where('integration_supports_organs.orgao_sfp = ? AND integration_supports_organs.data_termino IS NULL', false) },
    foreign_key: :cod_gestora,
    primary_key: :codigo_orgao,
    class_name: 'Integration::Supports::Organ'

  belongs_to :grantor,
    foreign_key: :cod_concedente,
    primary_key: :codigo,
    class_name: 'Integration::Supports::ManagementUnit'

  # O código na tablela de credores tem o prefixo '00'.
  # Já a tabela de contratos não possui esse prefixo.
  # Gravamos o 00 em cod_financiador_including_zeroes
  # Precisamos confirmar se esta lógica ocorre em todos os casos.
  belongs_to :creditor,
    foreign_key: :plain_cpf_cnpj_financiador,
    primary_key: :cpf_cnpj,
    class_name: 'Integration::Supports::Creditor'

  has_many :additives,
    foreign_key: 'isn_sic',
    primary_key: 'isn_sic',
    dependent: :delete_all

  has_many :adjustments,
    foreign_key: 'isn_sic',
    primary_key: 'isn_sic',
    dependent: :delete_all

  has_many :financials,
    foreign_key: 'isn_sic',
    primary_key: 'isn_sic',
    dependent: :delete_all

  has_many :infringements,
    foreign_key: 'isn_sic',
    primary_key: 'isn_sic',
    dependent: :delete_all

  has_many :transfer_bank_orders,
    foreign_key: 'isn_sic',
    primary_key: 'isn_sic',
    class_name: 'Integration::Eparcerias::TransferBankOrder',
    dependent: :delete_all

  has_many :work_plan_attachments,
    foreign_key: 'isn_sic',
    primary_key: 'isn_sic',
    class_name: 'Integration::Eparcerias::WorkPlanAttachment',
    dependent: :delete_all

  # Delegations

  delegate :title, :acronym, to: :manager, prefix: true, allow_nil: true
  delegate :title, :sigla, to: :grantor, prefix: true, allow_nil: true
  delegate :title, to: :creditor, prefix: true, allow_nil: true


  # Callbacks

  after_validation :set_plain_num_contrato,
    :set_plain_cpf_cnpj_financiador,
    :set_cod_financiador_including_zeroes,
    :set_contract_type

  # Validations

  ## Presence

  validates :data_assinatura,
    :data_processamento,
    :data_termino,
    :flg_tipo,
    :isn_parte_destino,
    :isn_sic,
    :valor_contrato,
    :isn_modalidade,
    presence: true

  validates :isn_entidade,
    :valor_can_rstpg,
    :data_publicacao_portal,
    :valor_original_concedente,
    :valor_original_contrapartida,
    :valor_atualizado_concedente,
    :valor_atualizado_contrapartida,
    presence: true


  # Public

  ## Class methods

  ### Scopes

  def self.default_scope
    from_type(:contrato)
  end

  def self.default_sort_column
    'integration_contracts_contracts.data_assinatura'
  end

  def self.default_sort_direction
    :desc
  end

  def self.from_type(contract_type)
    where(contract_type: contract_type)
  end

  def self.concluido
    where('integration_contracts_contracts.data_termino <= ?', Date.today)
  end

  def self.vigente
    where('integration_contracts_contracts.data_termino >= ?', Date.today.beginning_of_month)
  end

  def self.data_assinatura_in_range(start_date, end_date)
    where(data_assinatura: (start_date.beginning_of_day..end_date.end_of_day))
  end

  def self.data_vigencia_in_range(start_date, end_date)
    active_on_month_without_termination(start_date, end_date)
  end

  def self.data_termino_original_in_range(start_date, end_date)
    where(data_termino_original: (start_date.beginning_of_day..end_date.end_of_day))
  end

  def self.data_rescisao_in_range(start_date, end_date)
    where(data_rescisao: (start_date.beginning_of_day..end_date.end_of_day))
  end

  def self.active_on_month_without_termination(beginning_of_month, end_of_month)
    where("DATE(integration_contracts_contracts.data_assinatura) <= :end_of_month 
          AND DATE(integration_contracts_contracts.data_termino) >= :beginning_of_month
          AND ( integration_contracts_contracts.data_rescisao IS NULL
                OR integration_contracts_contracts.data_rescisao >= :beginning_of_month)",
          end_of_month: end_of_month, beginning_of_month: beginning_of_month
    )
    
  end

  def self.data_publicacao_portal_in_range(start_date, end_date)
    where(data_publicacao_portal: (start_date.beginning_of_day..end_date.end_of_day))
  end

  #
  # Usado por controllers que possuem o filtro de Credor.
  #
  def self.creditors_name_column
    'integration_contracts_contracts.descricao_nome_credor'
  end

  ## Instance methods

  ### Helpers

  def title
    isn_sic.to_s
  end

  def valor_aditivo
    additives.total_addition
  end

  def valor_ajuste
    adjustments.total_adjustments
  end

  def valor_empenhado
    financials.document_sum
  end

  def valor_pago
    financials.payment_sum
  end

  def valor_atualizado_total
    (valor_atualizado_concedente + valor_atualizado_contrapartida)
  end

  def status
    if data_termino >= Date.today.end_of_day
      :vigente
    else
      :concluido
    end
  end

  def management_contract?
    decricao_modalidade == 'GESTÃO'
  end

  def status_str
    I18n.t("integration/contracts/contract.statuses.#{status}")
  end

  def infringement_status_str
    I18n.t("integration/contracts/contract.infringement_statuses.#{infringement_status}")
  end

  #
  # XXX Override pois os valores gerados pelo importador estão chegando nil
  # e nossos helper de exibição esperam um BigDecimal
  #
  def calculated_valor_empenhado
    super || BigDecimal(0)
  end

  def calculated_valor_pago
    super || BigDecimal(0)
  end
  #
  # END
  #

  # Private

  private

  ## Callbacks

  def set_plain_num_contrato
    self.plain_num_contrato = (num_contrato.present? ? plain_string(num_contrato) : nil)
  end

  def set_plain_cpf_cnpj_financiador
    self.plain_cpf_cnpj_financiador = (cpf_cnpj_financiador.present? ? plain_string(cpf_cnpj_financiador) : nil)
  end

  def set_cod_financiador_including_zeroes
    # inclue 0 no início do campo até o tamanho de 8 caracteres:
    # 123 -> 00000123
    self.cod_financiador_including_zeroes = (cod_financiador.present? ? cod_financiador.to_i.to_s.rjust(8, "0") : nil)
  end

  def set_contract_type
    if (flg_tipo.in?(KIND[:contrato]))
      self.contract_type = :contrato
    elsif (flg_tipo.in?(KIND[:convenio]))
      self.contract_type = :convenio
    else
      self.contract_type = :unknown
    end
  end

  def plain_string(string)
    string.gsub(/[^0-9A-Za-z]/, '')
  end
end
