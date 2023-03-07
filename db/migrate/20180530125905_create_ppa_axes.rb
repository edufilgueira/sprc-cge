class CreatePPAAxes < ActiveRecord::Migration[5.0]
  def change
    create_table :ppa_axes do |t|
      t.string :code, null: false
      t.string :name, null: false

      t.timestamps
    end
  end
end
