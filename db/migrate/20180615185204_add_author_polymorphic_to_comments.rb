class AddAuthorPolymorphicToComments < ActiveRecord::Migration[5.0]
  def change
    add_reference :comments, :author, polymorphic: true
  end
end
