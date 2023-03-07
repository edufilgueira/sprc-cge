namespace :fix_duplicated_fb_users do
  desc "Task description"
  task update: :environment do
    users_id = User.user.joins("inner join users u on users.email = u.email").where('users.id != u.id AND u.deleted_at IS NULL').pluck('users.id', 'u.id')

    users_id = users_id.each { |ids| ids.sort! }.uniq

    users_id.each do |ids|
      user = User.find(ids[0])
      user2 = User.find(ids[1])

      next unless user.user? && user2.user?

      fb_user, acc_user = user.user_facebook? ? [user, user2] : [user2, user]

      acc_user.provider = fb_user.provider
      acc_user.uid = fb_user.uid

      acc_user.save(validate: false)


      Ticket.where(created_by_id: fb_user.id).update_all(created_by_id: acc_user.id)

      Ticket.where(updated_by_id: fb_user.id).update_all(updated_by_id: acc_user.id)

      TicketLog.where(responsible: fb_user).update_all(responsible_id: acc_user.id)

      Comment.where(author: fb_user).update_all(author_id: acc_user.id)

      fb_user.destroy

      p "Usuário #{acc_user.id} atualizado. Removido conta do facebook #{fb_user.id}"

    end
  end
end
