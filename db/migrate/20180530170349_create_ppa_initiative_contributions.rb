class CreatePPAInitiativeContributions < ActiveRecord::Migration[5.0]
  def change
    create_table :ppa_initiative_contributions do |t|
      t.integer :initiative_id, null: false
      t.integer :strategy_id,   null: false

      t.timestamps
    end

    add_index :ppa_initiative_contributions, [:initiative_id, :strategy_id],
      name: 'ppa_initiative_contributions_on_init_id_strat_id',
      unique: true
  end
end
