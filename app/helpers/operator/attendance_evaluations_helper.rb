module Operator::AttendanceEvaluationsHelper

  def weight_per_ticket_type(ticket_type)
    ticket_type == 'sic' ? default_constant.constantize : "#{default_constant}_SOU".constantize
  end

  # somente pesos das categorias do SIC
  def default_constant
    'AttendanceEvaluation::EVALUATION_WEIGHTS'
  end

  def organ_average_attendance_evaluation
  	find_organ.average_attendance_evaluation
  end

  def find_organ
  	Organ.find(@resource.filters['organ'].to_i)
  end

end
