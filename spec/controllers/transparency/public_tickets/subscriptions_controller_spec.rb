require 'rails_helper'

describe Transparency::PublicTickets::SubscriptionsController do

  let(:user) { create(:user, :user) }

  let(:ticket) { create(:ticket, :public_ticket) }
  let(:base_params) { { public_ticket_id: ticket.id } }

  let(:permitted_params) { [:email] }

  let(:nested_params) do
    { public_ticket_id: ticket.id }
  end

  let(:ticket_subscription) { create(:ticket_subscription, ticket: ticket, user: user, email: user.email) }

  describe '#new' do
    context 'with user' do
      before { sign_in(user) }

      context 'template' do
        before { get(:new, params: base_params) }
        render_views

        it { is_expected.to respond_with(:success) }
        it { is_expected.to render_template('transparency/public_tickets/subscriptions/new') }
        it { is_expected.to render_template('transparency/public_tickets/subscriptions/_form') }
      end
    end

    context 'helper method' do
      context 'with user' do
        before { sign_in(user) }

        context 'ticket_subscription' do
          it 'build new' do
            get(:new, params: base_params)

            expect(controller.ticket_subscription).to be_a_new(TicketSubscription)
            expect(controller.ticket_subscription.user).to eq(user)
            expect(controller.ticket_subscription.ticket).to eq(ticket)
          end

          it 'find created' do
            ticket_subscription = create(:ticket_subscription, ticket: ticket, user: user)

            get(:new, params: base_params)

            expect(controller.ticket_subscription).to eq(ticket_subscription)
          end
        end

        it 'email' do
          get(:new, params: base_params)

          expect(controller.email).to eq(user.email)
        end
      end

      context 'without user' do
        context 'ticket_subscription' do
          it 'build new' do
            get(:new, params: base_params)

            expect(controller.ticket_subscription).to be_a_new(TicketSubscription)
            expect(controller.ticket_subscription.user).to eq(nil)
            expect(controller.ticket_subscription.ticket).to eq(ticket)
          end
        end

        it 'email' do
          get(:new, params: base_params)

          expect(controller.email).to eq(nil)
        end

        it 'ticket' do
          get(:new, params: base_params)

          expect(controller.ticket).to eq(ticket)
        end
      end
    end
  end

  describe '#create' do
    let(:valid_params) do
      nested_params.merge(ticket_subscription: attributes_for(:ticket_subscription))
    end

    context 'with user' do
      before { sign_in(user) }
      let(:ticket_subscription) { create(:ticket_subscription, ticket: ticket, user: user, email: user.email) }

      let(:valid_params) do
        nested_params.merge(ticket_subscription: attributes_for(:ticket_subscription))
      end

      it 'permitted_params' do
        is_expected.to permit(*permitted_params).
        for(:create, params: valid_params).on(:ticket_subscription)
      end

      render_views

      context 'helper methods' do
        before { post(:create, params: valid_params) }

        it 'ticket_subscription' do
          expected_email = valid_params[:ticket_subscription][:email]

          expect(controller.ticket_subscription).to be_persisted
          expect(controller.ticket_subscription.user).to eq(user)
          expect(controller.ticket_subscription.ticket).to eq(ticket)
          expect(controller.ticket_subscription.token).not_to eq(nil)
          expect(controller.ticket_subscription.email).to eq(expected_email)
        end
      end

      context 'valid' do
        it 'saves' do
          expect do
            post(:create, params: valid_params)

            created = TicketSubscription.last

            expected_flash = I18n.t('transparency.public_tickets.subscriptions.create.done')

            expect(response).to redirect_to(transparency_public_ticket_path(ticket))
            is_expected.to set_flash.to(expected_flash)
          end.to change(TicketSubscription, :count).by(1)
        end

        it 'send email confirmation' do
          service = double
          allow(TicketMailer).to receive(:subscription_confirmation) { service }
          allow(service).to receive(:deliver_later)

          post(:create, params: valid_params)

          last_ticket_subscription = TicketSubscription.last

          expect(TicketMailer).to have_received(:subscription_confirmation).with(last_ticket_subscription.id)
          expect(service).to have_received(:deliver_later)
        end
      end

      context 'invalid' do
        render_views

        it 'does not save' do
          allow_any_instance_of(TicketSubscription).to receive(:valid?).and_return(false)

          expect do
            post(:create, params: valid_params)

            expected_flash = I18n.t('transparency.public_tickets.subscriptions.create.fail')

            is_expected.to render_template('transparency/public_tickets/subscriptions/new')
            is_expected.to set_flash.now[:alert].to(expected_flash)
          end.to change(TicketSubscription, :count).by(0)
        end
      end
    end

    context 'without user' do

      let(:valid_params) do
        nested_params.merge(ticket_subscription: { email: 'email@email.com'})
      end

      it 'permitted_params' do
        is_expected.to permit(*permitted_params).
        for(:create, params: valid_params).on(:ticket_subscription)
      end

      render_views

      context 'helper methods' do
        before { post(:create, params: valid_params) }

        it 'ticket_subscription' do
          expected_email = valid_params[:ticket_subscription][:email]

          created = TicketSubscription.last

          expect(created.user).to eq(nil)
          expect(created.ticket).to eq(ticket)
          expect(created.token).not_to eq(nil)
          expect(created.email).to eq(expected_email)
        end
      end

      context 'valid' do
        it 'saves' do
          expect do
            post(:create, params: valid_params)

            created = TicketSubscription.last

            expected_flash = I18n.t('transparency.public_tickets.subscriptions.create.done')

            expect(response).to redirect_to(transparency_public_ticket_path(ticket))
            is_expected.to set_flash.to(expected_flash)
          end.to change(TicketSubscription, :count).by(1)
        end

        it 'send email confirmation' do
          service = double
          allow(TicketMailer).to receive(:subscription_confirmation) { service }
          allow(service).to receive(:deliver_later)

          post(:create, params: valid_params)

          last_ticket_subscription = TicketSubscription.last

          expect(TicketMailer).to have_received(:subscription_confirmation).with(last_ticket_subscription.id)
          expect(service).to have_received(:deliver_later)
        end

        context 'when ticket_subscription was created' do
          it 'unconfirmed email' do
            unconfirmed_ticket_subscription = create(:ticket_subscription,:unconfirmed, ticket: ticket, user: nil, email: 'email@email.com')

            service = double
            allow(TicketMailer).to receive(:subscription_confirmation) { service }
            allow(service).to receive(:deliver_later)

            expect do
              post(:create, params: valid_params)

              expected_flash = I18n.t('transparency.public_tickets.subscriptions.create.was_created.unconfirmed')

              is_expected.to render_template('transparency/public_tickets/subscriptions/new')
              is_expected.to set_flash.now[:alert].to(expected_flash)
              expect(TicketMailer).to have_received(:subscription_confirmation).with(unconfirmed_ticket_subscription.id)
              expect(service).to have_received(:deliver_later)
            end.to change(TicketSubscription, :count).by(0)
          end

          it 'already following' do
            create(:ticket_subscription, :confirmed, ticket: ticket, user: nil, email: 'email@email.com')
            expect do
              post(:create, params: valid_params)

              expected_flash = I18n.t('transparency.public_tickets.subscriptions.create.was_created.already_following')

              is_expected.to render_template('transparency/public_tickets/subscriptions/new')
              is_expected.to set_flash.now[:alert].to(expected_flash)
            end.to change(TicketSubscription, :count).by(0)
          end
        end
      end

      context 'invalid' do
        render_views

        it 'does not save' do
          allow_any_instance_of(TicketSubscription).to receive(:valid?).and_return(false)

          expect do
            post(:create, params: valid_params)

            expected_flash = I18n.t('transparency.public_tickets.subscriptions.create.fail')

            is_expected.to render_template('transparency/public_tickets/subscriptions/new')
            is_expected.to set_flash.now[:alert].to(expected_flash)
          end.to change(TicketSubscription, :count).by(0)
        end
      end
    end
  end

  describe '#edit' do
    let(:valid_params) do
      {
        public_ticket_id: ticket.id,
        id: ticket_subscription.id
      }
    end

    context 'template' do
      before { sign_in(user) && get(:edit, params: valid_params) }
      render_views

      it { is_expected.to respond_with(:success) }
      it { is_expected.to render_template(:edit) }
    end
  end

  describe '#confirmation' do
    let(:ticket_subscription) { create(:ticket_subscription, :unconfirmed)}
    let(:valid_params) do
      {
        public_ticket_id: ticket_subscription.ticket.id,
        token: ticket_subscription.token
      }
    end

    it 'valid success' do
      get(:confirmation, params: valid_params)

      expected_flash = I18n.t('transparency.public_tickets.subscriptions.confirmation.done.sou', protocol: ticket_subscription.ticket.parent_protocol)

      ticket_subscription.reload

      expect(ticket_subscription.confirmed_email).to be_truthy
      expect(response).to redirect_to(transparency_public_ticket_path(ticket_subscription.ticket))
      is_expected.to set_flash.to(expected_flash)
    end

    it 'invalid token' do
      valid_params[:token] = 'invalide'
      get(:confirmation, params: valid_params)

      expected_flash = I18n.t('transparency.public_tickets.subscriptions.confirmation.fail')

      expect(response).to redirect_to(transparency_public_tickets_path)
      is_expected.to set_flash.to(expected_flash)
    end
  end

  describe '#unsubscribe' do
    let!(:ticket_subscription) { create(:ticket_subscription, :confirmed)}
    let(:ticket) { ticket_subscription.ticket }
    let(:valid_params) do
      {
        public_ticket_id: ticket_subscription.ticket.id,
        token: ticket_subscription.token
      }
    end

    it 'success' do
      expect do
        get(:unsubscribe, params: valid_params)

        expected_flash = I18n.t('transparency.public_tickets.subscriptions.unsubscribe.done.sou', protocol: ticket.parent_protocol)

        expect(response).to redirect_to(transparency_public_ticket_path(ticket))
        is_expected.to set_flash.to(expected_flash)
      end.to change(TicketSubscription, :count).by(-1)
    end

    it 'invalid token' do
      valid_params[:token] = 'invalide'
      get(:unsubscribe, params: valid_params)

      expected_flash = I18n.t('transparency.public_tickets.subscriptions.unsubscribe.fail')

      expect(response).to redirect_to(transparency_public_tickets_path)
      is_expected.to set_flash.to(expected_flash)
    end
  end
end
