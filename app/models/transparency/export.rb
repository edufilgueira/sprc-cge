#
# Representa as exportações das listas filtradas das consultas de transparência
#
class Transparency::Export < ApplicationDataRecord

  DEADLINE_EXPIRATION = 2

  before_destroy :remove_spreadsheet

  enum status: [:queued, :in_progress, :error, :success]
  enum worksheet_format: [:xlsx, :csv]

  validates :name,
    :email,
    :worksheet_format,
    :query,
    :resource_name,
    presence: true

  validates_format_of :email, with: User::REGEX_EMAIL_FORMAT

  # Instances methods

  ## Helpers

  def dirpath
    Rails.root.join('public', 'files', 'downloads', 'transparency', 'export', underscored_resource)
  end

  def resource
    resource_name.classify.safe_constantize
  end

  def underscored_resource
    resource.class_name.underscore
  end

  def camelized_resource
    resource_name.gsub('::', '')
  end

  def filepath(filename = nil)
    filename = filename || self.filename

    "#{dirpath}/#{filename}"
  end

  def title
    name&.truncate(30) || I18n.t('transparency_export.title')
  end


  private

  ## Callbacks

  def remove_spreadsheet
    #
    # Não precisamos de um serviço assíncrono para excluir o arquivo
    # pois hoje, o único modo de remover o registro é pelo serviço Transparency::SpreadsheetCleaner
    # que já é assíncrono
    #
    FileUtils.rm_rf(filepath) if File.exist?(filepath)
  end
end
