class AddCodeToPPAProducts < ActiveRecord::Migration[5.0]
  def change
    add_column :ppa_products, :code, :string, null: false
  end
end
