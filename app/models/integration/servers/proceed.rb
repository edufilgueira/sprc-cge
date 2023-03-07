class Integration::Servers::Proceed < ApplicationDataRecord
  include Integration::Servers::ProceedMultiOrigin

  # Associations

  belongs_to :registration,
    foreign_key: 'full_matricula',
    primary_key: 'full_matricula',
    class_name: 'Integration::Servers::Registration'

  belongs_to :proceed_type,
    foreign_key: 'cod_provento',
    primary_key: 'cod_provento',
    class_name: 'Integration::Servers::ProceedType'


  
  # Delegations

  #delegate :dsc_provento, to: :proceed_type, allow_nil: true

  # Validations

  ## Presence

  validates :cod_orgao,
    :dsc_matricula,
    :num_ano,
    :num_mes,
    :cod_processamento,
    :cod_provento,
    :vlr_financeiro,
    :vlr_vencimento,
    presence: true


  # Callbacks

  after_validation :set_full_matricula

  # Public

  ## Class methods

  ### Scopes

  def self.sorted
    order(cod_provento: :asc)
  end

  def self.from_period(date)
    from_month_and_year(date.month, date.year)
  end

  def self.from_month_and_year(month, year)
    where(num_mes: month, num_ano: year)
  end

  def self.credit
    joins(:proceed_type).where(integration_servers_proceed_types: { dsc_tipo: 'V' })
  end

  def self.debit
    joins(:proceed_type).where(integration_servers_proceed_types: { dsc_tipo: 'D' })
  end

  def self.under_roof
    debit.where('integration_servers_proceeds.cod_provento = ? OR integration_servers_proceeds.cod_provento = ?', '662', '00662')
  end

  def self.non_under_roof
    debit.where('integration_servers_proceeds.cod_provento != ? AND integration_servers_proceeds.cod_provento != ?', '662', '00662')
  end

  def self.credit_sum
    credit.sum(:vlr_financeiro)
  end

  def self.debit_sum
    debit.sum(:vlr_financeiro)
  end

  def dsc_provento
    Integration::Servers::ProceedType.where(
        cod_provento: cod_provento,
        origin: proceed_type_origin
    ).first.dsc_provento
  end

  ## Instance methods

  ### Helpers

  def title
    cod_provento
  end

  def set_full_matricula
    self.full_matricula = "#{cod_orgao}/#{dsc_matricula}"
  end
end