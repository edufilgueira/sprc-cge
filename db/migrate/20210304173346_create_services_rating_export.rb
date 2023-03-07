class CreateServicesRatingExport < ActiveRecord::Migration[5.0]
  def change
    create_table :services_rating_exports do |t|
      t.string :name
      t.datetime :start_at
      t.datetime :ends_at
      t.string :filename
      t.string :log
      t.integer :status
      t.integer :worksheet_format
      t.integer :user_id
      t.timestamps
    end
  end
end
