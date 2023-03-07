class AddCityToTickets < ActiveRecord::Migration[5.0]
  def change
    add_reference :tickets, :city, foreign_key: true
  end
end
