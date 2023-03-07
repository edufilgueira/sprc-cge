require 'rails_helper'

describe Transparency::SpreadsheetCleaner do

  it 'clear_expired' do
    expired = create(:transparency_export, :server_salary, status: :success, expiration: Date.today)
    not_expired = create(:transparency_export, :server_salary, status: :success, expiration: Date.today + 1)

    Transparency::SpreadsheetCleaner.call

    # Todos as planilhas vinculadas ao model são removidas no callback do model (testes no model)
    expect(Transparency::Export.all).to eq([not_expired])
  end
end
