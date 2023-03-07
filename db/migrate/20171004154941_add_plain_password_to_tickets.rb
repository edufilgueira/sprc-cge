class AddPlainPasswordToTickets < ActiveRecord::Migration[5.0]
  def change
    add_column :tickets, :plain_password, :string
  end
end
