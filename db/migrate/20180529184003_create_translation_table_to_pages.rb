class CreateTranslationTableToPages < ActiveRecord::Migration[5.0]
  def up
    Page.create_translation_table!({
      title: :string,
      menu_title: :string,
      content: :text,
      cached_charts: :text
    }, {
      migrate_data: true,
      remove_source_columns: true
    })
  end

  def down
    Page.drop_translation_table! migrate_data: true
  end
end
