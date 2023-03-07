class CreateTicketDepartmentEmails < ActiveRecord::Migration[5.0]
  def change
    create_table :ticket_department_emails do |t|
      t.references :ticket_department
      t.string :email
      t.string :token, index: true
      t.boolean :active, default: true
      t.references :comment

      t.timestamps
    end
  end
end
