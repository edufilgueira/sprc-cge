class CreateSurveyAnswerExports < ActiveRecord::Migration[5.0]
  def change
    create_table :survey_answer_exports do |t|
      t.string :name
      t.datetime :start_at
      t.datetime :ends_at
      t.string :filename
      t.string :log
      t.integer :status
      t.integer :worksheet_format
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
