module Operator::SouEvaluationSampleDetailsHelper

  def link_or_read_only_for_denunciantion(ticket, attribute_value, status)
    if current_user.denunciation_tracking || !ticket.denunciation?
      link_to attribute_value, operator_ticket_path(ticket.id, anchor: 'tabs-internal_evaluation', status: status)
    else
      attribute_value
    end
  end
end