class AddColumnsUserInfoToTicket < ActiveRecord::Migration[5.0]
  def change
    add_column :tickets, :social_name, :string
    add_column :tickets, :gender, :integer
  end
end
