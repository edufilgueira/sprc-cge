#
# Representa um gasto básico: NED, NLD, NPF ou NPD herdam desta classe.
#
#
class Integration::Expenses::Base < ApplicationDataRecord
  include ::Sortable

  self.abstract_class = true

  # Associations

  belongs_to :management_unit,
    class_name: 'Integration::Supports::ManagementUnit',
    foreign_key: :unidade_gestora,
    primary_key: :codigo

  belongs_to :executing_unit,
    class_name: 'Integration::Supports::ManagementUnit',
    foreign_key: :unidade_executora,
    primary_key: :codigo

  belongs_to :creditor,
    class_name: 'Integration::Supports::Creditor',
    foreign_key: :credor,
    primary_key: :codigo

  # Validations

  ## Presence

  validates :exercicio,
    :unidade_gestora,
    :numero,
    presence: true


  # Delegations

  delegate :title, :acronym, to: :management_unit, prefix: true, allow_nil: true
  delegate :title, :acronym, to: :executing_unit, prefix: true, allow_nil: true
  delegate :title, :nome, to: :creditor, prefix: true, allow_nil: true

  # Callbacks

  before_save :set_date_of_issue

  # Public

  ## Class methods

  ### Scopes

  def self.issued_on_month(date)
    beginning_of_month = date.beginning_of_month
    end_of_month = date.end_of_month

    where("DATE(date_of_issue) >= :beginning_of_month AND DATE(date_of_issue) <= :end_of_month", beginning_of_month: beginning_of_month, end_of_month: end_of_month)
  end

  def self.default_sort_column
    "#{table_name}.date_of_issue"
  end

  def self.default_sort_direction
    :desc
  end

  def self.ordinarias
    where("#{natureza_column_name} = ? OR #{natureza_column_name} = ?", 'Ordinária', 'ORDINARIA')
  end

  def self.suplementacoes
    where("#{natureza_column_name} = ? OR #{natureza_column_name} = ?", 'Suplementação', 'SUPLEMENTACAO')
  end

  def self.anulacoes
    where("#{natureza_column_name} = ? OR #{natureza_column_name} = ?", 'Anulação', 'ANULACAO')
  end

  def self.from_organ(cod_orgao)
    where("unidade_gestora = ?", cod_orgao)
  end

  def self.from_executivo
    joins(:management_unit).where('integration_supports_management_units.poder = ?', 'EXECUTIVO')
  end

  ## Instance methods

  ### Helpers

  def title
    "#{management_unit_acronym} - #{numero}/#{exercicio}"
  end

  def anulacao?
    natureza == 'Anulação' || natureza == 'ANULACAO'
  end

  def suplementacao?
    natureza == 'Suplementação' || natureza == 'SUPLEMENTACAO'
  end

  # Private

  private

  def set_date_of_issue
    self.date_of_issue = Date.parse(data_emissao) if data_emissao.present?
  end

  def self.natureza_column_name
    "#{table_name}.natureza"
  end
end
