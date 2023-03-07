class CreateTranslationTableToPageSeriesItems < ActiveRecord::Migration[5.0]
  def up
    Page::SeriesItem.create_translation_table!({
      title: :string
    }, {
      migrate_data: true,
      remove_source_columns: true
    })
  end

  def down
    Page::SeriesItem.drop_translation_table! migrate_data: true
  end
end
