class AddLoadFlagsGrossExport < ActiveRecord::Migration[5.0]
  def change
    add_column :gross_exports, :load_creator_info, :boolean, default: false
  end
end
