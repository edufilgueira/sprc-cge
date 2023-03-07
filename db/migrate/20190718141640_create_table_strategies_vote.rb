class CreateTableStrategiesVote < ActiveRecord::Migration[5.0]
  def change
    create_table :ppa_strategies_votes do |t|
      t.references :user, foreign_key: true
      t.references :region, index: true
    end
    add_foreign_key :ppa_strategies_votes, :ppa_regions, column: :region_id
  end
end
