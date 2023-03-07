namespace :decree do
  task set_default_to_solicitation_on_extensions: :environment do
    Extension.in_batches(of: 1000).update_all(solicitation: 1)
  end

  task set_default_to_extended_second_time_on_tickets: :environment do
    Ticket.in_batches(of: 1000).update_all(extended_second_time: false)
  end
end
