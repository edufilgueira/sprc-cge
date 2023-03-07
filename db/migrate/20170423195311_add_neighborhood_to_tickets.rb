class AddNeighborhoodToTickets < ActiveRecord::Migration[5.0]
  def change
    add_column :tickets, :answer_address_neighborhood, :string
  end
end
