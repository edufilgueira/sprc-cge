require 'rails_helper'

describe Reports::Tickets::Evaluations::SummaryPresenter do
  let(:date) { Date.today }
  let(:date_range) { date.beginning_of_month..date.end_of_month }

  let(:evaluation_export) { create(:evaluation_export, filters: { ticket_type: :sic, confirmed_at: { start: date.beginning_of_month, end: date.end_of_month}}) }
  let(:scope) { Evaluation.joins(answer: [:ticket]).where(tickets: { id: evaluation_export.filtered_scope.ids }) }

  subject(:presenter) { Reports::Tickets::Evaluations::SummaryPresenter.new(scope) }

  describe 'self.call' do
    it 'initialize' do
      allow(Reports::Tickets::Evaluations::SummaryPresenter).to receive(:new)

      presenter

      expect(Reports::Tickets::Evaluations::SummaryPresenter).to have_received(:new).with(scope)
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

    context 'total_sou_count' do
      it { expect(presenter.scope_count).to eq(3) }
    end

    describe 'average questions' do
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
end
