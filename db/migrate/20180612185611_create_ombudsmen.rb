class CreateOmbudsmen < ActiveRecord::Migration[5.0]
  def change
    create_table :ombudsmen do |t|
      t.string :title
      t.string :contact_name
      t.string :phone
      t.string :email
      t.string :address
      t.string :operating_hours
      t.integer :kind

      t.timestamps
    end
  end
end
