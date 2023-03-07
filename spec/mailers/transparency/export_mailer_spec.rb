require 'rails_helper'

describe Transparency::ExportMailer do

  describe '#spreadsheet' do
    it 'success' do
      export = create(:transparency_export, :server_salary, expiration: Date.today)

      mail = Transparency::ExportMailer.spreadsheet_success(export)

      expect(mail.to).to eq([export.email])
      expect(mail.subject).to eq(I18n.t('transparency.export_mailer.spreadsheet_success.subject'))
    end

    it 'error' do
      export = create(:transparency_export, :server_salary, status: :error)

      mail = Transparency::ExportMailer.spreadsheet_error(export)

      expect(mail.to).to eq([export.email])
      expect(mail.subject).to eq(I18n.t('transparency.export_mailer.spreadsheet_error.subject'))
    end
  end
end
