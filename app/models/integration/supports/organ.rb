# Representa os órgãos usuados para relacionar os recursos de trasparência
#
class Integration::Supports::Organ < ApplicationDataRecord
  include ::Integration::Supports::Organ::Search
  include ::Sortable

  # Associations

  has_many :server_salaries,
    foreign_key: 'integration_supports_organ_id',
    class_name: 'Integration::Servers::ServerSalary'

  has_many :organ_server_roles,
    foreign_key: 'integration_supports_organ_id',
    class_name: 'Integration::Supports::OrganServerRole'

  has_many :roles, through: :organ_server_roles

  # Validations

  ## Presence

  validates :codigo_orgao,
    :descricao_orgao,
    presence: true


  # Callbacks

  after_validation :set_secretary

  # Public

  ## Class methods

  ### Scopes

  def self.default_sort_column
    'integration_supports_organs.codigo_orgao'
  end

  def self.default_sort_direction
    :asc
  end

  def self.secretaries
    where(secretary: true)
  end

  def self.organs
    where(secretary: false)
  end

  def organs
    return Integration::Supports::Organ.none unless secretary?

    Integration::Supports::Organ.where.not(id: id).where(codigo_entidade: codigo_entidade)
  end

  ## Instance methods

  ### Helpers

  def title
    descricao_orgao
  end

  def acronym
    sigla
  end

  private

  ## Callbacks

  def set_secretary
    self.secretary = (codigo_orgao.present? && codigo_orgao.ends_with?('0001')) || (descricao_orgao == descricao_entidade)
  end
end
