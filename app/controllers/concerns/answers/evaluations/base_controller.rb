module ::Answers::Evaluations::BaseController
  extend ActiveSupport::Concern

  PERMITTED_PARAMS = [
    :question_01_a,
    :question_01_b,
    :question_01_c,
    :question_01_d,
    :question_02,
    :question_03,
    :question_04,
    :question_05
  ]


  included do

    before_action :can_evaluate

    helper_method [:answer]

    # Actions

    def create
      answer.user_evaluated! && register_log if save_evaluation

      render_answer_logs
    end


    # helper methods

    def answer
      @answer ||= Answer.find(params[:answer_id])
    end

    def evaluation
      resource || Evaluation.new
    end


    def resource_params
      if params[:evaluation]
        params.require(:evaluation).permit(PERMITTED_PARAMS)
      end
    end


    # privates

    private

    def save_evaluation
      evaluation.evaluation_type = evaluation_type
      evaluation.answer = answer

      evaluation.save
    end

    def ticket
      answer.ticket
    end

    def ticket_parent
      ticket.parent || ticket
    end

    def creator
      current_user || current_ticket
    end

    def evaluation_type
      current_user&.call_center? ? :call_center : ticket.ticket_type
    end

    def render_answer_logs
      render partial: 'shared/answers/evaluations/form', locals: { new_evaluation: evaluation }
    end

    def register_log
      RegisterTicketLog.call(ticket, creator, :evaluation, { resource: evaluation, data: data_attributes })
      RegisterTicketLog.call(ticket_parent, creator, :evaluation, { resource: evaluation, data: data_attributes }) if ticket.parent.present?
    end

    def can_evaluate
      authorize! :evaluate, answer
    end

    def data_attributes
      {
        organ_id: ticket.organ_id
      }
    end
  end
end
