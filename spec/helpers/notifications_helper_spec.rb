require 'rails_helper'

describe NotificationsHelper do

  let(:user) { create(:user) }
  let(:notification) do
    Mailboxer::Notification.notify_all(user, 'subject', 'body')
    Mailboxer::Notification.last
  end


  describe '#read_or_unread_icon' do
    it 'unread' do
      expect(read_or_unread_icon(notification, user)).to eq('fa-envelope')
    end

    it 'read' do
      notification.mark_as_read(user)
      expect(read_or_unread_icon(notification, user)).to eq('fa-envelope-open-o')
    end
  end

end
