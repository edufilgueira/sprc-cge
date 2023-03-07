class AddOtherOrgansToTopics < ActiveRecord::Migration[5.0]
  def change
    add_column :topics, :other_organs, :boolean, default: false
  end
end
