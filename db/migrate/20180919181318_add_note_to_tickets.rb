class AddNoteToTickets < ActiveRecord::Migration[5.0]
  def change
    add_column :tickets, :note, :text
  end
end
