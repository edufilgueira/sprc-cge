class RenameAttrsWithMensurableToMesurableOnPPAMetrics < ActiveRecord::Migration[5.0]
  def change
    rename_column :ppa_metrics, :mensurable_type, :mesurable_type
    rename_column :ppa_metrics, :mensurable_id, :mesurable_id
  end
end
