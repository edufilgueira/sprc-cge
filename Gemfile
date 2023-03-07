source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

# core

gem 'rails', '~> 5.0.7'
gem 'puma', '~> 3.0'
gem 'figaro'
gem 'paranoia'

# https://github.com/refile/refile
gem "refile", github: 'refile/refile', require: "refile/rails"
gem "refile-mini_magick", github: 'refile/refile-mini_magick'
# https://github.com/refile/refile/issues/447
gem 'sinatra', github: 'sinatra/sinatra', branch: 'master'

gem 'fcm'

gem 'friendly_id'

# auth

gem 'cancancan'
gem 'devise'
gem 'devise-i18n'
gem 'omniauth-facebook'
gem "recaptcha", require: "recaptcha/rails"

# cache

gem 'dalli'
gem 'kgio'
gem 'memcache-client'
gem 'rack-cache'

# email
gem 'premailer-rails' # html emails made easy

# database

gem 'bcrypt', '3.1.12'
gem 'pg', '0.21' # a versão não está compatível com o Rails 5.0.6 (foi corrigido no 5.1.5.rc1)

# background job
gem 'sidekiq', '5.2.9'
gem 'redis', '~>3.2'
gem 'whenever'

# SOAP client
gem 'savon', '~> 2.3.0'

# Para poder usar proxy e testar a integração com os webservices durante o
# desenvolvimento, é preciso a versão 3 do savon (que ainda não é production-ready).
#
# Ver config do proxy em BaseIntegrationsImporter
# gem 'savon', github: 'savonrb/savon', branch: 'master'

# frontend

gem 'bootstrap', '4.0.0.alpha6'
gem 'cocoon'
gem 'coffee-rails'
gem 'haml'
gem 'haml-rails'
gem 'jbuilder'
gem 'jquery-rails'
gem 'kaminari'
gem 'maskedinput-rails'
gem 'remotipart', '~> 1.2'
gem 'sass-rails'
gem 'simple_form'
gem 'momentjs-rails'
gem 'bootstrap3-datetimepicker-rails'
gem 'ckeditor'
gem 'switchery-rails'

gem 'rails-assets-tether'
gem 'therubyracer'
gem 'uglifier', '>= 1.3.0'
gem 'yui-compressor', '0.11.0'

# analytics
gem 'newrelic_rpm'
#gem "skylight", '1.5.1'

# token authentication
gem "tiddle"

# validation
gem 'cpf_cnpj'

# serializer
gem 'active_model_serializers', '~> 0.10.0'

# Axlsx: Office Open XML Spreadsheet Generation
gem 'axlsx', git: 'https://github.com/randym/axlsx', branch: 'master'
gem 'axlsx_rails'
gem 'roo'
gem 'roo-xls'

# Messaging
gem 'mailboxer'


# i18n
gem 'globalize'


# activerecord
gem 'active_record_union'

#code inspect and console organization
gem 'awesome_print'

group :development, :test do
  gem 'byebug'
  gem 'pry'
  gem 'pry-rails'
  gem 'pry-byebug'
  gem 'factory_bot_rails'
  gem 'timecop'
  gem 'spring'
  gem 'spring-watcher-listen'
end

group :development do

  # deploy
  gem 'airbrussh'
  gem "capistrano", "~> 3.16.0"
  gem 'capistrano-rvm'
  gem 'capistrano-rails'
  gem 'capistrano-passenger'

  #gem 'better_errors'
  #gem 'binding_of_caller'

  # TODO acompanhar https://github.com/ddollar/foreman/issues/688 e atualizar foreman quando
  # corrigirem e lançarem nova versão (> 0.84.0)
  gem 'foreman', git: 'https://github.com/ppdeassis/foreman.git', branch: 'thor-updated'

  gem 'letter_opener'
  gem 'listen'
  gem 'metric_fu'
  gem 'rails_best_practices'

  # UML diagrams
  gem "rails-erd"
  # gem 'railroady'

end

group :test do
  gem 'codeclimate-test-reporter'

  gem 'database_cleaner'
  gem 'fake_ftp'
  gem 'guard-rspec'
  gem 'rails-controller-testing'
  gem 'rspec'
  gem 'rspec-rails'
  gem 'shoulda-matchers'
  gem 'spring-commands-rspec'

  gem 'simplecov'
  gem 'simplecov-rcov'

  gem 'terminal-notifier-guard', require: false

  gem 'shoulda-callback-matchers', '~> 1.1.1'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
