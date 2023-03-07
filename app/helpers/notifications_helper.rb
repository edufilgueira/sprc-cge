module NotificationsHelper

  def read_or_unread_icon(notification, participant)
    notification.is_read?(participant) ? 'fa-envelope-open-o' : 'fa-envelope'
  end

end
