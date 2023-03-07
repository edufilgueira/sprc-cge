#
# Ability base de usuários da plataforma:
#
# As permissões estão definidas em cada ability específico:
#
# Abilities::Users::Public definição de permissões sem login;
#
# Abilities::Users::User definição de permissões para usuário logado;
#
# Abilities::Users::Operator definição de permissões para usuário operador;
#
# Abilities::Users::Admin definição de permissões para usuário administrador;
#

class Abilities::User

  def self.factory(user)
    return Abilities::Users::Public.new if user.blank?
    return Abilities::Users::Admin.new(user) if user.admin?
    return Abilities::Users::Operator.factory(user) if user.operator?
    return Abilities::Users::User.new(user) if user.user?
  end
end
