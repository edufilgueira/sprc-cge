class CreatePPARegionalInitiatives < ActiveRecord::Migration[5.0]
  def change
    create_table :ppa_regional_initiatives do |t|
      t.integer :initiative_id, null: false, index: true
      t.integer :region_id,   null: false, index: true
      t.integer :year,        null: false, index: true

      t.timestamps
    end

    add_foreign_key :ppa_regional_initiatives, :ppa_initiatives, column: :initiative_id
    add_foreign_key :ppa_regional_initiatives, :ppa_regions,     column: :region_id

    add_index :ppa_regional_initiatives, %i[initiative_id region_id year], unique: true,
      name: 'index_ppa_regional_initiatives_uniqueness'
  end
end
