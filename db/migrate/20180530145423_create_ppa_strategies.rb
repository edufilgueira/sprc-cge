class CreatePPAStrategies < ActiveRecord::Migration[5.0]
  def change
    create_table :ppa_strategies do |t|
      t.integer :objective_id,      null: false
      t.string  :code,              null: false
      t.string  :name,              null: false
      t.integer :initiatives_count
      t.integer :products_count
      t.string  :priorization

      t.timestamps
    end

    add_index :ppa_strategies, :objective_id
    add_foreign_key :ppa_strategies, :ppa_objectives, column: :objective_id
  end
end
