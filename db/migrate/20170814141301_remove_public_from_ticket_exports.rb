class RemovePublicFromTicketExports < ActiveRecord::Migration[5.0]
  def change
    remove_column :ticket_exports, :public
  end
end
