class RenameTablePrefixPagesToPage < ActiveRecord::Migration[5.0]
  def up
    rename_table :pages_charts, :page_charts
    rename_table :pages_series_data, :page_series_data
    rename_table :pages_series_items, :page_series_items

    rename_column :page_series_data, :pages_chart_id, :page_chart_id
    rename_column :page_series_items, :pages_series_datum_id, :page_series_datum_id
  end

  def down
    rename_table :page_charts, :pages_charts
    rename_table :page_series_data, :pages_series_data
    rename_table :page_series_items, :pages_series_items


    rename_column :page_series_data, :page_chart_id, :pages_chart_id
    rename_column :page_series_items, :page_series_datum_id, :pages_series_datum_id
  end
end
