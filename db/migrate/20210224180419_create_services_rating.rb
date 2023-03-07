class CreateServicesRating < ActiveRecord::Migration[5.0]
  def change
    create_table :services_ratings do |t|
      t.string :description
       t.timestamps
    end
  end
end
