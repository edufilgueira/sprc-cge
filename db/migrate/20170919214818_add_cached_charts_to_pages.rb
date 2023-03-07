class AddCachedChartsToPages < ActiveRecord::Migration[5.0]
  def change
    add_column :pages, :cached_charts, :text
  end
end
