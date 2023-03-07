class CreateAnswers < ActiveRecord::Migration[5.0]
  def change
    create_table :answers do |t|
      t.integer :answer_type
      t.integer :answer_scope
      t.integer :status
      t.integer :classification
      t.text :description
      t.string :certificate_id
      t.string :certificate_filename
      t.integer :version, default: 0, null: false
      t.datetime :deleted_at, index: true
      t.references :ticket, index: true
      t.references :user, index: true

      t.timestamps
    end
  end
end
