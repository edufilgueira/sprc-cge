class CreatePPARegions < ActiveRecord::Migration[5.0]
  def change
    create_table :ppa_regions do |t|
      t.string :name, null: false, unique: true

      t.timestamps
    end
  end
end
