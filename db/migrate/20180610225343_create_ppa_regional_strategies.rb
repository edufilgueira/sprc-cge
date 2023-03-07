class CreatePPARegionalStrategies < ActiveRecord::Migration[5.0]
  def change
    create_table :ppa_regional_strategies do |t|
      t.integer :strategy_id, null: false, index: true
      t.integer :region_id,   null: false, index: true
      t.integer :year,        null: false, index: true
      t.integer :priority,                 index: true

      t.timestamps
    end

    add_foreign_key :ppa_regional_strategies, :ppa_strategies, column: :strategy_id
    add_foreign_key :ppa_regional_strategies, :ppa_regions, column: :region_id
  end
end
