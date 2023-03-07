class Operator::CommentsController < OperatorController
  include ::Tickets::Comments::BaseController

  def comment_form_url
    [:operator, new_comment]
  end
end
