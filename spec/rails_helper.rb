ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)

if ENV["COVERAGE"]
  SimpleCov.formatter = SimpleCov::Formatter::RcovFormatter

  SimpleCov.start
end

abort("The Rails environment is running in production mode!") if Rails.env.production?

require 'spec_helper'
require 'rspec/rails'
require 'shoulda/matchers'
require 'sidekiq/testing'

ActiveRecord::Migration.maintain_test_schema!

Dir["./spec/support/**/*.rb"].sort.each { |f| require f}

RSpec.configure do |config|
  config.order = 'random'
  config.infer_spec_type_from_file_location!
  config.include Devise::Test::ControllerHelpers, type: :controller
  config.include FactoryBot::Syntax::Methods

  config.filter_run :focus
  config.run_all_when_everything_filtered = true

  # mais fácil para identificar a chamada com problema no test se ignorar
  # o backtrace do rails. remova esse filtro se precisar saber de pontos de
  # chamada pelo framework todo.
  config.backtrace_exclusion_patterns << /.rvm/

  DatabaseCleaner[:active_record]
  DatabaseCleaner[:active_record, { connection: ApplicationDataRecord }]

  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.around(:each) do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  end
end

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end
