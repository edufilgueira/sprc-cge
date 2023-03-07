class AddUserIdToPPAProposals < ActiveRecord::Migration[5.0]
  def change
    add_column :ppa_proposals, :user_id, :integer, index: true, foreign_key: :users
  end
end
