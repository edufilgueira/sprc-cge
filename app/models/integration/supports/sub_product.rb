#
# Tabela Execício
#
# SubProduto
#

class Integration::Supports::SubProduct < ApplicationDataRecord

  # Associations

  belongs_to :product,
    class_name: 'Integration::Supports::Product',
    foreign_key: :codigo_produto,
    primary_key: :codigo

  # Validations

  ## Presence

  validates :codigo,
    :codigo_produto,
    :titulo,
    presence: true

  # Public

  ## Instance methods

  ### Helpers

  def title
    titulo
  end
end
