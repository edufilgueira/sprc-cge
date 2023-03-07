class RemovePPASourceRegions < ActiveRecord::Migration[5.0]
  def change
    # movido para sprc-data @ PPA::Source::Region
    drop_table :ppa_source_regions
  end
end
