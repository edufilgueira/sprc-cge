class ChangeCommentToAnswerForTicketDepartmentEmail < ActiveRecord::Migration[5.0]
  def change
    remove_column :ticket_department_emails, :comment_id, :integer
    add_column :ticket_department_emails, :answer_id, :integer
  end
end
