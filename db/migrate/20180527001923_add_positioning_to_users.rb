class AddPositioningToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :positioning, :boolean, default: false
  end
end
