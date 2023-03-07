class CreatePPARevisionReviewRegionalStrategy < ActiveRecord::Migration[5.0]
  def change
    create_table :ppa_revision_review_regional_strategies do |t|
      t.references :strategy, foreign_key: true, index: true, foreign_key: { to_table: :ppa_strategies }
      t.column :permanence, :boolean
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
