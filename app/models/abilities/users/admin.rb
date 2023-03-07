#
# Ability para usuários administradores da plataforma.
#

class Abilities::Users::Admin < Abilities::Users::Base

  #
  # Essa classe não deve ser instanciada diretamente. Apenas através do
  # Abilities::User.factory que irá verificar qual o tipo do usuário para
  # definir suas abilities.
  #
  def initialize(user)
    can :manage, :all
  end
end
