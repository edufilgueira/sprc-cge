#
# Representa a estrutura do WS de eixos_temas do PPA
#
class PPA::Source::AxisTheme < ApplicationDataRecord

  # Validations

  validates :codigo_eixo, :descricao_eixo, presence: true
  validates :codigo_tema, :descricao_tema, presence: true

  # uniqueness
  validates :codigo_eixo, uniqueness: { scope: :codigo_tema, case_sensitive: false }
end
