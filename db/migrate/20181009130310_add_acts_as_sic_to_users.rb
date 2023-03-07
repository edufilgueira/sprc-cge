class AddActsAsSicToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :acts_as_sic, :boolean, default: false
  end
end
