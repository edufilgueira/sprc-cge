class CreateTicketSubscriptions < ActiveRecord::Migration[5.0]
  def change
    create_table :ticket_subscriptions do |t|
      t.references :ticket, foreign_key: true, null: false
      t.references :user, foreign_key: true
      t.string :email, null: false, index: true
      t.string :token, index: true
      t.boolean :confirmed_email, default: false

      t.timestamps
    end
  end
end
