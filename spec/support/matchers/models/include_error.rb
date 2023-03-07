require 'rspec/expectations'

module ModelIncludeErrorSupportMatcher
  extend RSpec::Matchers::DSL


  #
  #   Check for errors (symbols) in an ActiveRecord::Base.
  #
  #   Usage:
  # expect(record).to include_error(:blank).on(:name)
  # expect(record).to include_error(:blank, interpolate: 'something').on(:name)
  #
  #
  #   If you don't need validation (#valid?) to be executed, pass the option
  # :skip_validate.
  #
  # it 'complex spec' do
  #   expect { record.do_something_that_adds_error! }.to raise_error
  #   expect(record).to include_error(:blank, skip_validate: true).on(:name)
  # end
  #
  matcher :include_error do |error_sym, **options|
    match do |record|
      record = record

      record.valid? unless options.delete :skip_validate
      record.errors.added?(@attribute, error_sym, options)
    end

    description do
      "include error :#{error_sym} on #{@attribute}"
    end

    failure_message do |record|
      <<-ERR.strip_heredoc
        expected #{record} to include error :#{error_sym} on \"#{@attribute}\"
          errors present: #{record.errors.to_json}
      ERR
    end

    failure_message_when_negated do |record|
      <<-ERR.strip_heredoc
        expected #{record} not to include error :#{error_sym} on \"#{@attribute}\"
          errors present: #{record.errors.to_json}
      ERR
    end

    chain(:on) { |attribute| @attribute = attribute }

  end
end

RSpec.configure do |config|
  config.include ModelIncludeErrorSupportMatcher, type: :model
  config.include ModelIncludeErrorSupportMatcher, type: :search
end
