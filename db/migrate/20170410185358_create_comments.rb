class CreateComments < ActiveRecord::Migration[5.0]
  def change
    create_table :comments do |t|
      t.string :author
      t.text :description
      t.datetime :deleted_at, index: true
      t.references :commentable, polymorphic: true

      t.timestamps
    end
  end
end
