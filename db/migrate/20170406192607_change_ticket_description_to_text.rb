class ChangeTicketDescriptionToText < ActiveRecord::Migration[5.0]
  def up
    change_column :tickets, :description, :text
  end

  def down
    change_column :tickets, :description, :string
  end
end
