namespace :tickets do
  namespace :denunciation_type do
    desc "Adicionando para todos os tickets de denuncia o valor de denunciation_type como contra o Estado"

    task update: :environment  do |t|
      Ticket.unscoped.left_joins(:classification).where(
        sou_type: :denunciation
      ).where.not(
        internal_status: :invalidated
      ).where(
        'classifications.topic_id != 1434 OR classifications.topic_id IS NULL'
      ).where(
        'tickets.created_at >= ?', '2018-07-18'
      ).select('id').in_batches(of: 1000).each_with_index do |relation, batch_index|
        Ticket.where(id: relation.ids).update_all(denunciation_type: :against_the_state)
        p "#{(batch_index+1) * 1000}"
      end
    end
  end
end