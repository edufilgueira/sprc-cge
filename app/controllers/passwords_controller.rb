class PasswordsController < Devise::PasswordsController

  NAMESPACES = {
    admin: :admin,
    operator: :operator,
    user: :platform
  }

  # enhancement
  def update
    super do |resource|
      next unless resource.errors.empty? # success condition

      # garantindo a confirmação de um usuário, caso ele tenha redefinido a senha antes de confirmar
      resource.confirm if resource.respond_to?(:confirmed?) && !resource.confirmed?
      resource.update(password_changed_at: Time.current)
    end
  end

  private

  def after_resetting_password_path_for(resource)
    namespace = NAMESPACES[resource.user_type.to_sym]

    url_for([namespace, :root])
  end
end
