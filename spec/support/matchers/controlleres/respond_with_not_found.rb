require 'rspec/expectations'

#
#   Módulo de suporte para specs com controle de permissões CanCan/not_found - HTTP STATUS 403
#
module ControllerRespondWithNotFoundSupportMatcher
  extend RSpec::Matchers::DSL

  #
  # Matcher para facilitar testes de not_found (RecordNotFound handler em ExceptionHandler)
  #
  # Uso:
  #
  # it { is_expected.to respond_with_not_found }
  #
  # expect(response).to respond_with_not_found
  #
  matcher :respond_with_not_found do
    match do |response|
      if request.xhr?
        expect(response).to have_http_status(:not_found)
      else
        expect(response).to have_http_status(:not_found).and render_template 'errors/not_found'

        # Caso queiramos tratar com redirecionamento, usar:
        # --
        #
        # XXX: since it's a named route, RSpec does not have it included.
        # We can't include it because of the i18n `locale` param, which breaks everything.
        # So, we're comparing with a regexp, to ignore the `?locale...` portion of it
        # --
        # expect(response).to redirect_to Rails.application.routes.url_helpers.not_found_path
        # expect(response).to redirect_to %r[#{Rails.application.routes.url_helpers.not_found_path}]
      end
    end
  end

end

RSpec.configure do |config|
  config.include ControllerRespondWithNotFoundSupportMatcher, type: :controller
end
