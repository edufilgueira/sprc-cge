require 'rails_helper'

describe Mailboxer::Notification::Search do

  let(:user) { create(:user, :user) }

  let!(:notification) do
    receipt = Mailboxer::Notification.notify_all(user, 'subject', 'body')
    Mailboxer::Notification.find(receipt.notification_id)
  end

  let!(:another_notification) do
    receipt = Mailboxer::Notification.notify_all(user, 'assunto', 'conteudo')
    Mailboxer::Notification.find(receipt.notification_id)
  end

  describe 'subject' do
    it do
      notifications = Mailboxer::Notification.search('SuB')
      expect(notifications).to eq([notification])
    end
  end

  describe 'body' do
    it do
      notifications = Mailboxer::Notification.search('uDo')
      expect(notifications).to eq([another_notification])
    end
  end

end
