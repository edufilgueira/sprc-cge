class Transparency::ExportMailer < ApplicationMailer

  def spreadsheet_success(export)
    @title = export.name
    @expiration = l(export.expiration.to_date)
    @url = download_transparency_export_url(export, format: :xlsx)

    mail(to: export.email, subject: I18n.t('transparency.export_mailer.spreadsheet_success.subject'))
  end

  def spreadsheet_error(export)
    @title = export.name

    mail(to: export.email, subject: I18n.t('transparency.export_mailer.spreadsheet_error.subject'))
  end
end
