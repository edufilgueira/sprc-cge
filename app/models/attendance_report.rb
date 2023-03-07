class AttendanceReport < ApplicationRecord
  include AttendanceReport::Search
  include ::Reportable

  attribute :status, :integer, default: :preparing

  validates :starts_at,
    :ends_at,
    presence: true

  def dir_path
    Rails.root.join('public', 'files', 'downloads', 'attendance_reports', id.to_s)
  end
end
