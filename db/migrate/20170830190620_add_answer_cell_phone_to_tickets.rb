class AddAnswerCellPhoneToTickets < ActiveRecord::Migration[5.0]
  def change
    add_column :tickets, :answer_cell_phone, :string
  end
end
