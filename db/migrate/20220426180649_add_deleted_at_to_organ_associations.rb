class AddDeletedAtToOrganAssociations < ActiveRecord::Migration[5.0]
  def change
    add_column :organ_associations, :deleted_at, :datetime
    add_index :organ_associations, :deleted_at
  end
end
