#
# Representa a exportações de Tranparency::SurveyExport
#
class SurveyAnswerExport < ApplicationRecord
  include SurveyAnswerExport::Search
  include ::Sortable


  # Associations

  belongs_to :user


  # validations

  validates :name,
    :start_at,
    :ends_at,
    :worksheet_format,
    :user,
    presence: true

  ## Range

  validates_inclusion_of :ends_at,
    in: :ends_at_in_range, if: -> { start_at.present? }


  # enums

  enum status: [:queued, :in_progress, :error, :success]

  enum worksheet_format: [:xlsx, :csv]

  # delegations

  delegate :title, to: :user, prefix: true

  # Callbacks

  before_destroy :remove_worksheet


  # Public

  ## Class methods

  ### Scopes

  def self.default_sort_column
    'survey_answer_exports.created_at'
  end

  def self.default_sort_direction
    :desc
  end


  ## Instances Methods

  ### Helpers

  def title
    name
  end

  def dirpath
    Rails.root.join('public', 'files', 'downloads', 'survey_answer_exports')
  end

  def filepath(filename = nil)
    filename = filename || self.filename

    "#{dirpath}/#{filename}"
  end


  private

  def ends_at_in_range
    start_at..DateTime.now
  end

  ## Callbacks

  def remove_worksheet
    SurveyAnswerExport::RemoveSpreadsheet.delay.call(self.filepath) if success?
  end
end
