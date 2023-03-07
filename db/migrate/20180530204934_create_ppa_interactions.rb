class CreatePPAInteractions < ActiveRecord::Migration[5.0]
  def change
    create_table :ppa_interactions do |t|
      t.integer :user_id,           null: false
      t.string  :type,              null: false
      t.string  :interactable_type, null: false
      t.integer :interactable_id,   null: false
      t.jsonb   :data,              default: {}

      t.timestamps
    end

    add_index :ppa_interactions, :user_id
    add_index :ppa_interactions, [:interactable_type, :interactable_id]
  end
end
