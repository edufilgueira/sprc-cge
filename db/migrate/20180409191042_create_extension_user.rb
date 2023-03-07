class CreateExtensionUser < ActiveRecord::Migration[5.0]
  def change
    create_table :extension_users do |t|
      t.references :extension, index: true
      t.references :user, index: true
      t.string :token, index: true

      t.timestamps
    end
  end
end
