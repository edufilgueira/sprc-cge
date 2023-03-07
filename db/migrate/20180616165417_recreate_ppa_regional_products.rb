class RecreatePPARegionalProducts < ActiveRecord::Migration[5.0]
  def change
    rename_index :ppa_annual_regional_products,
                 'index_ppa_regional_products_uniqueness',
                 'index_ppa_annreg_products_uniqueness'

    create_table :ppa_regional_products do |t|
      t.integer  "product_id", null: false, index: true
      t.integer  "region_id",     null: false, index: true

      t.timestamps
    end

    add_foreign_key :ppa_regional_products, :ppa_products, column: :product_id
    add_foreign_key :ppa_regional_products, :ppa_regions,  column: :region_id

    add_index :ppa_regional_products, %i[product_id region_id], unique: true
  end
end
