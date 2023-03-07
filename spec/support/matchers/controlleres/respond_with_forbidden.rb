require 'rspec/expectations'

#
#   Módulo de suporte para specs com controle de permissões CanCan/forbidden - HTTP STATUS 403
#
module ControllerRespondWithForbiddenSupportMatcher
  extend RSpec::Matchers::DSL

  #
  # Matcher para facilitar testes de permissão
  #
  # Uso:
  #
  # it { is_expected.to respond_with_forbidden }
  #
  # expect(response).to respond_with_forbidden
  #
  matcher :respond_with_forbidden do
    match do |response|
      if request.xhr?
        expect(response).to have_http_status(:forbidden)
      else
        expect(response).to have_http_status(:forbidden).and render_template 'errors/forbidden'

        # Caso queiramos tratar com redirecionamento, usar:
        # --
        #
        # XXX: since it's a named route, RSpec does not have it included.
        # We can't include it because of the i18n `locale` param, which breaks everything.
        # So, we're comparing with a regexp, to ignore the `?locale...` portion of it
        # --
        # expect(response).to redirect_to Rails.application.routes.url_helpers.forbidden_path
        # expect(response).to redirect_to %r[#{Rails.application.routes.url_helpers.forbidden_path}]
      end
    end
  end

end

RSpec.configure do |config|
  config.include ControllerRespondWithForbiddenSupportMatcher, type: :controller
end
