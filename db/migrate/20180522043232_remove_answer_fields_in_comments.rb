class RemoveAnswerFieldsInComments < ActiveRecord::Migration[5.0]
  def change
    remove_column :comments, :answer_type, :integer
    remove_column :comments, :answer_scope, :integer
    remove_column :comments, :answer_status, :integer
    remove_column :comments, :answer_classification, :integer
    remove_column :comments, :certificate_id, :string
    remove_column :comments, :certificate_filename, :string
    remove_column :comments, :answer_version, :integer
  end
end
