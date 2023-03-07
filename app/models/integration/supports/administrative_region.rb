#
# Tabela Execício
#
# Regiões Administrativas
#

class Integration::Supports::AdministrativeRegion < ApplicationDataRecord

  # Validations

  ## Presence

  validates :codigo_regiao,
    :titulo,
    presence: true

  # Callbacks

  after_validation :set_codigo_regiao_resumido

  # Public

  ## Instance methods

  ### Helpers

  def title
    titulo
  end

  # Private

  private

  def set_codigo_regiao_resumido
    self.codigo_regiao_resumido = nil

    if codigo_regiao.present? && codigo_regiao.ends_with?('00000')
      self.codigo_regiao_resumido = codigo_regiao.gsub('00000', '')
    end
  end
end
