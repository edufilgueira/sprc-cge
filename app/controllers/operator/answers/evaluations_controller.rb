class Operator::Answers::EvaluationsController < OperatorController
  include ::Answers::Evaluations::BaseController

  def create
    if save_evaluation
      register_log
      answer.user_evaluated!
      update_ticket_call_center_feedback
    end

    render_answer_logs
  end


  # privates

  private

  def update_ticket_call_center_feedback
    ticket_parent.update_attributes({
      call_center_feedback_at: DateTime.now,
      call_center_status: :with_feedback
    })
  end

end
