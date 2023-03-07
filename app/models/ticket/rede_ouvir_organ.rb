module Ticket::RedeOuvirOrgan
  extend ActiveSupport::Concern


  included do
    # callbacks

    before_validation :ensure_rede_ouvir_or_executive, if: :organ_id_changed?

    after_save :create_other_organs_classification, if: :from_rede_ouvir?


    def create_other_organs_classification
      #
      # Todos ticket da rede ouvir a classificação padrão deve ser 'outros poderes'
      #
      classification_rede_ouvir = classification || Classification.create(ticket: self)

      return if classification.other_organs?

      classification_rede_ouvir.other_organs = true

      classification_rede_ouvir.save
    end

    def ensure_rede_ouvir_or_executive
      self.rede_ouvir = from_rede_ouvir?
    end

    def from_rede_ouvir?
      organ.is_a?(::RedeOuvirOrgan)
    end
  end
end
