class AddPublishedToTickets < ActiveRecord::Migration[5.0]
  def change
    add_column :tickets, :published, :boolean, default: false
  end
end
