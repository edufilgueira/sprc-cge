require 'rails_helper'

describe Operator::Tickets::AttendanceEvaluationsController do

  let(:operator_cge) { create(:user, :operator_cge) }
  let(:ticket) { create(:ticket, :with_organ, :sic, :replied, internal_status: :final_answer) }

  let(:permitted_params) do
    [
      :clarity,
      :content,
      :wording,
      :kindness,
      :comment,
      :classification,
      :quality,
      :treatment,
      :textual_structure
    ]
  end

  describe '#create' do

    let(:valid_attendance_evaluation) { build(:attendance_evaluation, ticket: ticket) }
    let(:invalid_attendance_evaluation) do
      attendance_evaluation = valid_attendance_evaluation
      attendance_evaluation.clarity = nil
      attendance_evaluation
    end

    let(:valid_attendance_evaluation_params) { { ticket_id: ticket, attendance_evaluation: valid_attendance_evaluation.attributes } }
    let(:invalid_attendance_evaluation_params) { { ticket_id: ticket, attendance_evaluation: invalid_attendance_evaluation.attributes } }

    context 'unauthorized' do

      context 'not authenticated' do
        before { post(:create, xhr: true, params: valid_attendance_evaluation_params) }

        it { is_expected.to respond_with(:unauthorized) }
      end

      context 'authenticated not as operator_cge' do
        let(:operator_not_cge) { create(:user, :operator_sectoral) }

        before do
          sign_in(operator_not_cge)
          post(:create, xhr: true, params: valid_attendance_evaluation_params)
        end

        it { is_expected.to respond_with(:forbidden) }
      end

    end

    context 'authorized' do
      before { sign_in(operator_cge) }

      render_views

      context 'sou' do
        let(:sou_ticket) { create(:ticket, :replied, ticket_type: :sou) }
        let(:sou_attendance_evaluation) { build(:attendance_evaluation, ticket: sou_ticket) }

        it 'does not saves' do
          expect do
            post(:create, xhr: true, params: { ticket_id: sou_ticket, attendance_evaluation: sou_attendance_evaluation.attributes, format: :js })

            is_expected.to set_flash.now.to(I18n.t('operator.tickets.attendance_evaluations.create.error'))
          end.to change(AttendanceEvaluation, :count).by(0)
        end
      end

      context 'sic' do
        context 'not replied ticket' do
          let(:confirmed_ticket) { create(:ticket, :sic, :confirmed) }
          let(:confirmed_attendance_evaluation) { build(:attendance_evaluation, ticket: confirmed_ticket) }

          it 'does not saves' do
            expect do
              post(:create, xhr: true, params: { ticket_id: confirmed_ticket, attendance_evaluation: confirmed_attendance_evaluation.attributes })

              is_expected.to respond_with(:forbidden)
            end.to change(AttendanceEvaluation, :count).by(0)
          end
        end

        context 'replied ticket' do

          context 'internal_status not :final_answer' do
            let(:final_answer_ticket) { create(:ticket, :with_organ, :sic, :replied, internal_status: :partial_answer) }
            let(:final_answer_attendance_evaluation) { build(:attendance_evaluation, ticket: final_answer_ticket) }

            it 'does not saves' do
              expect do
                post(:create, xhr: true, params: { ticket_id: final_answer_ticket, attendance_evaluation: final_answer_attendance_evaluation.attributes })

                is_expected.to respond_with(:forbidden)
              end.to change(AttendanceEvaluation, :count).by(0)
            end
          end

          context 'internal_status :final_answer' do
            context 'valid' do
              it 'saves' do
                expect do
                  post(:create, xhr: true, params: valid_attendance_evaluation_params, format: :js)

                  is_expected.to set_flash.to(I18n.t('operator.tickets.attendance_evaluations.create.done'))
                  is_expected.not_to render_template('layouts/operator')
                end.to change(AttendanceEvaluation, :count).by(1)
              end
            end

            context 'invalid' do
              it 'does not saves' do
                expect do
                  post(:create, xhr: true, params: invalid_attendance_evaluation_params, format: :js)

                  is_expected.to set_flash.now.to(I18n.t('operator.tickets.attendance_evaluations.create.error'))
                  is_expected.not_to render_template('layouts/operator')
                end.to change(AttendanceEvaluation, :count).by(0)
              end
            end
          end
        end
      end
    end
  end

  describe '#update' do

    let(:valid_attendance_evaluation) { create(:attendance_evaluation, ticket: ticket) }
    let(:invalid_attendance_evaluation) do
      attendance_evaluation = valid_attendance_evaluation
      attendance_evaluation.clarity = nil
      attendance_evaluation
    end

    let(:valid_attendance_evaluation_params) { { ticket_id: ticket, id: valid_attendance_evaluation, attendance_evaluation: valid_attendance_evaluation.attributes } }
    let(:invalid_attendance_evaluation_params) { { ticket_id: ticket, id: valid_attendance_evaluation, attendance_evaluation: invalid_attendance_evaluation.attributes } }


    context 'unauthorized' do

      context 'not authenticated' do
        before { patch(:update, xhr: true, params: valid_attendance_evaluation_params) }

        it { is_expected.to respond_with(:unauthorized) }
      end

      context 'authenticated not as operator_cge' do
        let(:operator_not_cge) { create(:user, :operator_sectoral) }

        before do
          sign_in(operator_not_cge)
          patch(:update, xhr: true, params: valid_attendance_evaluation_params)
        end

        it { is_expected.to respond_with(:forbidden) }
      end

    end

    context 'authorized' do
      before { sign_in(operator_cge) }

      render_views

      context 'sic' do

        context 'not replied ticket' do
          let(:confirmed_ticket) { create(:ticket, :with_organ, :sic, :confirmed) }
          let(:confirmed_attendance_evaluation) { create(:attendance_evaluation, ticket: confirmed_ticket) }

          it 'does not saves' do
            patch(:update, xhr: true, params: { ticket_id: confirmed_ticket, id: confirmed_attendance_evaluation, attendance_evaluation: confirmed_attendance_evaluation.attributes })

            is_expected.to respond_with(:forbidden)
          end
        end

        context 'replied ticket' do

          context 'internal_status not :final_answer' do
            let(:final_answer_ticket) { create(:ticket, :with_organ, :sic, :replied, internal_status: :partial_answer) }
            let(:final_answer_attendance_evaluation) { create(:attendance_evaluation, ticket: final_answer_ticket) }

            it 'does not saves' do
              patch(:update, xhr: true, params: { ticket_id: final_answer_ticket, id: final_answer_attendance_evaluation, attendance_evaluation: final_answer_attendance_evaluation.attributes })

              is_expected.to respond_with(:forbidden)
            end
          end

          context 'internal_status :final_answer' do
            let(:final_answer_ticket) { create(:ticket, :with_organ, :sic, :replied, internal_status: :partial_answer) }
            
            it 'allowed params' do
              is_expected.to permit(*permitted_params).
              for(:update, xhr: true, params: valid_attendance_evaluation_params, format: :js )
            end

            context 'valid' do
              it 'saves' do
                patch(:update, xhr: true, params: valid_attendance_evaluation_params, format: :js)

                is_expected.to set_flash.to(I18n.t('operator.tickets.attendance_evaluations.update.done'))
                is_expected.not_to render_template('layouts/operator')
              end
            end

            context 'invalid' do
              it 'does not saves' do
                patch(:update, xhr: true, params: invalid_attendance_evaluation_params, format: :js)

                is_expected.to set_flash.now.to(I18n.t('operator.tickets.attendance_evaluations.update.error'))
                is_expected.not_to render_template('layouts/operator')
              end
            end
          end
        end
      end
    end
  end
end
