namespace :data_fixes do

  # Rake para popular o campo data[:responsible_as_author] de ticket_log action: :confirm
  # dos tickets criados por operadores setoriais
  task add_created_by_ticket_log_confirm: :environment do
    TicketLog.confirm.joins('JOIN users on ticket_logs.responsible_id = users.id').where(responsible_type: 'User', data: nil, users: { user_type: User.user_types[:operator] }).find_each do |tl|
      tl.data[:responsible_as_author] = tl.responsible.as_author
      tl.save
    end
  end
end
