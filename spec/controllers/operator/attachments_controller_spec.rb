require 'rails_helper'

describe Operator::AttachmentsController do

  let(:user) { create(:user, :operator) }
  let(:ticket) { create(:ticket, created_by: user) }
  let(:attachmentable) { ticket }
  let(:attachment) { create(:attachment, attachmentable: attachmentable) }

  let(:valid_params) do
    {
      id: attachment,
      ticket_id: ticket
    }
  end

  context 'destroy' do
    context 'unauthorized' do
      before { delete(:destroy, params: valid_params) }

      it { is_expected.to redirect_to(new_user_session_path) }
    end

    context 'authorized' do
      before { sign_in(user) }

      context 'when attachment belongs to user' do
        it 'destroys' do
          attachment

          expect do
            delete(:destroy, params: valid_params)
            expect(controller).to set_flash.to(I18n.t('operator.attachments.destroy.done') % { title: attachment.title })
          end.to change(Attachment, :count).by(-1)
        end
      end

      context 'when attachment not belongs to user' do
        let(:ticket) { create(:ticket) }

        it 'does not destroys' do
          attachment

          expect do
            delete(:destroy, params: { id: attachment })
          end.to change(Attachment, :count).by(0)
        end
      end

      context 'redirect to ticket' do
        let(:ticket) { create(:ticket) }

        before { delete(:destroy, params: valid_params) }

        context 'when ticket attachment' do
          let(:ticket) { create(:ticket, created_by: user) }
          let(:attachmentable) { ticket }

          it { expect(response).to redirect_to(operator_ticket_path(ticket)) }
        end

        context 'when comment attachment' do
          let(:attachmentable) { create(:comment, author: user, commentable: ticket) }
          it { expect(response).to redirect_to(operator_ticket_path(ticket)) }
        end

        context 'when answer attachment' do
          let(:attachmentable) { create(:answer, user: user, ticket: ticket) }
          it { expect(response).to redirect_to(operator_ticket_path(ticket)) }
        end
      end

      context 'register ticket log' do
        let(:ticket) { create(:ticket) }

        before do
          allow(RegisterTicketLog).to receive(:call).with(anything, user, :destroy_attachment, anything)
          delete(:destroy, params: valid_params)
        end

        context 'when ticket attachment' do
          let(:ticket) { create(:ticket, created_by: user) }
          let(:attachmentable) { ticket }

          it { expect(RegisterTicketLog).to have_received(:call).with(ticket, user, :destroy_attachment, { data: { title: attachment.document_filename }}) }
        end

        context 'when comment attachment' do
          let(:attachmentable) { create(:comment, author: user, commentable: ticket) }
          it { expect(RegisterTicketLog).to have_received(:call).with(ticket, user, :destroy_attachment, { data: { title: attachment.document_filename }}) }
        end

        context 'when answer attachment' do
          let(:attachmentable) { create(:answer, user: user, ticket: ticket) }
          it { expect(RegisterTicketLog).to have_received(:call).with(ticket, user, :destroy_attachment, { data: { title: attachment.document_filename }}) }
        end

        context 'ticket with parent' do
          let(:ticket) { create(:ticket, :with_parent, created_by: user) }
          let(:attachmentable) { ticket }
          let(:parent) { ticket.parent }

          it { expect(RegisterTicketLog).to have_received(:call).with(parent, user, :destroy_attachment, { data: { title: attachment.document_filename }}) }
        end
      end
    end
  end
end
