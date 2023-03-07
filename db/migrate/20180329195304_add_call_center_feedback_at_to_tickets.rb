class AddCallCenterFeedbackAtToTickets < ActiveRecord::Migration[5.0]
  def change
    add_column :tickets, :call_center_feedback_at, :datetime
  end
end
