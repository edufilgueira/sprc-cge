class ChangeAttachmentToPolymorphic < ActiveRecord::Migration[5.0]
  def change
    change_table :attachments do |t|
      t.remove_references :ticket, foreign_key: true
      t.references :attachmentable, polymorphic: true

    end
  end
end
