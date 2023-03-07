class RenameInitiativeContributionsToInitiativeStrategies < ActiveRecord::Migration[5.0]
  def change
    rename_table :ppa_initiative_contributions, :ppa_initiative_strategies
  end
end
