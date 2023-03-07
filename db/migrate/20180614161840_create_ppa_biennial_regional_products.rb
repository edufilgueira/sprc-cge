class CreatePPABiennialRegionalProducts < ActiveRecord::Migration[5.0]
  def change
    create_table :ppa_biennial_regional_products do |t|
      t.integer  "product_id", null: false, index: true
      t.integer  "region_id",  null: false, index: true
      t.integer  "start_year", null: false, index: true
      t.integer  "end_year",   null: false, index: true

      t.timestamps
    end

    add_foreign_key :ppa_biennial_regional_products, :ppa_products, column: :product_id
    add_foreign_key :ppa_biennial_regional_products, :ppa_regions,  column: :region_id
  end
end
