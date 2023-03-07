class ApplicationController < ActionController::Base
  include ::BaseController
  include ::ExceptionHandler

  prepend_before_action :set_locale
  protect_from_forgery with: :exception
  before_action :set_acessibility
  

  helper_method [
    :acessibility?,
    :show_warning_sefaz_migration?,
    :has_privacy_statement_check?
  ]


  def set_locale
    # Temos que garantir que se o parametro locale vier em branco (''),
    # seja carregado o locale padrão.

    I18n.locale = valid_locale? ? params[:locale] : I18n.default_locale
  end

  def set_acessibility
    acessibility = params[:acessibility]
    cookies[:acessibility] = acessibility if acessibility.present?
  end

  def acessibility?
    !!ActiveModel::Type::Boolean.new.cast(cookies[:acessibility])
  end

  # XXX implementando como método de classe - e não como de instância como sugerido pelas docs -
  # pois o funcionamento é o mesmo e o ambiente de testes funciona sem necessidade de intervenção
  #   @see http://til.obiefernandez.com/posts/b540850342-using-defaulturloptions-in-rspec-with-rails-5
  #   @see https://github.com/rspec/rspec-rails/issues/255#issuecomment-24796864
  #   @see https://github.com/rspec/rspec-rails/issues/255#issuecomment-206590216
  def self.default_url_options(options = {})
    options.merge({
      locale: I18n.locale
    })
  end

  def has_privacy_statement_check?
    cookies[:grant_privacy_statement]
  end

  def show_warning_sefaz_migration?
    !ActiveModel::Type::Boolean.new.cast(cookies[:show_warning_sefaz_migration])
  end

  private

  def current_ability
    @current_ability ||= Abilities::User.factory(current_user)
  end

  def valid_locale?
    param_locale.present? &&  I18n.available_locales.include?(param_locale.to_sym)
  end

  def param_locale
    params[:locale]
  end
end
