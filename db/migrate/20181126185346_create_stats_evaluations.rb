class CreateStatsEvaluations < ActiveRecord::Migration[5.0]
  def change
    create_table :stats_evaluations do |t|
      t.jsonb :data
      t.integer :evaluation_type
      t.integer :month
      t.integer :year

      t.timestamps
    end

    add_index :stats_evaluations, :evaluation_type
    add_index :stats_evaluations, [:year, :month]
  end
end
