class AddOriginalDescriptionToAnswers < ActiveRecord::Migration[5.0]
  def change
    add_column :answers, :original_description, :text
  end
end
