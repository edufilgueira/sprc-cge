class AddFollowAttrToTicketUser < ActiveRecord::Migration[5.0]
  def change
    add_column :ticket_users, :email, :string
    add_column :ticket_users, :confirmed_email, :boolean
    add_column :ticket_users, :unfollow_token, :string
    add_column :ticket_users, :confirmation_token, :string

    change_column_null :ticket_users, :user_id, true

    add_index :ticket_users, :email
    add_index :ticket_users, :unfollow_token
    add_index :ticket_users, :confirmation_token
  end
end
