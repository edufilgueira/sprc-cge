class AddTargetAddressToTickets < ActiveRecord::Migration[5.0]
  def change
    add_column :tickets, :target_address_zipcode, :string
    add_column :tickets, :target_city_id, :integer
    add_column :tickets, :target_address_street, :string
    add_column :tickets, :target_address_number, :string
    add_column :tickets, :target_address_neighborhood, :string
    add_column :tickets, :target_address_complement, :string
  end
end
