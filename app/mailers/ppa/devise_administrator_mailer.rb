#
# Mailer básico para model PPA::Administrator do Devise
#
# @see https://github.com/plataformatec/devise/issues/1671#issuecomment-4062973
#
class PPA::DeviseAdministratorMailer < DeviseMailer
  # XXX this is not working as it should.
  # @see https://github.com/plataformatec/devise/issues/4842
  # default template_path: 'ppa/admin/auth/mailer'

  protected

  # XXX instead, we're overriding this method to ensure the correct path for the views
  # @see https://github.com/plataformatec/devise/issues/4842
  def headers_for(action, opts)
    # this moves the Devise template path from /views/devise/mailer to /views/mailers/devise
    super.merge! template_path: '/ppa/admin/auth/mailer'
  end

end
