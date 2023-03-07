class AddNameToBiennialRegionalInitiatives < ActiveRecord::Migration[5.0]
  def change
    add_column :ppa_biennial_regional_initiatives, :name, :string, index: true
  end
end
