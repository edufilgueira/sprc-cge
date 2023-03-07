require 'rails_helper'

describe Integration::Importers::Import do
  it 'invokes data import with parameters' do
    ENV["SPRC_DATA_HOST"] = 'http://test.local'

    expect(Net::HTTP).to receive(:start).with('test.local', 80, use_ssl: false)

    Integration::Importers::Import.call(:servers, 1)
  end

  it 'uses ssl' do
    ENV["SPRC_DATA_HOST"] = 'https://test.local'

    expect(Net::HTTP).to receive(:start).with('test.local', 443, use_ssl: true)

    Integration::Importers::Import.call(:servers, 1)
  end
end
