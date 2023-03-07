class AddDeviseToTickets < ActiveRecord::Migration[5.0]
  def self.up
    change_table :tickets do |t|
      ## Database authenticatable
      t.string :encrypted_password, null: false, default: ""
    end

  end

  def self.down
    remove_column :tickets, :encrypted_password
  end
end
