class AddDeadlineToAnswers < ActiveRecord::Migration[5.0]
  def change
    add_column :answers, :deadline, :integer
  end
end
