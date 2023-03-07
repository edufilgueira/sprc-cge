class AddAnswerTypeAndAnswerStatusToComment < ActiveRecord::Migration[5.0]
  def change
    add_column :comments, :answer_type, :integer
    add_column :comments, :answer_scope, :integer
    add_column :comments, :answer_status, :integer
  end
end
