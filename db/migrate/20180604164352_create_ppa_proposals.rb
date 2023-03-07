class CreatePPAProposals < ActiveRecord::Migration[5.0]
  def change
    create_table :ppa_proposals do |t|
      t.integer :plan_id,        null: false
      t.integer :objective_id,   null: false
      t.string  :strategy
      t.text    :justification
      t.integer :comments_count, default: 0
      t.integer :votings_count,  default: 0

      t.timestamps
    end

    add_index :ppa_proposals, :plan_id
    add_index :ppa_proposals, :objective_id

    add_foreign_key :ppa_proposals, :ppa_plans, column: :plan_id
    add_foreign_key :ppa_proposals, :ppa_objectives, column: :objective_id
  end
end
