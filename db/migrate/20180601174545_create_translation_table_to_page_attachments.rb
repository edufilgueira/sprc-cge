class CreateTranslationTableToPageAttachments < ActiveRecord::Migration[5.0]
  def up
    Page::Attachment.create_translation_table!({
      title: :string
    }, {
      migrate_data: true,
      remove_source_columns: true
    })
  end

  def down
    Page::Attachment.drop_translation_table! migrate_data: true
  end
end
