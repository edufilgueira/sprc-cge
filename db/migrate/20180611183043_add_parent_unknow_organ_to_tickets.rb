class AddParentUnknowOrganToTickets < ActiveRecord::Migration[5.0]
  def change
    add_column :tickets, :parent_unknown_organ, :boolean
  end
end
