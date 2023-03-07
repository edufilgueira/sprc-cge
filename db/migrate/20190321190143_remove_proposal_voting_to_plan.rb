class RemoveProposalVotingToPlan < ActiveRecord::Migration[5.0]
  def change
    remove_column :ppa_plans, :proposal_start_in, :date
    remove_column :ppa_plans, :proposal_end_in, :date
    remove_column :ppa_plans, :voting_start_in, :date
    remove_column :ppa_plans, :voting_end_in, :date
  end
end
