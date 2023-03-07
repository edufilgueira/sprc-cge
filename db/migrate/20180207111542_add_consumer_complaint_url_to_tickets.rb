class AddConsumerComplaintUrlToTickets < ActiveRecord::Migration[5.0]
  def change
    add_column :tickets, :used_input_url, :string
  end
end
