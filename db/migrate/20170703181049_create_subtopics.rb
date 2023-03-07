class CreateSubtopics < ActiveRecord::Migration[5.0]
  def change
    create_table :subtopics do |t|
      t.string :name
      t.references :topic, foreign_key: true, null: false
      t.datetime :deleted_at, index: true

      t.index [:name, :topic_id, :deleted_at], unique: true

      t.timestamps
    end
  end
end
