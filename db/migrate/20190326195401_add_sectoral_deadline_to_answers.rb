class AddSectoralDeadlineToAnswers < ActiveRecord::Migration[5.0]
  def change
    add_column :answers, :sectoral_deadline, :integer
  end
end
