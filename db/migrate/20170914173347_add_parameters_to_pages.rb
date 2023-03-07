class AddParametersToPages < ActiveRecord::Migration[5.0]
  def change
    add_reference :pages, :parent, foreign_key: { to_table: :pages }
    add_column :pages, :status, :integer
    add_column :pages, :menu_title, :string
  end
end
