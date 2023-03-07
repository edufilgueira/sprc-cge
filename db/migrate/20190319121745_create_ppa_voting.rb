class CreatePPAVoting < ActiveRecord::Migration[5.0]
  def change
    create_table :ppa_votings do |t|
    	t.date     "start_in", null: false
      t.date     "end_in",   null: false
      t.integer  "plan_id",   null: false, index: true
      t.integer  "region_id",   null: false, index: true

      t.timestamps
    end

     add_foreign_key :ppa_votings, :ppa_plans, column: :plan_id
     add_foreign_key :ppa_votings, :ppa_regions, column: :region_id
  end
end
