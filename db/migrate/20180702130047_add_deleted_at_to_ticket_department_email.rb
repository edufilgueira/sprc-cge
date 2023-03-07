class AddDeletedAtToTicketDepartmentEmail < ActiveRecord::Migration[5.0]
  def change
    add_column :ticket_department_emails, :deleted_at, :datetime
    add_index :ticket_department_emails, :deleted_at
  end
end
