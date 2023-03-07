class PPA::Source::Region < ApplicationDataRecord

  # Validations

  validates :codigo_regiao,    presence: true, uniqueness: true
  validates :descricao_regiao, presence: true, uniqueness: true

end
