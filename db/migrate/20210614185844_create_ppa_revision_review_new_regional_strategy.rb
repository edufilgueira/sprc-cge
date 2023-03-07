class CreatePPARevisionReviewNewRegionalStrategy < ActiveRecord::Migration[5.0]
  def change
    create_table :ppa_revision_review_new_regional_strategies do |t|
      t.references :theme, foreign_key: true, index: true, foreign_key: { to_table: :ppa_themes }
      t.text :description
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
