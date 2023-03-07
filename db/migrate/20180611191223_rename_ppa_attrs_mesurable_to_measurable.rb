class RenamePPAAttrsMesurableToMeasurable < ActiveRecord::Migration[5.0]
  def change
    rename_column :ppa_metrics, :mesurable_type, :measurable_type
    rename_column :ppa_metrics, :mesurable_id,   :measurable_id
  end
end
