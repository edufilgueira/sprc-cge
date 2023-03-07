class AddColumnProblemSituationStrategyIdOnPPARevisionReviewNewRegionalStrategies < ActiveRecord::Migration[5.0]
  def change
    add_reference :ppa_revision_review_new_regional_strategies, :problem_situation_strategy, index: { name: 'index_new_regional_strategies_on_regional_strategy_id' }, foreign_key: { to_table: :ppa_revision_review_problem_situation_strategies }
  end
end
