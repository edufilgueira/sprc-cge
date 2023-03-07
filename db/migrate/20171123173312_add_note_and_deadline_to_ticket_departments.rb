class AddNoteAndDeadlineToTicketDepartments < ActiveRecord::Migration[5.0]
  def change
    add_column :ticket_departments, :note, :text
    add_column :ticket_departments, :deadline, :integer
    add_column :ticket_departments, :deadline_ends_at, :date
  end
end
