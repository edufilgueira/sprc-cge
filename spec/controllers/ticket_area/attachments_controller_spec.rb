require 'rails_helper'

describe TicketArea::AttachmentsController do

  let(:ticket) { create(:ticket) }
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

      it { is_expected.to redirect_to(new_ticket_session_path) }
    end

    context 'authorized' do
      before { sign_in(ticket) }

      context 'when attachment belongs to ticket' do
        it 'destroys' do
          attachment

          expect do
            delete(:destroy, params: valid_params)
            expect(controller).to set_flash.to(I18n.t('ticket_area.attachments.destroy.done') % { title: attachment.title })
          end.to change(Attachment, :count).by(-1)
        end
      end

      context 'when attachment not belongs to ticket' do
        let(:another_ticket) { create(:ticket) }

        it 'does not destroys' do
          another_ticket

          expect do
            delete(:destroy, params: { id: another_ticket })
          end.to change(Attachment, :count).by(0)
        end
      end

      context 'redirect to ticket' do
        before { delete(:destroy, params: valid_params) }

        context 'when ticket attachment' do
          it { expect(response).to redirect_to(ticket_area_ticket_path(ticket)) }
        end

        context 'when comment attachment' do
          let(:attachmentable) { create(:comment, author: ticket, commentable: ticket) }
          it { expect(response).to redirect_to(ticket_area_ticket_path(ticket)) }
        end
      end

      context 'register ticket log' do
        let(:ticket) { create(:ticket) }

        before do
          allow(RegisterTicketLog).to receive(:call).with(anything, ticket, :destroy_attachment, anything)
          delete(:destroy, params: valid_params)
        end

        context 'when ticket attachment' do
          it { expect(RegisterTicketLog).to have_received(:call).with(ticket, ticket, :destroy_attachment, { data: { title: attachment.document_filename }}) }
        end

        context 'when comment attachment' do
          let(:attachmentable) { create(:comment, author: ticket, commentable: ticket) }
          it { expect(RegisterTicketLog).to have_received(:call).with(ticket, ticket, :destroy_attachment, { data: { title: attachment.document_filename }}) }
        end
      end
    end
  end
end
