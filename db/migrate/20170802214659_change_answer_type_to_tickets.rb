class ChangeAnswerTypeToTickets < ActiveRecord::Migration[5.0]
  def change
    change_column_null :tickets, :answer_type, true
  end
end
