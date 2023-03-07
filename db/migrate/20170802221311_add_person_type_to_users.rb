class AddPersonTypeToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :person_type, :integer, default: 0
  end
end
