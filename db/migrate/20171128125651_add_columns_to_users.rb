class AddColumnsToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :social_name, :string
    add_column :users, :gender, :integer
  end
end
