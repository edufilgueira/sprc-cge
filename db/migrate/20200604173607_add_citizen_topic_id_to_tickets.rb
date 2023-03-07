class AddCitizenTopicIdToTickets < ActiveRecord::Migration[5.0]
  def change
  	add_column :tickets, :citizen_topic_id, :integer
    add_index :tickets, :citizen_topic_id
  end
end
