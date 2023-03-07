class CreateCitizenComments < ActiveRecord::Migration[5.0]
  def change
    create_table :citizen_comments do |t|
      t.text :description, null: false
      t.references :ticket, foreign_key: true, null: false
      t.references :user, foreign_key: true, null: false

      t.timestamps
    end
  end
end
