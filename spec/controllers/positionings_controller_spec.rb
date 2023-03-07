require 'rails_helper'

describe PositioningsController do
  let(:ticket) { create(:ticket, :with_parent, :in_internal_attendance) }
  let(:ticket_department) { create(:ticket_department, ticket: ticket) }
  let(:department) { ticket_department.department }

  let(:ticket_department_email) { create(:ticket_department_email, ticket_department: ticket_department) }


  let(:valid_params) do
    {
      id: ticket_department_email.token,
      ticket_department_email: {
        answer_attributes: {
          description: 'Positioning'
        }
      }
    }
  end

  let(:invalid_params) do
    {
      id: ticket_department_email.token,
      ticket_department_email: {
        answer_attributes: {
          description: nil
        }
      }
    }
  end

  let(:permitted_params) do
    [
      answer_attributes: [
        :description,

        attachments_attributes: [
          :document
        ]
      ]
    ]
  end

  describe '#show' do
    before { get(:show, params: { id: ticket_department_email.token } ) }

    context 'template' do
      render_views

      it { is_expected.to respond_with(:success) }
      it { is_expected.to render_template(:show) }
    end

    describe 'helpers' do
      it 'ticket_department_email' do
        expect(controller.ticket_department_email).to eq(ticket_department_email)
      end
    end
  end

  describe '#edit' do

    context 'when ticket_department_email not active' do
      before do
        ticket_department_email.update_attributes(active: false)

        get(:edit, params: valid_params)
      end

      it { is_expected.to redirect_to positioning_path(ticket_department_email.token) }
    end

    context 'when ticket_department_email active' do
      before { get(:edit, params: valid_params) }
      context 'template' do
        render_views

        it { is_expected.to respond_with(:success) }
        it { is_expected.to render_template(:edit) }
      end

      describe 'helpers' do
        it 'ticket_department_email' do
          expect(controller.ticket_department_email).to eq(ticket_department_email)
          expect(controller.ticket_department_email.answer).to be_new_record
        end

        it 'ticket_department' do
          expect(controller.ticket_department).to eq(ticket_department)
        end
      end
    end

    context 'when ticket finalized' do
      let(:ticket) { create(:ticket, :with_parent, :replied) }

      before { get(:edit, params: valid_params) }

      it { is_expected.to redirect_to positioning_path(ticket_department_email.token) }
    end
  end

  describe '#update' do
    let(:other) { create(:ticket_department_email, ticket_department: ticket_department) }
    let(:answer) { ticket_department_email.reload.answer }

    context 'valid' do

      before { other }

      it 'permitted params' do
        should permit(*permitted_params).
          for(:update, params:  valid_params).on(:ticket_department_email)
      end

      context 'create positioning' do
        it 'when not subnet' do
          expect do
            patch(:update, params: valid_params)

            expected_flash = I18n.t("positionings.update.done")

            is_expected.to set_flash.to(expected_flash)
            is_expected.to redirect_to(positioning_path(ticket_department_email.token))

            expect(answer).to be_final
            expect(answer).to be_department
            expect(answer).to be_awaiting
          end.to change(Answer, :count).by(1)
        end

        it 'when subnet' do
          subnet = create(:subnet)
          organ = subnet.organ
          ticket.update_attributes(subnet: subnet, organ: organ)

          expect do
            patch(:update, params: valid_params)

            expect(answer).to be_subnet_department
          end.to change(Answer, :count).by(1)
        end
      end

      it 'update params' do
        patch(:update, params: valid_params)

        other.reload
        ticket_department_email.reload

        expect(ticket_department_email.active?).to be_falsey
        expect(other.active?).to be_falsey
      end

      it 'call service' do
        allow(Answer::CreationService).to receive(:call)

        patch(:update, params: valid_params)

        ticket_department_email.reload

        expect(Answer::CreationService).to have_received(:call).with(ticket_department_email.answer, ticket_department_email)
      end
    end

    context 'invalid' do
      it 'does not saves' do
        expect do
          allow(Answer::CreationService).to receive(:call)

          patch(:update, params: invalid_params)

          expected_flash = I18n.t("positionings.update.error")

          is_expected.to set_flash.now.to(expected_flash)
          expect(controller).to render_template(:edit)
          expect(Answer::CreationService).not_to have_received(:call)
        end.to change(Comment, :count).by(0)
      end
    end
  end
end

