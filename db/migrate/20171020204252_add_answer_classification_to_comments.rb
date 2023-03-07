class AddAnswerClassificationToComments < ActiveRecord::Migration[5.0]
  def change
    add_column :comments, :answer_classification, :integer
    add_column :comments, :certificate_id, :string
    add_column :comments, :certificate_filename, :string
  end
end
