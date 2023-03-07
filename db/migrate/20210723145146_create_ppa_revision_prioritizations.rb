class CreatePPARevisionPrioritizations < ActiveRecord::Migration[5.0]
  def change
    create_table :ppa_revision_prioritizations do |t|
      t.timestamps
      t.references :user, foreign_key: true
      t.references :plan, foreign_key: { to_table: :ppa_plans }
    end
  end
end
