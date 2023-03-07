require 'rails_helper'

describe MobileApp::Search do

  subject(:mobile_app) { create(:mobile_app, name: "App Name search", description: "App Name Description") }

  it 'name' do
    mobile_app
    create(:mobile_app)

    expect(MobileApp.search("name")).to eq([mobile_app])
  end

  it 'description' do
    mobile_app
    create(:mobile_app)

    expect(MobileApp.search("descri")).to eq([mobile_app])
  end
end
