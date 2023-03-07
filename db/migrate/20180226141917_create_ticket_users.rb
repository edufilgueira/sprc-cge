class CreateTicketUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :ticket_users do |t|
      t.references :ticket, foreign_key: true, null: false
      t.references :user, foreign_key: true, null: false
      t.boolean :like, null: false, default: false
      t.boolean :following, null: false, default: false

      t.timestamps
    end
  end
end
