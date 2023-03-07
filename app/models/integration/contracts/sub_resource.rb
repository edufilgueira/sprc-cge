module Integration::Contracts::SubResource
  extend ActiveSupport::Concern

  included do

    # Associations

    belongs_to :contract,
      foreign_key: 'isn_sic',
      primary_key: 'isn_sic',
      class_name: 'Integration::Contracts::Contract'

    belongs_to :convenant,
      foreign_key: 'isn_sic',
      primary_key: 'isn_sic',
      class_name: 'Integration::Contracts::Convenant'

    def contract
      # Precisamos tirar o scope de Contract pois um aditivo pode pertencer a um
      # convênio (que usa a mesma tabela via STI).
      contract = Integration::Contracts::Contract.unscoped{ super }

      return contract if contract.blank?

      if contract.convenio?
        contract.becomes(Integration::Contracts::Convenant)
      else
        contract
      end
    end
  end
end
