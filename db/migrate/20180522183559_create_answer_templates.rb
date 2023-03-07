class CreateAnswerTemplates < ActiveRecord::Migration[5.0]
  def change
    create_table :answer_templates do |t|
      t.string :name
      t.text :content
      t.references :user

      t.timestamps
    end
  end
end
