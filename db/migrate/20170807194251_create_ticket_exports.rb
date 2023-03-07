class CreateTicketExports < ActiveRecord::Migration[5.0]
  def change
    create_table :ticket_exports do |t|
      t.string :title
      t.string :filename
      t.text :filters
      t.references :user, foreign_key: true, null: false
      t.integer :processed
      t.integer :status, index: true
      t.integer :total
      t.integer :total_to_process
      t.boolean :public

      t.timestamps
    end
  end
end
