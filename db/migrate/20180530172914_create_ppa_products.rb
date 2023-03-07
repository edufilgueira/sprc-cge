class CreatePPAProducts < ActiveRecord::Migration[5.0]
  def change
    create_table :ppa_products do |t|
      t.integer  :initiative_id, null: false
      t.string   :name,          null: false
      t.datetime :start_at
      t.datetime :end_at

      t.timestamps
    end

    add_index :ppa_products, :initiative_id
    add_foreign_key :ppa_products, :ppa_initiatives, column: :initiative_id
  end
end
