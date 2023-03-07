class ChangeEvaluationExport < ActiveRecord::Migration[5.0]
  def change
    remove_column :evaluation_exports, :starts_at, :datetime
    remove_column :evaluation_exports, :ends_at, :datetime
    remove_column :evaluation_exports, :organ_id, :integer
    remove_column :evaluation_exports, :subnet_id, :integer

    add_column :evaluation_exports, :total, :integer
    add_column :evaluation_exports, :filename, :string
  end
end
