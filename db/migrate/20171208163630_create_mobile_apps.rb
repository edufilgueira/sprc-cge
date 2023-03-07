class CreateMobileApps < ActiveRecord::Migration[5.0]
  def change
    create_table :mobile_apps do |t|
      t.string :name, null: false
      t.text :description
      t.string :link_apple_store
      t.string :link_google_play
      t.boolean :official
      t.string :icon_id
      t.string :icon_filename
    end
  end
end
