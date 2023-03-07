#
# Representa um órgão da ouvidoria do poder executivo.
#
# Ex CAGECE, SESA, ...
#
class ExecutiveOrgan < Organ

  # Constants

  COMPTROLLER_ACRONYM = 'CGE'

  DENUNCIATION_COMMISSION_ACRONYM = 'COSCO'

  DPGE_ACRONYM = 'DPGE'

  OMBUDSMAN_COORDINATION = 'COUVI'

  # Setup

  acts_as_paranoid

  #  Validations

  ## Presence

  validates :name,
    :acronym,
    presence: true

  validates_uniqueness_of :acronym


  # Class methods

  ## Scopes

  def self.comptroller
    #
    # CGE (Controladoria e Ouvidoria Geral do Estado)
    #
    ExecutiveOrgan.find_by(acronym: COMPTROLLER_ACRONYM)
  end

  def self.dpge
    #
    # DPGE (Defensoria Pública Geral do Estado)

    ExecutiveOrgan.find_by(acronym: DPGE_ACRONYM)
  end

  def self.denunciation_commission
    #
    # COSCO (Comissão Permanente de Apuração de Denúncias)
    #
    ExecutiveOrgan.find_by(acronym: DENUNCIATION_COMMISSION_ACRONYM)
  end

  def self.ombudsman_coordination
    #
    # COUVI (Coordenação de Ouvidoria)
    #
    ExecutiveOrgan.find_by(acronym: OMBUDSMAN_COORDINATION)
  end


  # Instance methods

  ## Helpers

  def cge?
    acronym == COMPTROLLER_ACRONYM
  end
end
