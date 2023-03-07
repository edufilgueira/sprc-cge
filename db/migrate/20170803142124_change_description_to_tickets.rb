class ChangeDescriptionToTickets < ActiveRecord::Migration[5.0]
  def change
    change_column_null :tickets, :description, true
  end
end
