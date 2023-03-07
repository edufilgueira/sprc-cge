class AddAnswersToTickets < ActiveRecord::Migration[5.0]
  def change
    add_column :tickets, :answer_twitter, :string
    add_column :tickets, :answer_facebook, :string
  end
end
