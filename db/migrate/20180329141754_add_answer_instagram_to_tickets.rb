class AddAnswerInstagramToTickets < ActiveRecord::Migration[5.0]
  def change
    add_column :tickets, :answer_instagram, :string
  end
end
