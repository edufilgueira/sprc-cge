require 'rails_helper'

describe Operator::Tickets::ExtensionsOrganController do

  let(:user) { create(:user, :operator_sectoral) }
  let(:ticket) { create(:ticket, :with_parent, organ: user.organ) }

  let(:permitted_params) { [:description] }

  describe "#new" do
    context 'unauthorized' do
      before { get(:new, params: { ticket_id: ticket }) }

      it { is_expected.to redirect_to(new_user_session_path) }
    end

    context 'authorized' do
      before { sign_in(user) && get(:new, params: { ticket_id: ticket }) }

      context 'template' do
        render_views

        it { is_expected.to respond_with(:success) }
        it { is_expected.to render_template(:new) }
      end

      describe 'helper methods' do
        it 'ticket' do
          expect(controller.ticket).to eq(ticket)
        end
        it 'extension' do
          expect(controller.extension).to be_new_record
        end
      end
    end
  end

  describe '#create' do

    let(:valid_extension) do
      extension_attributes = attributes_for(:extension)
      extension_attributes[:ticket] = ticket
      extension_attributes
    end

    let(:invalid_extension) { attributes_for(:extension, :invalid) }

    context 'unauthorized' do
      before do
        post(:create, params: { ticket_id: ticket })
      end

      it { is_expected.to redirect_to(new_user_session_path) }
    end

    context 'authorized' do
      before { sign_in(user) }

      render_views

      it 'permits extension params' do
        is_expected.to permit(*permitted_params).
          for(:create, params: { params: { ticket_id: ticket, extension: valid_extension } }).on(:extension)
      end

      context 'valid' do
        it 'saves' do
          expect do
            post(:create, params: { ticket_id: ticket, extension: valid_extension })

            ticket = controller.ticket
            expect(controller).to redirect_to(operator_ticket_path(ticket))
            expect(controller).to set_flash.to(I18n.t('operator.tickets.extensions_organ.create.done'))
          end.to change(Extension, :count).by(1)
        end

        it 'create relation with extension user' do
          user_chiefs = create_list(:user, 2, :operator_chief, organ: user.organ)

          post(:create, params: { ticket_id: ticket, extension: valid_extension })

          extension_created = controller.extension
          chiefs_involved = extension_created.extension_users.map(&:user)

          expect(chiefs_involved).to match_array user_chiefs
        end

        context 'when ticket already extended' do
          let(:ticket) { create(:ticket, :with_extension, organ: user.organ) }

          it 'create a new relation with a extension user for coordination' do
            user_coordinators = create_list(:user, 2, :operator_coordination, organ: user.organ)

            post(:create, params: { ticket_id: ticket, extension: valid_extension })

            extension_created = controller.extension
            coordinators_involved = extension_created.extension_users.map(&:user)

            expect(coordinators_involved).to match_array user_coordinators
          end
        end

        context 'subnet' do
          let(:user) { create(:user, :operator_subnet) }
          let(:ticket) { create(:ticket, :with_parent, :with_subnet, subnet: user.subnet) }

          it 'creates extension_user for subnet_chief' do
            user_chiefs = create_list(:user, 2, :operator_subnet_chief, subnet: user.subnet)

            post(:create, params: { ticket_id: ticket, extension: valid_extension })

            extension_created = controller.extension
            chiefs_involved = extension_created.extension_users.map(&:user)

            expect(chiefs_involved).to match_array user_chiefs
          end
        end

      end

      context 'invalid' do
        it 'does not saves' do
          expect do
            post(:create, params: { ticket_id: ticket, extension: invalid_extension })

            expect(controller).to render_template(:new)
            expect(controller).to set_flash.now.to(I18n.t('operator.tickets.extensions_organ.create.fail'))
          end.to change(Extension, :count).by(0)
        end
      end

      it 'ticket log job is called after save' do
        allow(RegisterTicketLog).to receive(:call)

        post(:create, params: { ticket_id: ticket, extension: valid_extension })

        extension = controller.extension
        data = { status: extension.status }
        expect(RegisterTicketLog).to have_received(:call).with(ticket.parent, user, :extension, { resource: extension, data: data, description: nil })
      end

      context 'notify' do
        it 'user' do
          service = double

          allow(Notifier::Extension).to receive(:delay) { service }
          allow(service).to receive(:call)

          post(:create, params: { ticket_id: ticket, extension: valid_extension })

          expect(service).to have_received(:call).with(controller.extension.id, user.id)
        end

        it 'chief' do
          service = double

          allow(Notifier::Extension::Chief).to receive(:delay) { service }
          allow(service).to receive(:call)

          post(:create, params: { ticket_id: ticket, extension: valid_extension })

          expect(service).to have_received(:call).with(controller.extension.id, user.id)
        end
      end
    end
  end

  describe '#update' do
    let(:extension) { create(:extension, ticket: ticket) }

    context 'unauthorized' do
      before do
        patch(:update, params: { ticket_id: ticket, id: extension.id })
      end

      it { is_expected.to redirect_to(new_user_session_path) }
    end

    context 'authorized' do
      before { sign_in(user) }

      render_views

      context 'valid' do
        it 'saves' do
          patch(:update, params: { ticket_id: ticket, id: extension.id })

          expected_flash = I18n.t('operator.tickets.extensions_organ.update.done')

          is_expected.to set_flash.to(expected_flash)
          is_expected.to redirect_to(operator_ticket_path(ticket))

          extension.reload

          expect(extension.cancelled?).to eq(true)
        end

        it 'ticket log after cancel' do
          allow(RegisterTicketLog).to receive(:call)

          post(:update, params: { ticket_id: ticket, id: extension.id })

          extension = controller.extension
          data = { status: extension.status }

          expect(RegisterTicketLog).to have_received(:call).with(ticket.parent, user, :extension, { resource: extension, data: data, description: nil })
        end
      end
    end
  end

  describe '#approve' do
    let(:extension) { create(:extension, :in_progress, ticket: ticket) }

    let(:valid_params) do
      {
        id: extension.id,
        ticket_id: ticket
      }
    end

    context 'when chief' do
      let(:user) { create(:user, :operator_chief) }

      before { sign_in(user) }

      context 'valid' do
        let(:register_ticket_log) { RegisterTicketLog }

        before do
          allow(register_ticket_log).to receive(:call)
          patch(:approve, params: valid_params)
          extension.reload
        end

        it 'update params' do
          expected_deadline = Holiday.next_weekday(Ticket.response_extension(:sou), ticket.confirmed_at)
          expected_deadline_ends = ticket.confirmed_at.to_date + expected_deadline

          expected_flash = I18n.t('operator.tickets.extensions_organ.approve.done')

          ticket.reload

          is_expected.to set_flash.to(expected_flash)
          is_expected.to render_template(nil)

          expect(extension.approved?).to be_truthy
          expect(ticket.deadline).to eq(expected_deadline)
          expect(ticket.deadline_ends_at).to eq(expected_deadline_ends)
        end

        it 'ticket log after approve' do
          extension = controller.extension
          data = { status: extension.status }

          expect(register_ticket_log).to have_received(:call).with(ticket.parent, user, :extension, { resource: extension, data: data, description: nil })
        end
      end
    end

    context 'when operator sectoral' do
      let(:user) { create(:user, :operator_sectoral) }

      before { sign_in(user) }

      it 'forbidden' do

        patch(:approve, params: valid_params)

        expect(extension.reload.in_progress?).to be_truthy
        is_expected.to respond_with(:forbidden)
      end
    end
  end

  describe '#reject' do
    let(:extension) { create(:extension, :in_progress, ticket: ticket) }
    let(:justification) { 'rejection justification' }

    let(:valid_params) do
      {
        id: extension.id,
        ticket_id: ticket,
        extension: {
          justification: justification
        }
      }
    end

    let(:invalid_params) do
      {
        id: extension.id,
        ticket_id: ticket,
        extension: {
          justification: ''
        }
      }
    end

    let(:permitted_params) { [:justification] }

    context 'when chief' do
      let(:user) { create(:user, :operator_chief) }

      before { sign_in(user) }

      it 'permitted params' do
        is_expected.to permit(*permitted_params).
          for(:reject, verb: :patch, params: { params: valid_params}).on(:extension)
      end

      context 'valid' do
        let(:register_ticket_log) { RegisterTicketLog }

        before do
          allow(register_ticket_log).to receive(:call)
          patch(:reject, params: valid_params)
          extension.reload
        end

        it 'update params' do
          expected_deadline = ticket.deadline

          expected_flash = I18n.t('operator.tickets.extensions_organ.reject.done')

          is_expected.to set_flash.to(expected_flash)
          is_expected.to render_template(nil)

          expect(extension.rejected?).to be_truthy
          expect(ticket.deadline).to eq(expected_deadline)
        end

        it 'ticket log after reject' do
          extension = controller.extension
          data = { status: extension.status }

          expect(register_ticket_log).to have_received(:call).with(ticket.parent, user, :extension, { resource: extension, data: data, description: justification })
        end
      end

      context 'invalid' do
        before { patch(:reject, params: invalid_params) }

        it 'does not saves' do
          extension = controller.extension

          expect(extension.errors[:justification]).to be_present
          expect(controller).to render_template('operator/tickets/_extension_alert')
        end
      end
    end

    context 'when operator sectoral' do
      let(:user) { create(:user, :operator_sectoral) }

      before { sign_in(user) }

      it 'forbidden' do
        patch(:reject, params: valid_params)

        expect(extension.reload.in_progress?).to be_truthy
        is_expected.to respond_with(:forbidden)
      end
    end
  end
end
