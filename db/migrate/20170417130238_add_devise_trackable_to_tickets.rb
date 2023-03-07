class AddDeviseTrackableToTickets < ActiveRecord::Migration[5.0]
  def self.up
    change_table :tickets do |t|

      ## Trackable

      t.integer  :sign_in_count, default: 0, null: false
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.inet     :current_sign_in_ip
      t.inet     :last_sign_in_ip

    end
  end

  def self.down
    remove_column :tickets, :sign_in_count
    remove_column :tickets, :current_sign_in_at
    remove_column :tickets, :last_sign_in_at
    remove_column :tickets, :current_sign_in_ip
    remove_column :tickets, :last_sign_in_ip
  end
end
