require 'rails_helper'

describe Admin::NotificationsController do

  let(:user) { create(:user, :admin) }

  let(:notification) do
    Mailboxer::Notification.notify_all(user, 'subject', 'body')
    Mailboxer::Notification.last
  end

  let(:notification_read) do
    Mailboxer::Notification.notify_all(user, 'assunto', 'conteudo')
    notification = Mailboxer::Notification.last
    notification.mark_as_read(user)
    notification
  end

  describe '#index' do
    context 'behaviors' do
      before { notification; notification_read; } # garantindo que os recursos existam

      let!(:resources) { [notification_read, notification] } # deixando o array na ordem padrão (:created_at :desc)
      it_behaves_like 'controllers/admin/base/index'

      context 'authorized' do
        before { sign_in(user) } # necessário pois a collection resources é escopada em `current_user`
        let(:sort_columns) { [:subject, :created_at] }

        it_behaves_like 'controllers/base/index/paginated'
        it_behaves_like 'controllers/base/index/search'
        it_behaves_like 'controllers/base/index/sorted'
      end
    end

    context 'authorized' do
      before { sign_in(user) && get(:index) }

      context 'template' do
        render_views

        it { is_expected.to respond_with(:success) }
      end

      describe 'helper methods' do
        it 'notifications' do
          expect(controller.notifications).to eq([notification])
        end
      end

      describe 'filter' do
        it 'show_only_unread' do
          notification
          notification_read

          get(:index, params: { show_only_unread: true })

          expect(controller.notifications).to eq([notification])
        end
      end

      describe 'search' do
        it 'body' do
          notification
          notification_read

          get(:index, params: { search: 'coNt' })

          expect(controller.notifications).to eq([notification_read])
        end

        # os testes de search do model devem ser feitos direto em seu 'search'
        # -> spec/models/mailboxer/notification/search_spec.rb
      end
    end

    describe 'pagination' do
      it 'calls kaminari methods' do
        allow(Mailboxer::Notification).to receive(:page).and_call_original
        expect(Mailboxer::Notification).to receive(:page).and_call_original

        sign_in(user) && get(:index)

        # para poder chamar o page que estamos testando
        controller.notifications
      end
    end

  end

  describe '#show' do
    context 'unauthorized' do
      before { get(:show, params: { id: notification }) }

      it { is_expected.to redirect_to(new_user_session_path) }
    end

    context 'authorized' do
      before { sign_in(user) && get(:show, params: { id: notification }) }

      describe 'helper methods' do
        it 'notification' do
          expect(controller.notification).to eq(notification)
        end
      end

      describe 'marked as read' do
        it { expect(controller.notification.is_read?(user)).to be_truthy }
        it { is_expected.to respond_with(:success) }
        it { is_expected.to render_template('admin/notifications/show') }
      end
    end
  end

  describe '#update' do
    context 'unauthorized' do
      before { patch(:update, params: { id: notification }) }

      it { is_expected.to redirect_to(new_user_session_path) }
    end

     context 'authorized' do
      before { sign_in(user) && get(:update, params: { id: notification }) }

      describe 'marked as unread' do
        it { expect(controller.notification.is_unread?(user)).to be_truthy }
        it { is_expected.to redirect_to(admin_notifications_path) }
      end
    end

  end

end
