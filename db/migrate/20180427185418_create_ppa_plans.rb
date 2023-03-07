class CreatePPAPlans < ActiveRecord::Migration[5.0]
  def change
    create_table :ppa_plans do |t|

      t.integer :start_year,        null: false
      t.integer :end_year,          null: false
      t.date    :proposal_start_in, null: false
      t.date    :proposal_end_in,   null: false
      t.date    :voting_start_in,   null: false
      t.date    :voting_end_in,     null: false

      t.timestamps
    end
  end
end
