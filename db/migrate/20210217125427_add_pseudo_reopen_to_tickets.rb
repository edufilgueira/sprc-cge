class AddPseudoReopenToTickets < ActiveRecord::Migration[5.0]
  def change
    add_column :tickets, :pseudo_reopen, :boolean
  end
end
