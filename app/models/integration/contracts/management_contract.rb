class Integration::Contracts::ManagementContract < Integration::Contracts::Contract
  include ::Integration::Contracts::Contract::Search

  # Enums

  def self.default_scope
    where(decricao_modalidade: 'GESTÃO')
  end
end
