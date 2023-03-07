#
# Representa uma página estática para o portal de transparência
#

class Page < ApplicationRecord
  include ::Sortable
  include ::Globalizeable
  include ::FriendlyId
  include ::Page::Search

  # Setup

  friendly_id :title, :use => [:slugged, :finders]

  translates :title, :menu_title, :content, :cached_charts, fallbacks_for_empty_translations: false


  # Enums

  enum status: [:active, :inactive]

  serialize :cached_charts, Array
  # Fix para erro da gem globalize para atributo serialize
  # https://github.com/globalize/globalize/issues/53#issuecomment-1753204
  translation_class.send :serialize, :cached_charts, Array

  # Associations

  belongs_to :parent, class_name: 'Page'

  has_many :pages, -> { joins(:translations).order("page_translations.menu_title") }, dependent: :destroy, foreign_key: 'parent_id'
  has_many :attachments, dependent: :destroy, class_name: 'Page::Attachment'
  has_many :page_charts, dependent: :destroy, class_name: 'Page::Chart', inverse_of: :page

  # Attachments

  accepts_attachments_for :attachments, append: true

  # Nesteds

  accepts_nested_attributes_for :attachments, reject_if: :attachment_blank?, allow_destroy: true
  accepts_nested_attributes_for :page_charts, reject_if: :all_blank, allow_destroy: true

  # Validations

  ## Presence

  validates :title,
    :content,
    :menu_title,
    :status,
    presence: true


  ## Parent
  validate :valid_parent_association,
    if: :parent_id?


  # Delegations

  delegate :menu_title, to: :parent, prefix: true, allow_nil: true

  # Callbacks

  after_commit :serialize_charts, on: [:create, :update]

  # Public

  ## Class methods

  ### Scopes

  def self.default_sort_column
    'page_translations.title'
  end

  def self.sorted_parents
    where(parent_id: nil, status: :active).order(menu_title: :asc)
  end

  # helper para poder ser usado com content_with_label(page, :status_str)
  def status_str
    self.class.human_attribute_name("status.#{status}")
  end

  # Private

  private

  ## attributes nested reject_if custom method

  def attachment_blank?(attributes)
    attributes['document'] == '{}'
  end

  ## validates invalid parent association

  def valid_parent_association
    invalid = self.id == self.parent_id || self.parent.parent_id.present?
    errors.add(:parent, :parent_association) if invalid
  end

  def serialize_charts
    self.update_attribute(:cached_charts, PageSerializer.new(self).to_h[:page_charts])
  end
end
