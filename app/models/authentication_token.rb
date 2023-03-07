#
# Representa um token de autentição de algum usuário dos aplicativos mobile.
#
# É usado para fazer a autenticação das requisições feitas via API (gem tiddle).
#

class AuthenticationToken < ApplicationRecord
  belongs_to :user

end
