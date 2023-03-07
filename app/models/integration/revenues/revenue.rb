class Integration::Revenues::Revenue < ApplicationDataRecord
  include ::Sortable
  include Integration::SecretaryAndOrganWithDataTermino
  include Integration::Revenues::Revenue::Search

  enum account_type: [:poder_executivo, :receitas_lancadas]

  ACCOUNTS_TYPES = {
    poder_executivo: ['5.2.1.1', '5.2.1.1.1', '5.2.1.2.1', '5.2.1.2.1.0.1', '5.2.1.2.1.0.2', '5.2.1.2.9', '6.2.1.2', '6.2.1.3'],
    receitas_lancadas: ['4.1.1.2.1.03.01', '4.1.1.2.1.06', '4.1.1.2.1.97.01', '4.1.1.2.1.97.11']
  }

  # Associations

  has_many :accounts, foreign_key: 'integration_revenues_revenue_id',
    inverse_of: :revenue, dependent: :destroy

  belongs_to :account_configuration,
    foreign_key: 'integration_revenues_account_configuration_id'

  # Temos que dar essa volta no belongs_to pois o órgão tem 'data_termino'.
  # Ou seja, para a associação, primeiro temos que tentar encontrar um órgão
  # com a data_termino <= à data deste registro. Caso não encontre, tenta
  # encontrar um com data_termino 'nil'.
  #
  # Ex:
  # SECRETARIA DA SEGURANÇA PÚBLICA E DEFESA SOCIAL: data_termino: 06/12/2017
  # Como a receita só tem mês/ano, vamos considerar a data_termino do órgão como sendo o final do mês.

  belongs_to :organ,
    foreign_key: 'integration_supports_organ_id',
    class_name: 'Integration::Supports::Organ'

  belongs_to :secretary,
    foreign_key: 'integration_supports_secretary_id',
    class_name: 'Integration::Supports::Organ'

  # Nested

  accepts_nested_attributes_for :accounts

  #  Delegations

  delegate :title, to: :account_configuration, prefix: true
  delegate :title, :acronym, to: :organ, prefix: true, allow_nil: true

  # Validations

  ## Presence

  validates :unidade,
    :poder,
    :administracao,
    :conta_contabil,
    :titulo,
    :natureza_da_conta,
    :natureza_credito,
    :valor_credito,
    presence: true

  validates :natureza_debito,
    :valor_debito,
    :valor_inicial,
    :fechamento_contabil,
    :account_configuration,
    :month,
    :year,
    presence: true

  # Callbacks

  after_validation :set_organ, :set_account_type

  # Public

  ## Class methods

  ### Scopes

  def self.default_sort_column
    'integration_revenues_revenues.unidade'
  end

  def self.from_month_and_year(date)
    where(month: date.month, year: date.year)
  end

  def self.from_year(year)
    where(year: year)
  end

  ## Instance methods

  ### Helpers

  def title
    titulo
  end

  private

  ## Callbacks

  def set_organ
    if unidade.present?
      self.organ = organ_with_data_termino(unidade)
      self.secretary = secretary_from_organ(self.organ)
    end
  end

  def set_account_type
    if ACCOUNTS_TYPES[:poder_executivo].include?(conta_contabil)
      self.account_type = :poder_executivo
    elsif ACCOUNTS_TYPES[:receitas_lancadas].include?(conta_contabil)
      self.account_type = :receitas_lancadas
    end
  end
end
