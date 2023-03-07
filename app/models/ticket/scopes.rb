#
# Métodos e constantes para os escopos de Ticket
#

module Ticket::Scopes
  extend ActiveSupport::Concern

  OMBUDSMAN_ATTENDANCE_STATUSES = [:sectoral_attendance, :subnet_attendance]

  included do

    # Public

    ## Class methods

    def self.need_update_deadline
      where(decrement_deadline: true).where(
        "tickets.deadline_updated_at < ? OR deadline_updated_at IS NULL", Date.today
      )
    end

    def self.deadline_outdated
      where(decrement_deadline: true).where('tickets.deadline_updated_at < ?', Date.today)
    end

    def self.deadline_invalid
      where(decrement_deadline: true, internal_status: Ticket::INTERNAL_STATUSES_TO_LOCK_DEADLINE)
    end

    def self.ombudsman_attendance
      where(internal_status: OMBUDSMAN_ATTENDANCE_STATUSES)
    end

    def self.with_phone_or_whatsapp
      where('answer_type IN (:status)', status: [1,8])
    end

    def self.from_type(ticket_type)
      where(ticket_type: ticket_type)
    end

    def self.from_organ(organ)
      where(organ: organ)
    end

    def self.from_security_organ
      joins(:organ).where(organs: { acronym: Organ::SECURITY_ORGANS })
        .where.not(internal_status: [:in_filling, :waiting_confirmation, :waiting_referral])
    end

    def self.from_denunciation_organ(organ)
      where(denunciation_organ: organ)
    end

    def self.from_subnet(subnet)
      where(subnet: subnet)
    end

    def self.from_reopened
      where('tickets.reopened > 0')
    end

    def self.from_child_ticket_department(department)
      joins(tickets: :ticket_departments).where(ticket_departments: { department: department }).distinct
    end

    def self.from_ticket_department(department)
      joins(:ticket_departments).where(ticket_departments: { department: department }).distinct
    end

    def self.from_ticket_sub_department(sub_department)
      joins(ticket_departments: :ticket_department_sub_departments).
        where(ticket_department_sub_departments: { sub_department_id: sub_department }).
        distinct
    end

    def self.parent_tickets
      where(parent_id: nil)
    end

    def self.child_tickets
      where.not(parent_id: nil)
    end

    def self.leaf_tickets
      left_joins(:tickets).where(tickets_tickets: { id: nil})
    end

    def self.public_tickets
      parent_tickets.where(published: true)
    end

    def self.with_used_input(used_input)
      where(used_input: used_input)
    end

    def self.with_status(status)
      where(status: status)
    end

    def self.with_internal_status(status)
      where(internal_status: status)
    end

    def self.with_internal_status_expired(status, user)
      joins(:answers)
      .where(internal_status: status, answers: { answer_type: :partial })
      .where('date(answers.created_at) < ?', Date.today - (180.days))
    end

    def self.with_rede_ouvir
      left_joins(:tickets).where(tickets_tickets: { rede_ouvir: true })
    end

    def self.with_rede_ouvir_cge
      left_joins(:tickets).where(tickets_tickets: { organ_id: ::RedeOuvirOrgan.cge })
    end

    def self.leafs_with_internal_status(status)
      left_joins(:tickets)
        .where(
          "tickets_tickets.id IS NULL AND
          tickets.internal_status = :status OR
          tickets_tickets.internal_status = :status", status: Ticket.internal_statuses[status])
    end

    def self.without_internal_status(status)
      where.not(internal_status: status)
    end

    def self.with_organ(organ)
      # left_joins(:tickets).where(tickets_tickets: { organ_id: organ })
      joins("LEFT OUTER JOIN tickets AS tickets_tics ON tickets_tics.parent_id = tickets.id")
      .where(
        tickets_tics: {
          organ_id: organ,
          deleted_at: nil
        }
      )
    end

    def self.with_sub_department(sub_department)
      scope_classification.where('classifications.sub_department_id = :sub_department OR
        (tickets.parent_id is null AND classifications_tickets.sub_department_id = :sub_department)', sub_department: sub_department)
    end

    def self.with_topic(topic)
      scope_classification.where('classifications.topic_id = :topic OR
        (tickets.parent_id is null AND classifications_tickets.topic_id = :topic)', topic: topic)
    end

    def self.with_subtopic(subtopic)
      scope_classification.where('classifications.subtopic_id = :subtopic OR
        (tickets.parent_id is null AND classifications_tickets.subtopic_id = :subtopic)', subtopic: subtopic)
    end

    def self.with_budget_program(budget_program)
      scope_classification.where('classifications.budget_program_id = :budget_program OR
        (tickets.parent_id is null AND classifications_tickets.budget_program_id = :budget_program)', budget_program: budget_program)
    end

    def self.with_theme(theme)
      scope_classification_budget_program.where('budget_programs.theme_id = :theme OR
        (tickets.parent_id is null AND budget_programs_classifications.theme_id = :theme)', theme: theme)
    end

    def self.with_service_type(service_type)
      scope_classification.where('classifications.service_type_id = :service_type OR
        (tickets.parent_id is null AND classifications_tickets.service_type_id = :service_type)', service_type: service_type)
    end

    def self.with_other_organs
      left_joins(:classification).where(classifications: { other_organs: true })
    end

    def self.without_other_organs
      left_joins(:classification).where(classifications: { other_organs: [nil, false] })
    end

    def self.without_characteristic
      left_joins(:classification)
      .where('classifications.topic_id != ?
        OR classifications.topic_id IS NULL', Topic.only_no_characteristic.id)        
    end

    def self.with_attendances_no_characteristic
      left_joins(:attendance).where(attendances: { service_type: :no_characteristic })
    end

    def self.with_ticket_finished
      left_joins(:classification).joins(:answers)
      .where(answers: { status: [:cge_approved, :sectoral_approved] })
      .where('classifications.other_organs = ?
        OR tickets.organ_id = ?', true, ExecutiveOrgan.dpge.id)
    end

    def self.without_organ_dpge
      return all unless ExecutiveOrgan.dpge.present?

      where(organ_id: nil).or(where.not(organ_id: ExecutiveOrgan.dpge.id))
    end

    def self.with_deadline(deadline)
      scope = where(deadline: Ticket::FILTER_DEADLINE[deadline.to_sym]).
        with_extended(deadline)

      scope = scope.where(confirmed_at: limit_to_extend_range) if deadline.to_sym == :expired_can_extend

      scope.not_partial_answer.not_appealed

    end

    def self.with_ticket_department_deadline(deadline)
      deadline_scope = [ Ticket::FILTER_DEADLINE[deadline.to_sym] ]
      deadline_scope << nil if deadline.to_sym == :not_expired

      scope = joins(:ticket_departments).where(ticket_departments: { deadline: deadline_scope }).
        with_extended(deadline)

      scope = scope.where(ticket_departments: { created_at: limit_to_extend_range}) if deadline.to_sym == :expired_can_extend

      scope.not_partial_answer.not_appealed

    end

    def self.with_answer_type(answer_type)
      where(answer_type: answer_type)
    end

    def self.with_sou_type(sou_type)
      where(sou_type: sou_type)
    end

    def self.with_denunciation_assurance(denunciation_assurance)
      where(denunciation_assurance: denunciation_assurance)
    end

    def self.with_all_denunciation_assurance
      where(denunciation_assurance: Ticket.available_denunciation_assurances.keys)
    end

    def self.active
      where.not(internal_status: Ticket::INACTIVE_STATUSES)
    end

    def self.active_not_answered
      where.not(internal_status: Ticket::INACTIVE_NOT_ANSWERED_STATUSES)
    end

    def self.not_partial_answer
      where.not(internal_status: :partial_answer)
    end

    def self.without_partial_answer
      without_reopening.where.not(
        id: with_answer_partial
      ).or(
        where.not(reopened_at: nil, id: data_answers_bigger_than_data_reopens)
      )
    end

    def self.without_reopening
      where(reopened_at: nil)
    end

    def self.with_answer_partial
      joins(:answers).where(answers: { answer_type: :partial })
    end

    def self.data_answers_bigger_than_data_reopens
      with_answer_partial.where('answers.created_at > tickets.reopened_at')
    end

    def self.not_invalidated
      where.not(internal_status: :invalidated)
    end

    def self.inactive
      where(internal_status: Ticket::INACTIVE_STATUSES)
    end

    def self.priority
      where(priority: true)
    end

    def self.not_replied
      in_progress.or(confirmed)
    end

    def self.not_denunciation
      sic.or(where.not(sou_type: :denunciation))
    end

    def self.with_extended(deadline)
      return all unless deadline.to_sym == :expired_can_extend

      self.where(extended: false)
    end

    def self.reopened
      parent_tickets_not_invalidated.
        ticket_logs_by_action(:reopen)
    end

    def self.appealed
      parent_tickets_not_invalidated.
        ticket_logs_by_action(:appeal)
    end

    def self.reopened_at(start_date, end_date)
      reopened.by_ticket_log_created_at(start_date, end_date)
    end

    def self.appealed_at(start_date, end_date)
      appealed.by_ticket_log_created_at(start_date, end_date)
    end

    def self.by_ticket_log_created_at(start_date, end_date)
      start_date = start_date.present? ? Date.parse(start_date) : default_start_date
      end_date = end_date.present? ? Date.parse(end_date) : default_end_date

      joins(:ticket_logs).where(ticket_logs: { created_at: start_date..end_date })
    end

    def self.parent_tickets_not_invalidated
      parent_tickets.not_invalidated
    end

    def self.ticket_logs_by_action(action)
      joins(:ticket_logs).where(ticket_logs: { action: action })
    end

    def self.default_start_date
      Date.new(0)
    end

    def self.first_confirmed_date
      Ticket.order(confirmed_at: :asc).first.confirmed_at.to_date.to_s
    end

    def self.default_end_date
      Date::Infinity.new
    end

    def self.with_answers_awaiting_cge_validation
      joins(ticket_logs: :answer).
        where(ticket_logs: {resource_type: 'Answer'},
          answers: {status: :awaiting, answer_scope: :sectoral}).distinct
    end

    def self.cgd_denunciation
      where(organ: Organ.cgd)
        .sectoral_attendance
        .denunciation
        .from_denunciation_organ(Organ.security_organs)
    end

    def self.not_appealed
      where.not(internal_status: :appeal)
    end
    # privates

    private

    def self.scope_classification
      left_joins(classification: [], tickets: [:classification])
    end

    def self.scope_classification_budget_program
      left_joins(tickets: [classification: [:budget_program]], classification: [:budget_program])
    end

    def self.limit_to_extend_range
      (Date.today - Ticket::LIMIT_TO_EXTEND_DEADLINE.days)..Date.today
    end

  end
end
