#
# Métodos e constantes de busca para Attendance
#

module AttendanceReport::Search
  extend ActiveSupport::Concern
  include Searchable

  # LOWER é mais rápido que ILIKE

  SEARCH_EXPRESSION = %q{
    attendance_reports.title LIKE :search
  }
end
