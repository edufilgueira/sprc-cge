#
# Representa: Itens de NED
#
#
class Integration::Expenses::NedItem < ApplicationDataRecord
  include ::Sortable

  # Associations

  belongs_to :ned, foreign_key: 'integration_expenses_ned_id',
    inverse_of: :ned_items


  # Validations

  ## Presence

  validates :ned,
    presence: true


  # Public

  ## Class methods

  ### Scopes

  def self.default_sort_column
    'integration_expenses_ned_items.valor_unitario'
  end

end
