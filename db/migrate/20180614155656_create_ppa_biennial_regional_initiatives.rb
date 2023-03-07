class CreatePPABiennialRegionalInitiatives < ActiveRecord::Migration[5.0]
  def change
    create_table :ppa_biennial_regional_initiatives do |t|
      t.integer  "initiative_id", null: false, index: true
      t.integer  "region_id",     null: false, index: true
      t.integer  "start_year",    null: false, index: true
      t.integer  "end_year",      null: false, index: true

      t.integer  "products_count", index: true

      t.timestamps
    end

    add_foreign_key :ppa_biennial_regional_initiatives, :ppa_initiatives, column: :initiative_id
    add_foreign_key :ppa_biennial_regional_initiatives, :ppa_regions,     column: :region_id
  end
end
