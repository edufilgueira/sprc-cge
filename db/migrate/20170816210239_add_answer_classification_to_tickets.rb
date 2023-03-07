class AddAnswerClassificationToTickets < ActiveRecord::Migration[5.0]
  def change
    add_column :tickets, :answer_classification, :integer
  end
end
