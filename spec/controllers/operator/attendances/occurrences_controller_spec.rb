require 'rails_helper'

describe Operator::Attendances::OccurrencesController do
  let(:user) { create(:user, :operator) }
  let!(:attendance) { create(:attendance, :with_ticket) }

  let(:permitted_params) do
    [ :description ]
  end

  describe '#create' do
    let(:valid_occurrence) do
      attributes_for(:occurrence)
    end

    let(:invalid_occurrence) do
      attributes_for(:occurrence, :invalid)
    end

    let(:valid_params) do
      {
        occurrence: valid_occurrence,
        attendance_id: attendance.id
      }
    end

    let(:invalid_params) do
      {
        occurrence: invalid_occurrence,
        attendance_id: attendance.id
      }
    end


    context 'unauthorized' do
      before { post(:create, params: valid_params) }

      it { is_expected.to redirect_to(new_user_session_path) }
    end

    context 'authorized' do

      before { sign_in(user) }

      it 'permits params' do
        should permit(*permitted_params).
          for(:create, params:  valid_params ).on(:occurrence)
      end

      context 'valid' do
        it 'saves' do
          expect do
            post(:create, params: valid_params)

            expect(controller).to render_template('operator/attendances/_occurrences')

            expect(controller.occurrence.created_by).to eq(user)
            expect(controller.occurrence.attendance).to eq(attendance)

          end.to change(Occurrence, :count).by(1)
        end
        it 'register ticket log job' do
          allow(RegisterTicketLog).to receive(:call)

          post :create, params: valid_params
          occurrence = controller.occurrence

          data_attributes = {
            responsible_as_author: user.as_author
          }

          expect(RegisterTicketLog).to have_received(:call).
            with(attendance.ticket, user, :occurrence, { resource: occurrence, data: data_attributes })
        end
      end

      context 'invalid' do
        it 'does not save' do
          expect do
            post(:create, params: invalid_params)

            expect(controller).to render_template('_occurrences')

          end.to change(Occurrence, :count).by(0)
        end
      end

      describe 'helper methods' do
        before { post(:create, params: valid_params) }

        it 'attendance' do
          expect(controller.attendance).to eq(attendance)
        end

        it 'occurrence' do
          expect(controller.occurrence).to be_persisted
        end

        it 'new_occurrence' do
          expect(controller.new_occurrence).to be_new_record
        end
      end
    end
  end
end
