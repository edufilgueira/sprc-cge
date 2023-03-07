class CreatePagesSeriesItems < ActiveRecord::Migration[5.0]
  def change
    create_table :pages_series_items do |t|
      t.string :title
      t.decimal :value
      t.references :pages_series_datum, foreign_key: true

      t.timestamps
    end
  end
end
