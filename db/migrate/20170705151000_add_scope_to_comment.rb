class AddScopeToComment < ActiveRecord::Migration[5.0]
  def change
    # scope enum default: 1 = :external para os dados já presentes
    add_column :comments, :scope, :integer, null: false, default: 1
    add_index :comments, :scope
  end
end
