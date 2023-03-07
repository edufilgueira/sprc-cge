class Integration::Servers::Registration < ApplicationDataRecord
  include Integration::Servers::ProceedMultiOrigin

  # Constants

  COD_SITUATION_INACTIVE = %w[7]
  COD_SITUATION_ACTIVE = %w[0 1 2 3 4 5 6 8]

  BLANK_CPF = '00000000000'

  FUNCTIONAL_STATUSES_VALUES = {
    functional_status_active: ["ATIVO", "AGUARDANDO APOSENTADORIA", "TEMPORARIO", "SESA/CS"],
    functional_status_retired: ["APOSENTADO"],
    functional_status_pensioner: ["PENSIONISTA"],
    functional_status_intern: ["ESTAGIARIO/BOLSISTA"]
  }

  # De acordo com a documentação:
  #
  # "A situação funcional deve ser agrupada da seguinte forma:
  #   Ativo: Ativo, aguardando aposentadoria, temporário, sesa/cs,
  #   Aposentado: aposentado
  #   Pensionista: Pensionista
  #   Estagiário/Bolsista: Estagiário/bolsista"
  #
  # E deve ser atualizado a partir do valor da coluna registration.status_situacao_funcional


  enum functional_status: [
    :functional_status_active,
    :functional_status_retired,
    :functional_status_pensioner,
    :functional_status_intern
  ]

  # Associations

  belongs_to :organ,
    primary_key: :codigo_folha_pagamento,
    foreign_key: :cod_orgao,
    class_name: 'Integration::Supports::Organ'

  belongs_to :server,
    primary_key: :dsc_cpf,
    foreign_key: :dsc_cpf,
    class_name: 'Integration::Servers::Server'

  has_many :proceeds,
    foreign_key: 'full_matricula',
    primary_key: 'full_matricula',
    class_name: 'Integration::Servers::Proceed',
    dependent: :destroy

  has_many :server_salaries,
    foreign_key: 'integration_servers_registration_id',
    class_name: 'Integration::Servers::ServerSalary',
    dependent: :destroy

  # Delegations

  delegate :acronym, to: :organ, prefix: true, allow_nil: true
  delegate :orgao_sfp?, to: :organ, prefix: false, allow_nil: true

  # Validations

  ## Presence

  validates :dsc_matricula,
    presence: true

  # Callbacks

  after_validation :set_functional_status,
    :set_active_functional_status,
    :set_full_matricula

  # Public

  ## Class methods

  ### Scopes

  def self.active
    where(active_functional_status: true)
  end

  def self.inactive
    where(active_functional_status: false)
  end

  def self.with_proceeds
    joins(:proceeds)
  end

  def self.with_proceeds_from_month(year, month)
    joins(:proceeds).where('integration_servers_proceeds.num_mes = ? AND integration_servers_proceeds.num_ano = ?', month, year)
  end

  def self.sorted
    order(vdth_admissao: :desc)
  end

  def self.credit_proceeds
    proceeds_from_type('V')
  end

  def self.debit_proceeds
    proceeds_from_type('D')
  end

  def self.credit_proceeds_sum(month, year)
    credit_proceeds_from_date(month, year).sum('vlr_financeiro')
  end

  ### Helpers

  def self.situacao_funcional_statuses
    select('DISTINCT status_situacao_funcional').order('status_situacao_funcional').map(&:status_situacao_funcional)
  end

  def credit_proceeds(date)
    filtered_proceeds(date).credit.where(integration_servers_proceed_types: { origin: proceed_type_origin })
  end

  def debit_proceeds(date)
    filtered_proceeds(date).debit.where(integration_servers_proceed_types: { origin: proceed_type_origin })
  end

  def under_roof_debit_proceeds(date)
    filtered_proceeds(date).under_roof
  end

  def non_under_roof_debit_proceeds(date)
    filtered_proceeds(date).non_under_roof
  end

  def total_salary(date)
    credit_proceeds(date).credit_sum - debit_proceeds(date).debit_sum
  end

  def title
    [dsc_matricula, organ_acronym].reject(&:blank?).join(' - ')
  end

  def title_with_organ_and_role
    [dsc_funcionario, organ_acronym, dsc_cargo].reject(&:blank?).join(' - ')
  end

  def organ_and_role
    [organ_acronym, dsc_cargo].reject(&:blank?).join(' - ')
  end

  def active?
    active_functional_status
  end

  # privates

  private

  def filtered_proceeds(date)
    sorted_proceeds.from_period(date)
  end

  def sorted_proceeds
    self.proceeds.sorted
  end

  def self.proceeds_from_type(dsc_tipo)
    joins({ proceeds: :proceed_type }).where(integration_servers_proceed_types: { dsc_tipo: dsc_tipo, origin: proceed_type_origin })
  end

  def self.credit_proceeds_from_date(month, year)
    credit_proceeds.where(integration_servers_proceeds: { num_ano: year, num_mes: month })
  end

  ## Callbacks

  def set_functional_status
    if status_situacao_funcional.present?

      FUNCTIONAL_STATUSES_VALUES.each do |status, values|
        if values.include?(status_situacao_funcional)
          self.functional_status = status
          return
        end
      end
    end
  end

  def set_active_functional_status
    if cod_situacao_funcional.present?
      self.active_functional_status = (COD_SITUATION_ACTIVE.include?(cod_situacao_funcional) && dsc_cpf != BLANK_CPF)
    end
  end

  def set_full_matricula
    self.full_matricula = "#{cod_orgao}/#{dsc_matricula}"
  end
end
