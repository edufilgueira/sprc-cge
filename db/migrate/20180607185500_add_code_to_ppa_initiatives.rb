class AddCodeToPPAInitiatives < ActiveRecord::Migration[5.0]
  def change
    add_column :ppa_initiatives, :code, :string, null: false
  end
end
