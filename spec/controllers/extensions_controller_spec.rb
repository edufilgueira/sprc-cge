require 'rails_helper'

describe ExtensionsController do
  let(:user) { create(:user, :operator_chief) }
  let(:extension) { create(:extension) }
  let(:extension_user) { create(:extension_user, user: user, extension: extension) }
  let(:ticket) { extension.ticket }
  let(:service) { double }
  let(:register_ticket_log) { RegisterTicketLog }

  before do
    allow(Notifier::Extension).to receive(:delay) { service }
    allow(service).to receive(:call)

    allow(register_ticket_log).to receive(:call)
  end

  describe '#show' do
    before { get(:show, params: { id: extension_user.token } ) }

    context 'template' do
      render_views

      it { is_expected.to respond_with(:success) }
      it { is_expected.to render_template(:show) }
    end

    describe 'helpers' do
      it 'extension' do
        expect(controller.extension).to eq(extension)
      end

      it 'extension_user' do
        expect(controller.extension_user).to eq(extension_user)
      end

      context 'ticket_log_rejected' do
        let(:data_in_progress) { { status: 'in_progress' } }
        let(:data_rejected) { { status: 'rejected' } }
        let!(:ticke_log_in_progress) { create(:ticket_log, resource: extension, action: :extension, data: data_in_progress) }
        let!(:ticke_log_rejected) { create(:ticket_log, resource: extension, action: :extension, data: data_rejected) }

        it 'return ticket log with justification of rejection' do
          extension.rejected!
          expect(controller.ticket_log_rejected).to eq(ticke_log_rejected)
        end
      end
    end
  end

  describe '#edit' do

    context 'when extension not in_progress' do
      before do
        extension.approved!
        get(:edit, params: { id: extension_user.token })
      end

      it { is_expected.to redirect_to extension_path(extension_user.token) }
    end

    context 'when extension in_progress' do
      before { get(:edit, params: { id: extension_user.token }) }
      context 'template' do
        render_views

        it { is_expected.to respond_with(:success) }
        it { is_expected.to render_template(:edit) }
      end

      describe 'helpers' do
        it 'extension' do
          expect(controller.extension).to eq(extension)
        end

        it 'ticket' do
          expect(controller.ticket).to eq(ticket)
        end
      end
    end
  end

  describe '#approve' do
    let(:extension) { create(:extension, :in_progress) }
    let(:user) { create(:user, :operator_chief) }
    let(:extension_user) { create(:extension_user, user: user, extension: extension) }

    let(:valid_params) do
      {
        id: extension_user.token,
        ticket_id: ticket
      }
    end

    context 'valid' do
      before do
        patch(:approve, params: valid_params)
        extension.reload
      end

      it 'update params' do
        expected_deadline = Holiday.next_weekday(Ticket.response_extension(:sou), ticket.confirmed_at)
        expected_deadline_ends = ticket.confirmed_at.to_date + expected_deadline

        expected_flash = I18n.t("extensions.approve.done")

        ticket.reload

        is_expected.to set_flash.to(expected_flash)
        is_expected.to redirect_to(extension_path(extension_user.token))

        expect(extension.approved?).to be_truthy
        expect(ticket.deadline).to eq(expected_deadline)
        expect(ticket.deadline_ends_at).to eq(expected_deadline_ends)
      end

      it 'notify' do
        expect(service).to have_received(:call).with(extension.id)
      end

      it 'ticket log after approve' do
        extension = controller.extension
        data = { status: extension.status }
        current_user = extension_user.user

        expect(register_ticket_log).to have_received(:call).with(ticket.parent, current_user, :extension, { resource: extension, data: data, description: nil })
      end
    end
  end

  describe '#reject' do
    let(:extension) { create(:extension, :in_progress) }
    let(:justification) { 'rejection justification' }

    let(:valid_params) do
      {
        id: extension_user.token,
        extension: {
          justification: justification
        }
      }
    end

    let(:invalid_params) do
      {
        id: extension_user.token,
        extension: {
          justification: ''
        }
      }
    end

    let(:permitted_params) { [:justification] }


    it 'permitted params' do
      should permit(*permitted_params).
        for(:reject, verb: :patch, params: valid_params).on(:extension)
    end

    context 'valid' do
      before do
        patch(:reject, params: valid_params)
        extension.reload
      end

      it 'update params' do
        expected_deadline = ticket.deadline

        expected_flash = I18n.t("extensions.reject.done")

        is_expected.to set_flash.to(expected_flash)
        is_expected.to redirect_to(extension_path(extension_user.token))

        expect(extension.rejected?).to be_truthy
        expect(ticket.deadline).to eq(expected_deadline)
      end

      it 'notify' do
        expect(service).to have_received(:call).with(extension.id)
      end

      it 'ticket log after approve' do
        extension = controller.extension
        data = { status: extension.status }
        current_user = extension_user.user

        expect(register_ticket_log).to have_received(:call).with(ticket.parent, current_user, :extension, { resource: extension, data: data, description: justification })
      end
    end

    context 'invalid' do
      before { patch(:reject, params: invalid_params) }

      it 'does not saves' do
        extension = controller.extension

        expect(extension.errors[:justification]).to be_present
        expect(controller).to render_template(:edit)
      end
    end
  end

end
