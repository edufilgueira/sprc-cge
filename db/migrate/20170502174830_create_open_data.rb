class CreateOpenData < ActiveRecord::Migration[5.0]
  def change
    create_table :open_data do |t|
      t.string :document_id
      t.string :document_filename
      t.datetime :processed_at
      t.integer :status
      t.integer :kind

      t.timestamps
    end
  end
end
