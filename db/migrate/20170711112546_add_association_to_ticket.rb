class AddAssociationToTicket < ActiveRecord::Migration[5.0]
  def change
    add_reference :tickets, :parent, foreign_key: { to_table: :tickets }
  end
end
