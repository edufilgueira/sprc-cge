class AddQuestion05ToEvaluations < ActiveRecord::Migration[5.0]
  def change
    add_column :evaluations, :question_05, :string, after: :question_04
  end
end
