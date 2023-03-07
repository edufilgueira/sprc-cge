require 'rails_helper'

describe Operator::AnswersController do
  let(:organ) { create(:executive_organ) }
  let(:department) { create(:department, organ: organ) }
  let(:user) { create(:user, :operator_sectoral, organ: organ, acts_as_sic: true) }

  let(:permitted_params) do
    [
      :description,
      :ticket_id,
      :answer_scope,

      :answer_type,
      :status,
      :classification,
      :certificate,

      attachments_attributes: [
        :document
      ]
    ]
  end

  describe '#create' do
    let(:ticket) { create(:ticket, :with_parent, :with_classification, organ: organ, internal_status: :sectoral_attendance) }
    let(:parent) { ticket.parent }
    let(:inactive_ticket) { create(:ticket, :with_parent, :invalidated, parent: parent) }

    let(:valid_answer) do
      attributes = attributes_for(:answer).merge!(ticket_id)

      attributes[:classification] =  :sic_attended_personal_info

      attributes
    end

    let(:invalid_answer) do
      attributes_for(:answer, :invalid).merge!(ticket_id)
    end

    let(:ticket_id) do
      {
        ticket_id: ticket.id
      }
    end

    let(:valid_answer_params) do
      {
        answer: valid_answer
      }
    end

    before { inactive_ticket }


    context 'unauthorized' do
      before { post(:create, params: valid_answer_params) }

      it { is_expected.to redirect_to(new_user_session_path) }
    end

    context 'authorized' do

      before { sign_in(user) }

      it 'permits answer params' do
        should permit(*permitted_params).
          for(:create, params: valid_answer_params ).on(:answer)
      end

      context 'valid' do
        it 'creates a answer, assigning the user' do
          expect do
            post(:create, params: valid_answer_params)
          end.to change(Answer, :count).by(1)

          expect(response).to render_template('shared/tickets/_ticket_logs')

          created_answer = Answer.last
          expect(created_answer.user).to eq user
          expect(created_answer.version).to eq 0
        end

        context 'version' do

          context 'after reopen' do
            let(:ticket) { create(:ticket, :with_reopen, :with_classification, organ: organ) }
            it 'version 1' do
              expect do
                post(:create, params: valid_answer_params)
              end.to change(Answer, :count).by(1)

              expect(response).to render_template('shared/tickets/_ticket_logs')

              created_answer = Answer.last
              expect(created_answer.version).to eq 1
            end
          end

          context 'after appeal' do
            let(:ticket) { create(:ticket, :with_appeal, :with_reopen, :with_classification, organ: organ) }
            it 'version 1' do
              expect do
                post(:create, params: valid_answer_params)
              end.to change(Answer, :count).by(1)

              expect(response).to render_template('shared/tickets/_ticket_logs')

              created_answer = Answer.last
              expect(created_answer.version).to eq 1
            end
          end


        end

        context 'answer_type' do
          context 'when operator internal' do
            let(:user) { create(:user, :operator_internal, department: department, organ: department.organ) }
            let(:ticket_department) { create(:ticket_department, ticket: ticket, department: department) }

            context 'external' do
              let(:valid_answer_params) do
                valid_answer[:answer_type] = nil

                { answer: valid_answer }
              end

              before do
                ticket_department
                valid_answer[:answer_scope] = :department
                post(:create, params: valid_answer_params)
              end

              it { expect(controller.answer.final?).to be_truthy }
            end
          end
          context 'when operator subnet internal' do
            let(:user) { create(:user, :operator_subnet_internal, department: department, organ: department.organ) }
            let(:ticket_department) { create(:ticket_department, ticket: ticket, department: department) }

            context 'external' do
              let(:valid_answer_params) do
                valid_answer[:answer_type] = nil

                { answer: valid_answer }
              end

              before do
                ticket_department
                valid_answer[:answer_scope] = :subnet_department
                post(:create, params: valid_answer_params)
              end

              it { expect(controller.answer.final?).to be_truthy }
            end
          end

          context 'when operator sectoral' do
            let(:user) { create(:user, :operator_sectoral, organ: organ) }
            let(:valid_answer_params) do
              valid_answer[:answer_type] = :partial

              { answer: valid_answer }
            end

            before do
              valid_answer[:answer_scope] = :sectoral
              post(:create, params: valid_answer_params)
            end

            it { expect(controller.answer.partial?).to be_truthy }
          end
        end

        context 'require attachment when answer_type letter' do
          let(:tempfile) do
            file = Tempfile.new("test.png", Rails.root + "spec/fixtures")
            file.write('1')
            file.close
            file.open
            file
          end

          let(:attachment) { Rack::Test::UploadedFile.new(tempfile, "image/png") }

          before do
            ticket = create(:ticket, :with_parent, :with_classification, :answer_by_letter, organ: organ, internal_status: :sectoral_attendance)
            ticket_id[:ticket_id] = ticket.id
          end

          it 'saves' do
            valid_answer_params[:answer][:attachments_attributes] = {
              "1": {
                "document": attachment
              }
            }

            expect do
              post(:create, params: valid_answer_params)
            end.to change(Answer, :count).by(1)
          end

          context 'except when positioning by operator internal' do
            let(:user) { create(:user, :operator_internal, department: department, organ: department.organ) }
            let(:ticket_department) { create(:ticket_department, ticket_id: valid_answer_params[:answer][:ticket_id], department: department) }

            before do
              ticket_department
              valid_answer_params[:answer][:answer_scope] = :department
            end

            it { expect { post(:create, params: valid_answer_params) }.to change(Answer, :count).by(1) }
          end

          it 'invalid request attachment' do
            expect do
              post(:create, params: valid_answer_params)
            end.to change(Answer, :count).by(0)
          end

        end

        context 'require department_id when sectoral gives positioning' do
          let(:user) { create(:user, :operator_sectoral, organ: organ) }
          let(:valid_answer_params) do
            valid_answer[:answer_type] = :final
            valid_answer[:answer_scope] = :department

            { answer: valid_answer }
          end
          let(:department) { create(:department, organ: ticket.organ) }
          let!(:ticket_department) { create(:ticket_department, ticket: ticket, department: department) }

          it 'saves' do
            valid_answer_params[:answer][:department_id] = department.id

            expect do
              post(:create, params: valid_answer_params)
            end.to change(Answer, :count).by(1)
          end

          it 'invalid request' do
            expect do
              post(:create, params: valid_answer_params)
              expect(controller.answer.errors[:department_id]).to be_present
            end.to change(Answer, :count).by(0)
          end

        end
      end

      context 'invalid' do
        it 'does not save' do
          expect do
            post(:create, params: { answer: invalid_answer })

            expect(controller).to render_template('shared/tickets/_ticket_logs')

          end.to change(Answer, :count).by(0)
        end
      end

      context 'with existent attachment' do

        let(:existent_answer) { create(:answer, ticket: ticket) }
        let(:existent_attachment) { create(:attachment, attachmentable: existent_answer)}

        let(:valid_answer) do
          attributes = attributes_for(:answer, :with_classification).merge!(ticket_id)
          attributes
        end

        let(:valid_answer_params) do
          {
            clone_attachments: [ existent_attachment.id ],
            answer: valid_answer
          }
        end

        let(:created_answer) { Answer.last }

        context 'valid' do

          before do
            existent_attachment
          end

          it 'saves' do
            expect do
              post(:create, params: valid_answer_params)

              created_attachment = created_answer.attachments.first

              expect(created_attachment.document_id).to eq(existent_attachment.document_id)
              expect(created_attachment.document_filename).to eq(existent_attachment.document_filename)
            end.to change(Attachment, :count).by(1)
          end
        end
      end

      describe 'helper methods' do
        it 'answer' do
          expect(controller.answer).to be_new_record
        end

        context 'new_answer' do
          before { post(:create, params: valid_answer_params) }

          it { expect(controller.new_answer).to be_new_record }

          context 'when already approved internal positioning' do
            let(:approved_positioning) { create(:answer, :approved_positioning, ticket: ticket) }
            let(:rejected_positioning) { create(:answer, :rejected_positioning, ticket: ticket) }

            before do
              approved_positioning
              rejected_positioning
            end

            context 'when operator sectoral' do
              let(:user) { create(:user, :operator_sectoral) }

              it { expect(controller.new_answer.description).to eq(approved_positioning.description) }
            end

            context 'when operator cge' do
              let(:user) { create(:user, :operator_cge) }

              it { expect(controller.new_answer.description).to eq(nil) }
            end
          end

          context 'when has no approved internal positioning' do
            context 'when operator sectoral' do
              let(:user) { create(:user, :operator_sectoral) }

              it { expect(controller.new_answer.description).to eq(nil) }
            end
          end
        end

        it 'answer_form_url' do
          post(:create, params: valid_answer_params)

          expect(controller.answer_form_url).to eq([:operator, controller.new_answer])
        end

        context 'readonly?' do
          it { expect(controller.readonly?).to be_falsey }
        end

      end # helper methods

      it 'call service' do
        allow(Answer::CreationService).to receive(:call)

        post :create, params: valid_answer_params

        answer = controller.answer

        expect(Answer::CreationService).to have_received(:call).with(answer, user)
      end
    end
  end

  describe 'approve_answer' do
    let(:ticket) { create(:ticket, :with_parent, :with_classification, organ: organ, internal_status: :cge_validation) }
    let(:parent) { ticket.parent }
    let(:answer) { create(:answer, :awaiting_sectoral, ticket: ticket) }

    let(:permitted_params) do
      [
        :answer_type,
        :classification,
        :description,
        :justification
      ]
    end

    let(:valid_params) do
      {
        id: answer.id,
        ticket_id: parent.id,
        answer: {
          description: 'updated description',
          justification: 'justification'
        }
      }
    end

    let(:ticket_valid_params) do
      {
        id: answer.id,
        ticket_id: ticket.id,
        answer: {
          description: 'updated description'
        }
      }
    end

    context 'unauthorized' do
      before { patch(:approve_answer, params: valid_params) }

      it { is_expected.to redirect_to(new_user_session_path) }
    end

    context 'authorized' do
      let(:user) { create(:user, :operator_cge) }

      before { sign_in(user) }

      render_views

      context 'valid' do

        it 'permitted params' do
          should permit(*permitted_params).
            for(:approve_answer, verb: :patch, params: valid_params).on(:answer)
        end

        context 'template' do
          before { patch(:approve_answer, params: valid_params) }

          it { expect(controller).to render_template('shared/tickets/_ticket_logs') }
        end

        it 'call Answer::ApprovalService' do
          allow(Answer::ApprovalService).to receive(:call)

          patch(:approve_answer, params: valid_params)

          expect(Answer::ApprovalService).to have_received(:call).with(answer, user, 'justification')
        end

        context 'update params' do
          before do
            patch(:approve_answer, params: valid_params)

            answer.reload
          end

          it { expect(answer.description).to eq('updated description') }
        end

        context 'helper methods' do
          it 'answer' do
            patch(:approve_answer, params: valid_params)

            expect(controller.answer).to eq(answer)
          end
        end
      end
    end
  end

  describe 'reject_answer' do
    let(:ticket) { create(:ticket, :with_parent, :with_classification, organ: organ, internal_status: :cge_validation) }
    let(:parent) { ticket.parent }
    let(:answer) { create(:answer, :awaiting_sectoral, ticket: ticket) }

    let(:ticket_log_data) { { responsible_organ_id: organ.id } }
    let!(:ticket_log) { create(:ticket_log, action: :answer, resource: answer, ticket: ticket, data: ticket_log_data) }
    let!(:ticket_log_parent) { create(:ticket_log, action: :answer, resource: answer, ticket: parent, data: ticket_log_data) }

    let(:permitted_params) do
      [
        :answer_type,
        :classification,
        :description,
        :justification
      ]
    end

    let(:description) { 'updated description' }
    let(:justification) { 'rejection justification' }

    let(:valid_params) do
      {
        id: answer.id,
        ticket_id: parent.id,
        answer: {
          description: description,
          justification: justification
        }
      }
    end

    let(:invalid_params) do
      {
        id: answer.id,
        ticket_id: parent.id,
        answer: {
          description: description,
          justification: ''
        }
      }
    end


    context 'unauthorized' do
      before { patch(:reject_answer, params: valid_params) }

      it { is_expected.to redirect_to(new_user_session_path) }
    end

    context 'authorized' do
      let(:user) { create(:user, :operator_cge) }

      before { sign_in(user) }

      render_views

      context 'invalid' do
        it 'does not saves' do
          patch(:reject_answer, params: invalid_params)

          answer = controller.answer

          expect(answer.errors[:justification]).to be_present
          expect(controller).to render_template('shared/answers/_answer_awaiting')
        end
      end

      context 'valid' do
        it 'permitted params' do
          should permit(*permitted_params).
            for(:reject_answer, verb: :patch,  params: valid_params).on(:answer)
        end

        context 'template' do
          before { patch(:reject_answer, params: valid_params) }

          it { expect(controller).to render_template('shared/tickets/_ticket_logs') }
        end

        context 'update params' do
          before do
            ticket_log

            patch(:reject_answer, params: valid_params)

            answer.reload
          end

          it { expect(answer.description).to eq(description) }
          it { expect(answer.ticket_log.description).to eq(justification) }
        end

        it 'call Answer::RejectionService' do
          allow(Answer::RejectionService).to receive(:call)

          patch(:reject_answer, params: valid_params)

          expect(Answer::RejectionService).to have_received(:call).with(answer, user, justification)
        end

        context 'helper methods' do
          it 'answer' do
            patch(:reject_answer, params: valid_params)

            expect(controller.answer).to eq(answer)
          end

          it 'justification' do
            patch(:reject_answer, params: valid_params)

            expect(controller.justification).to eq(justification)
          end
        end
      end
    end
  end
end
