module Denunciable
  extend ActiveSupport::Concern

  included do

    enum denunciation_assurance: {
      assured: 0,
      suspicion: 1,
      rumor: 2,
      legacy_assurance: -1
    }

    def self.available_denunciation_assurances
      denunciation_assurances.reject { |_, value| value < 0 }
    end
  end


  # helper para poder ser usado com content_with_label(ticket, :denunciation_assurance_str)

  def denunciation_assurance_str
    return "" unless denunciation_assurance.present?

    self.class.human_attribute_name("denunciation_assurance.#{denunciation_assurance}")
  end

  # helper para poder ser usado com content_with_label(ticket, :denunciation_description_str)

  def denunciation_description_str
    denunciation_description
  end

  # helper para poder ser usado com content_with_label(ticket, :denunciation_date_str)

  def denunciation_date_str
    denunciation_date
  end

  # helper para poder ser usado com content_with_label(ticket, :denunciation_place_str)

  def denunciation_place_str
    denunciation_place
  end

  # helper para poder ser usado com content_with_label(ticket, :denunciation_witness_str)

  def denunciation_witness_str
    denunciation_witness
  end

  # helper para poder ser usado com content_with_label(ticket, :denunciation_evidence_str)

  def denunciation_evidence_str
    denunciation_evidence
  end
end
