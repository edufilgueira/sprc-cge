class Abilities::Users::Operator
  #
  # Essa classe não deve ser instanciada diretamente. Apenas através do
  # Abilities::User.factory que irá verificar qual o tipo do usuário para
  # definir suas abilities.
  #

  def self.factory(user)
    "Abilities::Users::Operator::#{user.operator_type.classify}".constantize.new(user)
  end
end
