class CreatePPAInitiatives < ActiveRecord::Migration[5.0]
  def change
    create_table :ppa_initiatives do |t|
      t.string :name, null: false

      t.timestamps
    end
  end
end
