#
# Representa: Itens de Retenção de Pagamentos de NLD
#
#
class Integration::Expenses::NldItemPaymentRetention < ApplicationDataRecord

  # Associations

  belongs_to :nld, foreign_key: 'integration_expenses_nld_id',
    inverse_of: :nld_item_payment_retentions


  # Validations

  ## Presence

  validates :nld,
    presence: true

end
