class CreatePPARevisionEvaluation < ActiveRecord::Migration[5.0]
  def change
    create_table :ppa_revision_evaluations do |t|
      t.references :user, foreign_key: true
      t.references :plan, foreign_key: true, foreign_key: { to_table: :ppa_plans }

      t.column :question1, :integer
      t.column :question2, :integer
      t.column :question3, :integer
      t.column :question4, :integer
      t.column :question5, :integer
      t.column :question6, :integer
      t.column :question7, :integer
      t.column :question8, :integer
      t.column :question9, :integer
      t.column :question10, :integer

      t.column :observation, :text

      t.timestamps
    end
  end
end
