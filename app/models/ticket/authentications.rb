#
# Módulo responsável por controle de autenticação (devise) de tickets
# (protocolos).
#

module Ticket::Authentications
  extend ActiveSupport::Concern

  included do

    # Setup

    devise :database_authenticatable,
      :trackable,
      authentication_keys: [:protocol]

    # Public

    ## Helpers

    def has_password?
      self.encrypted_password.present?
    end

    def create_password?
      ! (has_password? || in_progress? || child?)
    end

    def create_password
      # tam mínimo de 4 para usuários do tipo 'Ticket'. Mas para usuários do tipo
      # 'User' é usado um mínimo maior por questões de segurança.
      #
      # devise password ex: 4bB1...
      password = Devise.friendly_token.delete("-_=").first(4).downcase
      self.update_attributes(password: password, plain_password: password)
    end
  end
end
