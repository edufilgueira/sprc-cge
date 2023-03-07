class Integration::Revenues::Account < ApplicationDataRecord
  include Integration::Revenues::Account::Search
  include ::Sortable

  # Associations

  belongs_to :revenue, foreign_key: 'integration_revenues_revenue_id',
    inverse_of: :accounts

  belongs_to :revenue_nature,
    foreign_key: :codigo_natureza_receita,
    primary_key: :codigo,
    class_name: 'Integration::Supports::RevenueNature'

  # Validations

  ## Presence

  validates :conta_corrente,
    :natureza_credito,
    :valor_credito,
    :natureza_debito,
    :valor_debito,
    :valor_inicial,
    :mes,
    :revenue,
    presence: true

  # Callbacks

  after_validation :set_codigo_natureza_receita

  # Delegations

  delegate :organ, to: :revenue, allow_nil: true

  # Public

  ## Class methods

  ### Scopes

  def self.default_sort_column
    'integration_revenues_accounts.conta_corrente'
  end

  def self.from_month_year(month_year)
    month, year = month_year.split('/')

    from_year(year).where('integration_revenues_revenues.month = ?', month)
  end

  def self.from_year(year)
    joins(:revenue).where('integration_revenues_revenues.year = ?', year)
  end

  def self.from_month_range(month_start, month_end, year)
    #
    # Receitas de um período mensal de um determinado ano
    #
    from_year(year).where(mes: month_start..month_end)
  end

  ## Instance methods

  ### Helpers

  def title
    conta_corrente
  end

  ## Private

  private

  def set_codigo_natureza_receita
    self.codigo_natureza_receita = conta_corrente.split('.').first if conta_corrente.present?
  end
end
