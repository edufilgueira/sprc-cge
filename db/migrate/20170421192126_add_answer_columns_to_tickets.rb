class AddAnswerColumnsToTickets < ActiveRecord::Migration[5.0]
  def change
    add_column :tickets, :answer_phone, :string
    add_column :tickets, :answer_address_city_name, :string
    add_column :tickets, :answer_address_street, :string
    add_column :tickets, :answer_address_number, :string
    add_column :tickets, :answer_address_zipcode, :string
    add_column :tickets, :answer_address_complement, :string
  end
end
