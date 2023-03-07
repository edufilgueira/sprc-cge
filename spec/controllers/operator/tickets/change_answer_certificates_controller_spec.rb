require 'rails_helper'

describe Operator::Tickets::ChangeAnswerCertificatesController do

  let(:user) { create(:user, :operator_chief) }

  let(:ticket) { create(:ticket, :with_parent_sic) }
  let(:answer) { create(:answer, ticket: ticket) }

  let(:resources) { [answer] + create_list(:answer, 1, ticket: ticket) }

  let(:tempfile) do
    file = Tempfile.new("new-certificate.png", Rails.root + "spec/fixtures")
    file.write('1')
    file.close
    file.open
    file
  end

  let(:new_certificate) { Rack::Test::UploadedFile.new(tempfile, "image/png") }

  let(:permitted_params) do
    [
      :certificate
    ]
  end

  let(:valid_params) do
    request_params.merge({
      answer: {
        certificate: new_certificate
      }
    })
  end

  let(:request_params) do
    {
      ticket_id: ticket
    }
  end

  it_behaves_like 'controllers/operator/base/edit' do

    let(:valid_params) do
      request_params.merge({
        id: answer,
        answer: {
          certificate: new_certificate
        }
      })
    end

    context 'authorized' do

      before { sign_in(user) }

      context 'helper methods' do
        let(:view_context) { controller.view_context }

        before { get(:edit, params: valid_params) }

        it 'ticket' do
          expect(view_context.ticket).to eq(ticket)
        end

        it 'answer' do
          expect(view_context.answer).to eq(answer)
        end
      end
    end
  end

  describe '#update' do
    let(:valid_params) do
      request_params.merge({
        id: answer,
        answer: {
          certificate: new_certificate
        }
      })
    end

    context 'unauthorized' do
      before { patch(:update, params: valid_params) }

      it { is_expected.to redirect_to(new_user_session_path) }
    end

    context 'authorized' do

      before { sign_in(user) }

      it 'permitted_params' do
        should permit(*permitted_params).
          for(:update, params: valid_params ).on(:answer)
      end

      context 'invalid' do
        render_views

        it 'does not save' do
          answer

          allow_any_instance_of(Answer).to receive(:valid?).and_return(false)

          patch(:update, params: valid_params)

          expected_flash = I18n.t("operator.tickets.change_answer_certificates.update.error")

          expect(response).to render_template(:edit)
          expect(controller).to set_flash.now.to(expected_flash)
        end
      end

      context 'valid' do
        it 'saves' do
          last_updated_at = Date.today - 4.days
          answer.update_attribute(:updated_at, last_updated_at)

          patch(:update, params: valid_params)

          updated = answer
          updated.reload

          expected_flash = I18n.t("operator.tickets.change_answer_certificates.update.done")

          expect(response).to redirect_to(operator_ticket_path(ticket))
          expect(updated.updated_at).not_to eq(last_updated_at)

          expect(controller).to set_flash.to(expected_flash)
        end


        it 'register ticket_log for attachments' do
          allow(RegisterTicketLog).to receive(:call)

          patch(:update, params: valid_params)

          expect(RegisterTicketLog).to have_received(:call).with(ticket, user, :change_answer_certificate, { resource: answer })
          expect(RegisterTicketLog).to have_received(:call).with(ticket.parent, user, :change_answer_certificate, { resource: answer })
        end
      end

      context 'helper methods' do
        it 'answer' do
          patch(:update, params: valid_params)

          expect(controller.view_context.answer).to eq(answer)
        end
      end
    end
  end
end
