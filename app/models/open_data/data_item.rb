#
# Representa um item (arquivo ou webservice) de Dados Abertos
#

class OpenData::DataItem < ApplicationDataRecord

  # Setup

  attachment :document

  # Associations

  belongs_to :data_set, foreign_key: :open_data_data_set_id, class_name: 'OpenData::DataSet'

  # Enums

  enum data_item_type: [:file, :webservice]

  enum status: [:status_queued, :status_in_progress, :status_success, :status_fail]

  #  Validations

  ## Presence

  validates :title,
    :description,
    :data_item_type,
    :data_set,
    :document_public_filename,
    presence: true

  validates :document,
    presence: true,
    if: :file?

  validates :response_path,
    :wsdl,
    :operation,
    presence: true,
    if: :webservice?


  # Callbacks

  after_commit :import, if: :webservice?

  def import
    Integration::Importers::Import.call(:open_data, id)
  end

  # Helpers

  def data_item_type_str
    I18n.t("open_data/data_item.data_item_types.#{data_item_type}")
  end

  def download_url
    if persisted?
      return webservice_download_url if webservice?
      return file_download_url if file?
    end

    nil
  end

  # Privates

  private

  def webservice_download_url
    if document_filename.present?
      url = "/files/downloads/integration/open_data/data_items/#{id}/#{document_filename}"
      file_path = Rails.root.join('public', 'files', 'downloads', 'integration', 'open_data', 'data_items', id.to_s, document_filename)

      return url if File.exist?(file_path)
    end
    nil
  end

  def file_download_url
    if document.present?
      return Refile.attachment_url(self, :document, force_download: true)
    end
    nil
  end
end

