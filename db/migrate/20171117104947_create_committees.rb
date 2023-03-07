class CreateCommittees < ActiveRecord::Migration[5.0]
  def change
    create_table :committees do |t|
      t.string :name
      t.string :email
      t.integer :committee_type
      t.references :organ, foreign_key: true

      t.datetime :deleted_at, index: true

      t.timestamps
    end
  end
end
