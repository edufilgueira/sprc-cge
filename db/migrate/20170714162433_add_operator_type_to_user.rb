class AddOperatorTypeToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :operator_type, :integer
    add_reference :users, :organ, foreign_key: true
    add_reference :users, :department, foreign_key: true
  end
end
