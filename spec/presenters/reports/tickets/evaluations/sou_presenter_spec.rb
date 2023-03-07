require 'rails_helper'

describe Reports::Tickets::Evaluations::SouPresenter do
  let(:date) { Date.today }
  let(:date_range) { date.beginning_of_month..date.end_of_month }

  let(:beginning_date) { date.beginning_of_month }
  let(:end_date) { date.end_of_month }

  let(:evaluation_export) { create(:evaluation_export, filters: { ticket_type: :sou, confirmed_at: { start: beginning_date, end: end_date}}) }

  let(:default_scope) { evaluation_export.filtered_scope }

  subject(:presenter) { Reports::Tickets::Evaluations::SouPresenter.new(default_scope) }

  describe 'self.call' do
    it 'initialize' do
      allow(Reports::Tickets::Evaluations::SouPresenter).to receive(:new)

      presenter

      expect(Reports::Tickets::Evaluations::SouPresenter).to have_received(:new).with(default_scope)
    end
  end

  describe 'helpers' do
    context 'rows' do
      let!(:sic_ticket) do
        sic_ticket = create(:ticket, :confirmed, ticket_type: :sic)
        create(:answer, ticket: sic_ticket, evaluation: create(:evaluation, :sic))
        sic_ticket
      end

      let!(:sou_ticket) { create(:ticket, :confirmed, :replied, ticket_type: :sou) }
      let!(:evaluation) do
        evaluation = create(:evaluation, :sou)
        create(:answer, ticket: sou_ticket, evaluation: evaluation)
        evaluation
      end

      let(:row) do
        [
          evaluation.ticket.parent_protocol,
          evaluation.ticket.organ_acronym,
          I18n.l(evaluation.created_at, format: :date),
          evaluation.question_01_a,
          evaluation.question_01_b,
          evaluation.question_01_c,
          evaluation.question_01_d,
          evaluation.question_02,
          evaluation.question_03,
          evaluation.question_04,
          I18n.t("shared.answers.evaluations.questions.sou.question_05.#{evaluation.question_05}"),
          evaluation.average
        ]
      end

      before { row }

      it { expect(presenter.rows).to eq([row]) }
    end
  end
end
