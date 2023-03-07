class Operator::SouEvaluationSample < ApplicationRecord
  include Searchable
  include Sortable
  
  # Setup

  acts_as_paranoid
  
  # Associations
  has_many :sou_evaluation_sample_details, class_name: 'Operator::SouEvaluationSampleDetail', dependent: :destroy

  # Enums
  enum status: [:open, :completed]
  
  # Validates
  validates :title, presence: true
  
  def resource_type
    :sou_evaluation_sample
  end

  def self.default_sort_column
    :code
  end

  def self.default_sort_direction
    :desc
  end

  def self.first_created_date
    self.order(created_at: :asc).first.created_at.to_date.to_s
  end

end
