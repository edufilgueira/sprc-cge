class CreateTicketDepartmentSubDepartments < ActiveRecord::Migration[5.0]
  def change
    create_table :ticket_department_sub_departments do |t|
      t.references :ticket_department, foreign_key: true
      t.references :sub_department, foreign_key: true
      t.datetime :deleted_at, index: true

      t.timestamps
    end
  end
end
