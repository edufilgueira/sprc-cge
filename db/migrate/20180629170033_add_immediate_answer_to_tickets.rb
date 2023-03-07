class AddImmediateAnswerToTickets < ActiveRecord::Migration[5.0]
  def change
    add_column :tickets, :immediate_answer, :boolean
  end
end
