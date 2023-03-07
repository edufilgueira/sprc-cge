class CreateMobileTags < ActiveRecord::Migration[5.0]
  def change
    create_table :mobile_tags do |t|
      t.string :name, null: false
    end
  end
end
