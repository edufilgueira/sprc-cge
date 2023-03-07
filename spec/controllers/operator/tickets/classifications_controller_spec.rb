require 'rails_helper'

describe Operator::Tickets::ClassificationsController do

  let(:organ) { create(:executive_organ) }
  let(:user) { create(:user, :operator_sectoral, organ: organ) }
  let(:ticket) { create(:ticket, :with_parent, internal_status: :sectoral_attendance, organ: organ) }

  let(:permitted_params) do
    [
      :topic_id,
      :subtopic_id,
      :department_id,
      :sub_department_id,
      :budget_program_id,
      :service_type_id,
      :other_organs
    ]
  end

  describe "#new" do

    context 'ticket parent' do

      let(:ticket_parent) { ticket.parent }

      context 'forbidden' do
        before { sign_in(user) && get(:new, params: { ticket_id: ticket_parent }) }

        it { expect(response).to respond_with_forbidden }
      end
    end

    context 'ticket child' do

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
          it 'javascript' do
            expected = 'views/operator/tickets/classifications/new'

            expect(controller.javascript).to eq(expected)
          end

          it 'classification' do
            expect(controller.classification).to be_new_record
          end

          it 'classification_other_organs' do
            topic = create(:topic, :other_organs)
            subtopic = create(:subtopic, :other_organs)
            service_type = create(:service_type, :other_organs)
            budget_program = create(:budget_program, :other_organs)

            expect(controller.classification_other_organs.topic).to eq(topic)
            expect(controller.classification_other_organs.subtopic).to eq(subtopic)
            expect(controller.classification_other_organs.service_type).to eq(service_type)
            expect(controller.classification_other_organs.budget_program).to eq(budget_program)
            expect(controller.classification_other_organs.department).to eq(nil)
            expect(controller.classification_other_organs.sub_department).to eq(nil)
          end
        end
      end

      context 'remote classification' do
        let(:ticket_confirmed) { create(:ticket, :with_parent) }
        let(:user) { create(:user, :operator_cge) }

        before do
          allow(controller).to receive(:render).and_call_original
          sign_in(user) && get(:new, xhr: true, params: { ticket_id: ticket_confirmed })
        end

        it 'classification in parent' do
          expect(response).to render_template('operator/tickets/classifications/_form')
          expect(controller).to have_received(:render) do |options|
            expect(options[:locals][:remote]).to be_truthy
          end
        end
      end
    end
  end

  describe '#create' do

    context 'ticket parent' do

      let(:ticket_parent) { ticket.parent }
      let(:valid_classification) { build(:classification, ticket: ticket_parent) }

      let(:valid_classification_params) { { ticket_id: ticket_parent, classification: valid_classification.attributes } }

      context 'forbidden' do
        before { sign_in(user) && post(:create, params: valid_classification_params) }

        it { expect(response).to respond_with_forbidden }
      end
    end

    context 'ticket child' do

      let(:valid_classification) { build(:classification, ticket: ticket) }
      let(:invalid_classification) do
        classification = build(:classification, ticket: ticket)
        classification.topic = nil
        classification
      end

      let(:valid_classification_params) { { ticket_id: ticket, classification: valid_classification.attributes } }
      let(:invalid_classification_params) { { ticket_id: ticket, classification: invalid_classification.attributes } }

      context 'unauthorized' do
        before { post(:create, params: valid_classification_params) }

        it { is_expected.to redirect_to(new_user_session_path) }
      end

      context 'authorized' do
        before { sign_in(user) }

        render_views

        it 'allowed params' do
          should permit(*permitted_params).
          for(:create, params: valid_classification_params ).on(:classification)
        end


        context 'valid' do
          it 'saves' do
            expect do
              post(:create, params: valid_classification_params)

              expected_flash = I18n.t('operator.tickets.classifications.create.done')

              is_expected.to redirect_to(operator_ticket_path(ticket, anchor: 'tabs-classification'))
              is_expected.to set_flash.to(expected_flash)
            end.to change(Classification, :count).by(1)
          end

          it 'saves with other_organs' do
            topic_other_organs = create(:topic, :other_organs)
            subtopic_other_organs = create(:subtopic, :other_organs)
            budget_program_other_organs = create(:budget_program, :other_organs)
            service_type_other_organs = create(:service_type, :other_organs)
            valid_classification_params[:classification]['other_organs'] = true
            valid_classification_params[:classification]['topic_id'] = nil
            valid_classification_params[:classification]['subtopic_id'] = nil
            valid_classification_params[:classification]['budget_program_id'] = nil
            valid_classification_params[:classification]['service_type_id'] = nil
            post(:create, params: valid_classification_params)

            expect(controller.classification.topic_id).to eq(topic_other_organs.id)
            expect(controller.classification.subtopic_id).to eq(subtopic_other_organs.id)
            expect(controller.classification.budget_program_id).to eq(budget_program_other_organs.id)
            expect(controller.classification.service_type_id).to eq(service_type_other_organs.id)
          end

          it 'register ticket log' do
            allow(RegisterTicketLog).to receive(:call)

            post(:create, params: valid_classification_params)

            classification = ticket.classification

            data_attributes = {
              items: {
                topic_name: classification.topic_name,
                subtopic_name: classification.subtopic_name,
                department_name: classification.department_name,
                sub_department_name: classification.sub_department_name,
                budget_program_name: classification.budget_program_name,
                service_type_name: classification.service_type_name
              }
            }

            expect(RegisterTicketLog).to have_received(:call).with(ticket, user, :create_classification, { resource: ticket, data: data_attributes })
            expect(RegisterTicketLog).to have_received(:call).with(ticket.parent, user, :create_classification, { resource: ticket, data: data_attributes })
          end

          context 'remote classification' do
            let(:ticket_confirmed) { create(:ticket, :with_parent) }
            let(:user) { create(:user, :operator_cge) }

            before do
              sign_in(user)
              post(:create, xhr: true, params: valid_classification_params)
            end

            it 'classification in parent' do
              expect(response).to render_template('operator/tickets/classifications/_show')
            end
          end
        end

        context 'invalid' do
          it 'does not saves' do
            expect do
              post(:create, params: invalid_classification_params)

              expected_flash = I18n.t('operator.tickets.classifications.create.fail')

              is_expected.to render_template(:new)
              is_expected.to set_flash.now[:alert].to(expected_flash)
            end.to change(Classification, :count).by(0)
          end
        end

      end
    end
  end

  describe "#edit" do

    context 'ticket parent' do

      let(:ticket_parent) { ticket.parent }

      let(:classification) { create(:classification, ticket: ticket_parent) }
      let(:classification_params) { { ticket_id: ticket_parent, id: classification } }

      context 'forbidden' do
        before { sign_in(user) && sign_in(user) && get(:edit, params: classification_params) }

        it { expect(response).to respond_with_forbidden }
      end
    end

    context 'ticket child' do

      let(:classification) { create(:classification, ticket: ticket) }
      let(:classification_params) { { ticket_id: ticket, id: classification } }

      context 'unauthorized' do
        before { get(:edit, params: classification_params) }

        it { is_expected.to redirect_to(new_user_session_path) }
      end

      context 'authorized' do
        before { sign_in(user) && get(:edit, params: classification_params) }

        context 'template' do
          render_views

          it { is_expected.to respond_with(:success) }
          it { is_expected.to render_template(:edit) }
        end

        context 'helper' do
          it 'javascript' do
            expected = 'views/operator/tickets/classifications/edit'

            expect(controller.javascript).to eq(expected)
          end
        end
      end
    end

    context 'remote classification' do
      let(:ticket_confirmed) { create(:ticket, :with_parent, :with_classification) }
      let(:user) { create(:user, :operator_cge) }

      before do
        allow(controller).to receive(:render).and_call_original
        sign_in(user) && get(:edit, xhr: true, params: { ticket_id: ticket_confirmed, id: ticket_confirmed.classification })
      end

      it 'classification in parent' do
        expect(response).to render_template('operator/tickets/classifications/_form')
        expect(controller).to have_received(:render) do |options|
          expect(options[:locals][:remote]).to be_truthy
        end
      end
    end
  end

  describe '#update' do

    context 'ticket parent' do

      let(:ticket_parent) { ticket.parent }
      let(:classification) { create(:classification, ticket: ticket_parent) }
      let(:valid_classification) { classification }

      let(:valid_classification_params) { { ticket_id: ticket_parent, id: valid_classification, classification: valid_classification.attributes } }

      context 'forbidden' do
        before { sign_in(user) && patch(:update, params: valid_classification_params) }

        it { expect(response).to respond_with_forbidden }
      end
    end

    context 'ticket child' do

      let(:classification) { create(:classification, ticket: ticket) }
      let(:valid_classification) { classification }
      let(:invalid_classification) do
        classification.topic = nil
        classification
      end

      let(:valid_classification_params) { { ticket_id: ticket, id: valid_classification, classification: valid_classification.attributes } }
      let(:invalid_classification_params) { { ticket_id: ticket, id: invalid_classification, classification: invalid_classification.attributes } }

      context 'unauthorized' do
        before { patch(:update, params: valid_classification_params) }

        it { is_expected.to redirect_to(new_user_session_path) }
      end

      context 'authorized' do
        before { sign_in(user) }

        context 'valid' do
          it 'saves' do
            patch(:update, params: valid_classification_params)

            is_expected.to redirect_to(operator_ticket_path(ticket, anchor: 'tabs-classification'))
            is_expected.to set_flash.to(I18n.t('operator.tickets.classifications.update.done'))
          end

          it 'set ticket.updated_by' do
            patch(:update, params: valid_classification_params)

            expect(ticket.reload.updated_by).to eq(user)
          end

          it 'register ticket log' do
            allow(RegisterTicketLog).to receive(:call)

            patch(:update, params: valid_classification_params)

            classification = ticket.classification

            data_attributes = {
              items: {
                topic_name: classification.topic_name,
                subtopic_name: classification.subtopic_name,
                department_name: classification.department_name,
                sub_department_name: classification.sub_department_name,
                budget_program_name: classification.budget_program_name,
                service_type_name: classification.service_type_name
              }
            }

            expect(RegisterTicketLog).to have_received(:call).with(ticket, user, :update_classification, { resource: ticket, data: data_attributes })
            expect(RegisterTicketLog).to have_received(:call).with(ticket.parent, user, :update_classification, { resource: ticket, data: data_attributes })
          end
        end

        context 'invalid' do
          it 'does not saves' do
            patch(:update, params: invalid_classification_params)

            expected_flash = I18n.t('operator.tickets.classifications.update.fail')

            is_expected.to render_template(:edit)
            is_expected.to set_flash.now[:alert].to(expected_flash)
          end
        end

      end
    end
  end

  describe '#show' do
    let(:ticket_confirmed) { create(:ticket, :with_parent, :with_classification) }
    let(:user) { create(:user, :operator_cge) }

    context 'authorized' do
      before do
        sign_in(user)
        get(:show, xhr: true, params: { ticket_id: ticket_confirmed, id: ticket_confirmed.classification })
      end

      render_views

      it 'remote' do
        is_expected.to render_template('operator/tickets/classifications/_show')
      end
    end
  end
end
