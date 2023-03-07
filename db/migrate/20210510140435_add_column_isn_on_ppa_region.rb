class AddColumnIsnOnPPARegion < ActiveRecord::Migration[5.0]
  def change
    add_column :ppa_regions, :isn, :integer
  end
end
