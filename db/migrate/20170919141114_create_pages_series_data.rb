class CreatePagesSeriesData < ActiveRecord::Migration[5.0]
  def change
    create_table :pages_series_data do |t|
      t.string :title
      t.integer :series_type
      t.references :pages_chart, foreign_key: true

      t.timestamps
    end
  end
end
