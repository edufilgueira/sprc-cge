#
# Representa um órgão da ouvidoria da rede ouvir.
#
# EX: TJ, Prefeitura de fortaleza, ...
#
class RedeOuvirOrgan < Organ

  # Constantes

  REDE_OUVIR_CGE_ACRONYM = 'CGE'

  #  Validations

  ## Presence

  validates :name,
    :acronym,
    presence: true

  validates_uniqueness_of :acronym


  # Class methods

  ## Scopes

  def self.cge
    #
    # Rede Ouvir - Governo Estadual é órgão central da rede ouvir
    #
    find_by(acronym: REDE_OUVIR_CGE_ACRONYM)
  end


  # Instance methods

  ## Helpers

  def cge?
    acronym == REDE_OUVIR_CGE_ACRONYM
  end
end
