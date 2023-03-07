class CreatePPAThemes < ActiveRecord::Migration[5.0]
  def change
    create_table :ppa_themes do |t|
      t.integer :axis_id,    null: false, index:true
      t.string  :code,       null: false
      t.string  :name,       null: false
      t.text    :description

      t.timestamps
    end

    add_foreign_key :ppa_themes, :ppa_axes, column: :axis_id
  end
end
