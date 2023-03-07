class Reports::Tickets::GrossExport::SouPresenter < Reports::Tickets::GrossExport::BasePresenter

  COLUMNS = [
    :sou_type,
    :denunciation_organ,
    :denunciation_type,
    :denunciation_assurance,
    :organ,
    :subnet,
    :departments,
    :departments_classification,
    :subdepartment,
    :protocol,
    :created_by,
    :anonymous,
    :description,
    :shared,
    :other_organs,
    :internal_status,
    :topic,
    :subtopic,
    :budget_program,
    :service_type,
    :origem_input,
    :year,
    :month,
    :confirmed_at,
    :answered_at,
    :final_answer_at,
    :answer_time_in_days,
    :immediate_answer,
    :last_answer_status,
    :last_answer_status_department,
    :answers_description,
    :answers_department_created_at,
    :reopened,
    :reopened_description,
    :neighborhood,
    :city,
    :state,
    :answer_type,
    :deadline,
    :evaluation,
    :has_extension,
    :answer_classification
  ] + COLUMNS_CREATOR_INFO

  def initialize(scope, gross_export_id)
    super
    @user_permission_original_description = user_has_permission_to_original_description
  end

  def denunciation_type(ticket)
    return if !ticket.denunciation? || ticket.denunciation_type.blank?

    return Ticket.human_attribute_name("denunciation_type.#{ticket.denunciation_type}")
  end


  private

  def cosco_id
    @cosco_id ||= ExecutiveOrgan.denunciation_commission&.id
  end

  def cosco_attendance?(ticket)
    return false if cosco_id.blank?

    ticket.organ_id == cosco_id
  end

  def description(ticket)
    description_str =
      if has_permission_to_original_description(ticket)
        ticket.parent.denunciation_description
      else
        ticket.denunciation? ? ticket.denunciation_description : ticket.description
      end

    ActionController::Base.helpers.sanitize(description_str, tags: [])
  end

  def user_has_permission_to_original_description
    user.coordination? || (user.cge? && user.denunciation_tracking?)
  end

  def has_permission_to_original_description(ticket)
    !ticket.parent? && ticket.denunciation? && @user_permission_original_description
  end
end
