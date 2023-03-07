#
# Model criado para anexos de Page - Não foi usado o model ::Attachment por conta da necessidade de "traduzir" o atributo "title"
#
class Page::Attachment < ApplicationRecord
  include ::Globalizeable

  default_scope -> { sorted }

  # Setup

  attachment :document

  translates :title, fallbacks_for_empty_translations: false

  # Associations

  belongs_to :page

  # Delegations

  delegate :year, to: :imported_at, prefix: true

  # Validations

  ## Presence

  validates :document,
    :title,
    :imported_at,
    presence: true

  before_create :sanitize

  # Public

  ## Class methods

  def self.sorted
    order('imported_at desc, created_at desc')
  end

  def self.by_year(year)
    where('extract(year from imported_at) = ?', year)
  end

  def self.by_title(title)
    where("title ILIKE ?", "%#{title}%")
  end

  def self.join_attachment_detail
    joins('JOIN page_attachment_translations ON page_attachment_translations.page_attachment_id = page_attachments.id')
  end

  def sanitize
    # Remove any character that aren't 0-9, A-Z, or a-z
    sanitized_name = self.document_filename.gsub(/[^0-9A-Z]/i, '_')
    # add extension dot
    sanitized_name[-4] = '.'
    self.document_filename = sanitized_name
  end


  ## Helpers

  def url
    Refile.attachment_url(self, :document)
  end
end
