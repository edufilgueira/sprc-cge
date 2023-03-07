class AddAnswerVersionToComments < ActiveRecord::Migration[5.0]
  def change
    add_column :comments, :answer_version, :integer, null: false, default: 0
  end
end
