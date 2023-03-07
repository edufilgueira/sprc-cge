require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Sprc
  class Application < Rails::Application
    config.generators do |g|
      g.test_framework :rspec
      g.template_engine :haml
    end

    custom_paths = [
      Rails.root.join('app', 'workers'),
      Rails.root.join('app', 'services'),
      Rails.root.join('app', 'presenters')
    ]

    # This is needed to make it work in production
    # see http://blog.arkency.com/2014/11/dont-forget-about-eager-load-when-extending-autoload/
    config.eager_load_paths += custom_paths
    config.autoload_paths += custom_paths

    config.active_record.default_timezone = :local
    config.encoding = 'utf-8'
    config.time_zone = 'America/Fortaleza'

    config.generators.assets = false
    config.generators.helper = false

    # Carrega os arquivos de rotas separados em config/routes
    routes = Dir[Rails.root.join("config/routes/*.rb")] + config.paths['config/routes.rb']
    config.paths['config/routes.rb'] = routes


    # Carrega os locales separados em vários arquivos
    config.i18n.load_path += Dir[
      Rails.root.join('config', 'locales', '**', '*.{rb,yml}').to_s
    ]

    config.i18n.available_locales = [
      :'pt-BR',
      :en,
      :es
    ]

    config.i18n.default_locale = :'pt-BR'

    # XXX Como as partes "internas" (operadores), rotas, e alguns outros pontos não serão traduzidos,
    # ligaremos o fallback - para default_locale pt-BR - para toda a app!
    # --
    # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
    # the I18n.default_locale when a translation cannot be found).
    config.i18n.fallbacks = true

    # Ensuring locale on requests in multi-threaded environments
    # @see https://github.com/svenfuchs/i18n/issues/381
    config.middleware.use ::I18n::Middleware

    config.active_job.queue_adapter = :sidekiq

    config.to_prepare do
      Mailboxer::Notification.send(:include, Mailboxer::Notification::Search)
    end

    # para url_helpers dos serializers e mailers, definido em
    # config/application.yml
    Rails.application.routes.default_url_options[:host] = ENV['DEFAULT_HOST']

    # Páginas de erro específicas, com rotas definidas no routes (routes.rb),
    # tratadas pelo ErrorsController
    # @see https://mattbrictson.com/dynamic-rails-error-pages
    # @see https://github.com/rails/rails/blob/master/actionpack/lib/action_dispatch/middleware/public_exceptions.rb
    config.exceptions_app = self.routes
  end
end
