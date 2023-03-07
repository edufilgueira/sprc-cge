require 'rails_helper'

describe Platform::Answers::EvaluationsController do

  let(:user) { create(:user, :user) }
  let(:ticket) { create(:ticket, :with_parent, :replied) }
  let(:answer) { create(:answer, :final, ticket: ticket) }
  let!(:ticket_parent) do
    ticket_parent = ticket.parent
    ticket_parent.update_column(:created_by_id, user.id)
    ticket_parent
  end

  let(:permitted_params) do
    [
      :question_01_a,
      :question_01_b,
      :question_01_c,
      :question_01_d,
      :question_02,
      :question_03,
      :question_04,
      :question_05
    ]
  end

  context 'unauthorized' do
    let(:other_user) { create(:user, :user) }

    before { sign_in(other_user) }

    it 'other user' do
      expect do
        evaluation_attributes = attributes_for(:evaluation)

        post(:create, params: { answer_id: answer, evaluation: evaluation_attributes })

        expect(controller.evaluation.valid?).to be_truthy
      end.to change(Evaluation, :count).by(0)
    end
  end

  context 'authorized' do
    before { sign_in(user) }

    it 'permits evaluation params' do
      evaluation_attributes = attributes_for(:evaluation)
      valid_evaluation_attributes = { answer_id: answer.id, evaluation: evaluation_attributes }

      should permit(*permitted_params).
        for(:create, params: valid_evaluation_attributes ).on(:evaluation)
    end

    describe '#create' do

      let(:evaluation_attributes) { attributes_for(:evaluation) }

      it 'success' do
        expect do
          post(:create, params: { answer_id: answer, evaluation: evaluation_attributes })

          expect(controller.evaluation.valid?).to be_truthy
          expect(controller.evaluation.evaluation_type).to eq('sou')
          expect(controller.answer.user_evaluated?).to be_truthy
        end.to change(Evaluation, :count).by(1)
      end

      it 'register_log' do
        allow(RegisterTicketLog).to receive(:call)

        post(:create, params: { answer_id: answer, evaluation: evaluation_attributes })

        evaluation = Evaluation.joins(answer: :ticket).find_by(answers: { ticket_id: ticket.id })
        detail = { resource: evaluation, data: { organ_id: ticket.organ_id } }
        expect(RegisterTicketLog).to have_received(:call).with(ticket, user, :evaluation, detail)
        expect(RegisterTicketLog).to have_received(:call).with(ticket_parent, user, :evaluation, detail)
      end

      it 'validation fail' do
        expect do
          evaluation_attributes[:question_01_a] = nil

          post(:create, params: { answer_id: answer, evaluation: evaluation_attributes })

          expect(controller.evaluation.valid?).to be_falsey
          expect(controller.evaluation.errors[:question_01_a]).to be_present
          expect(controller.evaluation.errors[:question_01_b]).to be_blank
        end.to change(Evaluation, :count).by(0)
      end
    end
  end
end
