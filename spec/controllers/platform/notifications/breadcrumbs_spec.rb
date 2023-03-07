require 'rails_helper'

describe Platform::NotificationsController do

  let(:user) { create(:user, :user) }

  before { sign_in user }

  let(:notification) do
    Mailboxer::Notification.notify_all(user, 'subject', 'body')
    Mailboxer::Notification.last
  end

  describe 'index' do
    before { get(:index) }

    it 'breadcrumbs' do
      expected = [
        { title: I18n.t('app.home'), url: '/' },
        { title: I18n.t('shared.notifications.index.breadcrumb_title'), url: '' }
      ]

      expect(controller.breadcrumbs).to eq(expected)
    end
  end


  context 'show' do
    before { get :show, params: { id: notification } }

    it 'breadcrumbs' do
      expected = [
        { title: I18n.t('app.home'), url: '/' },
        { title: I18n.t("shared.notifications.index.breadcrumb_title"), url: platform_notifications_path },
        { title: notification.subject, url: '' }
      ]

      expect(controller.breadcrumbs).to eq(expected)
    end
  end

end
