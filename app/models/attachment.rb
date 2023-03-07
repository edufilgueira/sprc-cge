#
# Representa um anexo e pode ser utilizado em qualquer model que permita anexos.
#

class Attachment < ApplicationRecord

  # Setup

  attachment :document

  # Associations

  belongs_to :attachmentable, polymorphic: true

  # Validations

  ## Presence

  validates :document,
    presence: true

  validates :title,
    :imported_at,
    presence: true,
    if: :belongs_to_page?

  # callbacks

  before_save :parameterize_document_filename


  # Public

  ## Instance methods

  def url
    Refile.attachment_url(self, :document)
  end

  private

  def belongs_to_page?
    attachmentable_type == 'Page'
  end

  def parameterize_document_filename
    self.document_filename = parameterized_filename if self.document_filename.present?
  end

  def parameterized_filename
    parameterized_basename + extname
  end

  def parameterized_basename
    File.basename(document_filename, ".*").parameterize
  end

  def extname
    File.extname(document_filename)
  end

end
