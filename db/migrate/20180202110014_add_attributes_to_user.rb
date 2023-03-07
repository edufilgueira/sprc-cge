class AddAttributesToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :education_level, :integer
    add_column :users, :birthday, :date
    add_column :users, :server, :boolean, default: false
    add_column :users, :income, :decimal, precision: 10, scale: 2
    add_column :users, :occupation, :string
  end
end
