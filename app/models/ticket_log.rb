#
#  Representa o histórico de ações dos chamados
#
class TicketLog < ApplicationRecord
  include TicketLog::Search

  # Constants

  NOTIFIABLE_STATUSES = [
    :comment,
    :share,
    :transfer,
    :invalidate,
    :forward,
    :reopen,
    :extension,
    :occurrence,
    :appeal,
    :change_sou_type,
    :change_ticket_type,
    :answer
  ]

  HIDDEN_IN_HISTORY = [
    :pseudo_reopen
  ]


  #  Enums

  enum action: [
    :confirm,
    :comment,
    :share,
    :transfer,
    :invalidate,
    :forward,
    :evaluation,
    :reopen,
    :extension,
    :occurrence,
    :appeal,
    :change_sou_type,
    :change_ticket_type,
    :attendance_response,
    :answer,
    :create_classification,
    :update_classification,
    :create_attachment,
    :destroy_attachment,
    :edit_department_deadline,
    :attendance_finalized,
    :priority,
    :attendance_updated,
    :answer_updated,
    :answer_cge_approved,
    :answer_cge_rejected,
    :delete_share,
    :change_answer_certificate,
    :update_ticket,
    :delete_forward,
    :change_denunciation_type,
    :edit_ticket_description,
    :ticket_protect_attachment,
    :pseudo_reopen,
    :create_sou_evaluation_sample,
    :create_average_internal_evaluation,
    :update_average_internal_evaluation
  ]

  serialize :data, Hash

  #  Associations

  belongs_to :ticket
  belongs_to :responsible, polymorphic: true
  belongs_to :resource, polymorphic: true
  belongs_to :comment, foreign_key: :resource_id
  belongs_to :answer, foreign_key: :resource_id

  #  Validations

  ## Presence

  validates :ticket, :responsible, :action, presence: true

  validates :description,
    presence: true,
    if: :requires_description_for_actions

  # Delegations

  delegate :title, to: :target_ticket, prefix: true, allow_nil: true
  delegate :title, to: :responsible, prefix: true, allow_nil: true

  # Callbacks

  after_create :call_public_ticket_notifier, if: :notifiable?

  ### Scopes

  def self.sorted
    order(:created_at, :id)
  end

  ### Helpers
  #
  # Algumas actions (change_sou_type) são executadas no ticket filhos
  # mas são registradas no ticket pai. nesses casos, o ticket filho é
  # armazenado em data[:target_ticket_id] para que tenhamos referência
  # de onde foi alterado.
  def target_ticket
    @target_ticket ||= (target_ticket_id.present? ? Ticket.with_deleted.find(target_ticket_id) : nil)
  end

 # considera as reaberturas de fato e as pseudos reaberturas
  def reopend_and_pseudo_reopend_ticket_internal_status
    type_reopening =  pseudo_reopen? ? :pseudo_reopen : reopen? ? :reopen : nil

    return ticket.internal_status_str if last_by_type_reopened_log?(type_reopening)

    ticket.reopened_internal_status_str('final_answer')
  end

  private

  def last_by_type_reopened_log?(type_reopening)
    ticket.ticket_logs.send(type_reopening).count == data[:count]
  end

  def requires_description_for_actions
    reopen? || appeal?
  end

  def target_ticket_id
    (data && data[:target_ticket_id])
  end

  def call_public_ticket_notifier
    PublicTicketNotificationService.delay.call(self.id, self.action)
  end

  def notifiable?
    NOTIFIABLE_STATUSES.include?(self.action.to_sym) && self.ticket.published?
  end
end
