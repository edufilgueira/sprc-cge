class CreateTicketDepartments < ActiveRecord::Migration[5.0]
  def change
    create_table :ticket_departments do |t|
      t.references :ticket, foreign_key: true
      t.references :department, foreign_key: true
      t.text :description
      t.datetime :deleted_at, index: true

      t.timestamps
    end
  end
end
