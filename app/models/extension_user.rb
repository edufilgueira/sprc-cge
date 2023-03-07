#
# Representa a relação entre pedido de prorrogação de prazo de um chamado com
# o usuário operador
#

class ExtensionUser < ApplicationRecord

  has_secure_token

  # Associations

  belongs_to :extension
  belongs_to :user


  # Validations

  ## Presence

  validates :extension,
    :user,
    presence: true

end
