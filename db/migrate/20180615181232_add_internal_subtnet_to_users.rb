class AddInternalSubtnetToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :internal_subnet, :boolean
  end
end
