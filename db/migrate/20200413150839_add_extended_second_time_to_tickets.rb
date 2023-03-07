class AddExtendedSecondTimeToTickets < ActiveRecord::Migration[5.0]
  def change
    add_column :tickets, :extended_second_time, :boolean
  end
end
