class CreatePagesCharts < ActiveRecord::Migration[5.0]
  def change
    create_table :pages_charts do |t|
      t.string :title
      t.text :description
      t.string :unit

      t.references :page, foreign_key: true

      t.timestamps
    end
  end
end
