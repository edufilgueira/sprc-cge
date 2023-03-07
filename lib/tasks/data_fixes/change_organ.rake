namespace :data_fixes do
  task change_organ: :environment do

    funece = Organ.find_by acronym: 'FUNECE'
    uece = Organ.find_by acronym: 'UECE'

    tickets = Ticket.where(organ: funece)

    tickets.each { |ticket| ticket.update organ: uece }
  end
end
