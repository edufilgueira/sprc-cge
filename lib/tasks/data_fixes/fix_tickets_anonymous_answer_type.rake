namespace :data_fixes do

  # Corrige os tickets anonimos que estão com answer_type: nil
  task fix_tickets_anonymous_answer_type: :environment do
    Ticket.where(anonymous: true, answer_type: nil).update_all(answer_type: :default)
  end
end
