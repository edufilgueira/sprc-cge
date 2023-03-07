class CreateTranslationTableToSearchContents < ActiveRecord::Migration[5.0]
  def up
    SearchContent.create_translation_table!({
      title: :string,
      description: :text,
      content: :text
    }, {
      migrate_data: true,
      remove_source_columns: true
    })
  end

  def down
    SearchContent.drop_translation_table! migrate_data: true
  end
end

