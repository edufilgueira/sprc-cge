class CreateTicketLikes < ActiveRecord::Migration[5.0]
  def change
    create_table :ticket_likes do |t|
      t.references :ticket, foreign_key: true, null: false
      t.references :user, foreign_key: true, null: false

      t.timestamps
    end
  end
end
