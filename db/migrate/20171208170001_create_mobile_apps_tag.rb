class CreateMobileAppsTag < ActiveRecord::Migration[5.0]
  def change
    create_table :mobile_apps_tags do |t|
      t.references :mobile_app, foreign_key: true
      t.references :mobile_tag, foreign_key: true
    end
  end
end
