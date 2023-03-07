class CreateTranslationTableToPageCharts < ActiveRecord::Migration[5.0]
  def up
    Page::Chart.create_translation_table!({
      title: :string,
      description: :text,
      unit: :string
    }, {
      migrate_data: true,
      remove_source_columns: true
    })
  end

  def down
    Page::Chart.drop_translation_table! migrate_data: true
  end
end
