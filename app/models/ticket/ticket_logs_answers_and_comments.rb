module Ticket::TicketLogsAnswersAndComments
  extend ActiveSupport::Concern

  included do


    # Associations
    has_many :ticket_logs, dependent: :destroy
    has_many :comments, dependent: :destroy, as: :commentable, inverse_of: :commentable
    has_many :answers, dependent: :destroy, inverse_of: :ticket
    has_many :citizen_comments, dependent: :destroy
    has_many :ticket_log_comments, through: :ticket_logs, source: :resource, source_type: 'Comment'
    has_many :ticket_log_answers, through: :ticket_logs, source: :resource, source_type: 'Answer'
    has_many :answer_attachments, through: :answers, source: :attachments

    # Nesteds

    accepts_nested_attributes_for :answers, reject_if: :all_blank

    # Delegations

    delegate :answers, to: :parent, prefix: true, allow_nil: true

    # Public

    ## Instance methods

    ### Scopes

    def sorted_comments(scope)
      comments.where(scope: scope).sorted
    end

    def sorted_ticket_logs
      ticket_logs.sorted
    end

    def sorted_ticket_logs_for_operator
      ticket_logs.where.not(action: TicketLog::HIDDEN_IN_HISTORY).sorted
    end

    def sorted_ticket_protect_attachments_logs
      ticket_logs.where(action: 'ticket_protect_attachment').sorted
    end


    ### Helpers

    # XXX Only external
    def public_comments
      ticket_log_comments.external
    end

    # XXX Refactor this sections
    # Todas as respostas visíveis ao operadores
    def final_answers_to_operators
      ticket_logs_by_answer_status(parent_ticket_logs, Answer::VISIBLE_TO_OPERATOR_STATUSES)
    end

    # Todas as respostas visíveis ao cidadão
    def final_answers_to_users
      ticket_logs_by_answer_status(ticket_logs, Answer::VISIBLE_TO_USER_STATUSES)
    end

    # Todas as respostas que estão aguardando aprovação
    def final_answers_awaiting
      ticket_logs_by_answer_status(ticket_logs, [:awaiting])
    end

    # Todos os logs acessíveis pelo cidadão
    def sorted_ticket_logs_for_user
      ticket_logs.where.not(id: ticket_logs_hidden_for_user).sorted
    end

    # Private

    private

    def ticket_logs_hidden_for_user
      ticket_logs.answer.joins(:answer).where.not(
        answers: { status: Answer::VISIBLE_TO_USER_STATUSES }
      ) + ticket_logs.where(action: TicketLog::HIDDEN_IN_HISTORY)
    end

    def ticket_logs_by_answer_status(ticket_logs, statuses)
      ticket_logs.answer.joins(:answer).where(answers: { status: statuses })
    end

    def parent_ticket_logs
      parent? ? ticket_logs : parent.ticket_logs
    end
  end
end
