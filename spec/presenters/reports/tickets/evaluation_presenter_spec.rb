require 'rails_helper'

describe Reports::Tickets::EvaluationPresenter do

  let(:date) { Date.today }
  let(:ticket_report) { create(:ticket_report, filters: { ticket_type: :sic, confirmed_at: { start: date.beginning_of_month, end: date.end_of_month}, finalized: 1 }) }
  let(:tickets) { ticket_report.filtered_scope }

  let(:scope) { Evaluation.joins(answer: [:ticket]).where(evaluation_type: [:sou, :call_center], tickets: { id: tickets.ids }) }

  subject(:presenter) { Reports::Tickets::EvaluationPresenter.new(scope) }

  describe 'self.call' do
    it 'initialize' do
      allow(Reports::Tickets::EvaluationPresenter).to receive(:new)

      presenter

      expect(Reports::Tickets::EvaluationPresenter).to have_received(:new).with(scope)
    end
  end

  describe 'helpers' do
    let(:ticket) { create(:ticket, :with_parent_sic, confirmed_at: date) }

    let(:answer_1) { create(:answer, ticket: ticket) }
    let(:answer_2) { create(:answer, ticket: ticket) }
    let(:answer_3) { create(:answer, ticket: ticket) }

    let!(:evaluation_1) { create(:evaluation, answer: answer_1, question_01_a: 4) }
    let!(:evaluation_2) { create(:evaluation, answer: answer_2, question_01_a: 2) }
    let!(:evaluation_3) { create(:evaluation, answer: answer_3, question_01_a: 1) }

    describe 'question_average' do
      it { expect(presenter.question_average(:question_01_a)).to eq(2.33) }
      it { expect(presenter.question_average(:question_01_b)).to eq(1) }
      it { expect(presenter.question_average(:question_01_c)).to eq(1) }
      it { expect(presenter.question_average(:question_01_d)).to eq(1) }
      it { expect(presenter.question_average(:question_02)).to eq(1) }
      it { expect(presenter.question_average(:question_03)).to eq(1) }
    end

    describe 'question_name' do
      it { expect(presenter.question_name(:question_01_a,:sic)).to eq(ActionController::Base.helpers.sanitize(I18n.t("shared.answers.evaluations.questions.sic.question_01_a.description"), tags: [])) }
      it { expect(presenter.question_name(:question_01_b,:sic)).to eq(ActionController::Base.helpers.sanitize(I18n.t("shared.answers.evaluations.questions.sic.question_01_b.description"), tags: [])) }
      it { expect(presenter.question_name(:question_01_c,:sic)).to eq(ActionController::Base.helpers.sanitize(I18n.t("shared.answers.evaluations.questions.sic.question_01_c.description"), tags: [])) }
      it { expect(presenter.question_name(:question_01_d,:sic)).to eq(ActionController::Base.helpers.sanitize(I18n.t("shared.answers.evaluations.questions.sic.question_01_d.description"), tags: [])) }
      it { expect(presenter.question_name(:question_02,:sic)).to eq(ActionController::Base.helpers.sanitize(I18n.t("shared.answers.evaluations.questions.sic.question_02.description"), tags: [])) }
      it { expect(presenter.question_name(:question_03,:sic)).to eq(ActionController::Base.helpers.sanitize(I18n.t("shared.answers.evaluations.questions.sic.question_03.description"), tags: [])) }
    end
  end
end
