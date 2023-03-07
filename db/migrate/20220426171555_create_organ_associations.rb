class CreateOrganAssociations < ActiveRecord::Migration[5.0]
  def change
    create_table :organ_associations do |t|
      t.references :organ, foreign_key: true
      t.integer :organ_association_id

      t.timestamps
    end
  end
end
