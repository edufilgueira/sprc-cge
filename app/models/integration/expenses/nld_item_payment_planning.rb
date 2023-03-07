#
# Representa: Itens de Planejamento de Pagamentos de NLD
#
#
class Integration::Expenses::NldItemPaymentPlanning < ApplicationDataRecord

  # Associations

  belongs_to :nld, foreign_key: 'integration_expenses_nld_id',
    inverse_of: :nld_item_payment_plannings


  # Validations

  ## Presence

  validates :nld,
    presence: true

end
