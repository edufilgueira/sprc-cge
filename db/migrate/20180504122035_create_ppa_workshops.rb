class CreatePPAWorkshops < ActiveRecord::Migration[5.0]
  def change
    create_table :ppa_workshops do |t|
      t.integer  :plan_id,           null: false
      t.string   :name,              null: false
      t.datetime :start_at,          null: false
      t.datetime :end_at,            null: false
      t.integer  :city_id,           null: false
      t.string   :address
      t.integer  :participants_count

      t.timestamps
    end
    add_index :ppa_workshops, :plan_id
    add_index :ppa_workshops, :city_id
    add_foreign_key :ppa_workshops, :ppa_plans, column: :plan_id
  end
end
