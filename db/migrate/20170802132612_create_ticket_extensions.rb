class CreateTicketExtensions < ActiveRecord::Migration[5.0]
  def change
    create_table :extensions do |t|
      t.text :description
      t.string :email
      t.string :token, index: true
      t.integer :status, index: true, default: 0
      t.datetime :deleted_at, index: true
      t.references :ticket, index: true

      t.timestamps
    end
  end
end
