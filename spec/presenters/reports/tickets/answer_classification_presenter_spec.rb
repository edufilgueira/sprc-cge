require 'rails_helper'

describe Reports::Tickets::AnswerClassificationPresenter do
  let(:date) { Date.today }

  let(:ticket_report) { create(:ticket_report, filters: { ticket_type: :sou, confirmed_at: { start: date.beginning_of_month, end: date.end_of_month}, finalized: true }) }
  let(:scope) { ticket_report.filtered_scope }

  subject(:presenter) { Reports::Tickets::AnswerClassificationPresenter.new(scope, ticket_report) }

  describe 'self.call' do
    it 'initialize' do
      allow(Reports::Tickets::AnswerClassificationPresenter).to receive(:new)

      presenter

      expect(Reports::Tickets::AnswerClassificationPresenter).to have_received(:new).with(scope, ticket_report)
    end
  end

  describe 'helpers' do
    before do
      # Chamado reaberto pela segunda vez
      ticket = create(:ticket, :with_reopen_and_log, reopened_count: 2, answer_classification: :sou_demand_well_founded)

      # Segunda resposta (Primeira reabertura)
      create(:ticket_log, :with_final_answer, ticket: ticket)

      answer_2 = create(:ticket, :replied, answer_classification: :sou_demand_well_founded).answers.first
      answer_3 = create(:ticket, :replied, answer_classification: :sou_demand_unfounded).answers.first
      create(:ticket, :with_parent, :confirmed)

      answer_2.update(answer_type: :partial, classification: :sou_demand_well_founded)
      answer_3.update(answer_type: :final, classification: :sou_demand_unfounded)


      create(:answer, :approved_positioning, ticket: answer_3.ticket)
      create(:answer, :awaiting_subnet_department, ticket: answer_3.ticket)
    end

    it { expect(presenter.answer_classification_count('sou_demand_well_founded')).to eq(3) }

    it { expect(presenter.answer_classification_str(:sou_demand_well_founded)).to eq(Ticket.human_attribute_name("answer_classification.sou_demand_well_founded")) }

    it { expect(presenter.without_classification_count).to eq(2) }

    it { expect(presenter.classification_keys).to match_array(['sou_demand_unfounded', 'sou_demand_well_founded', nil])}
  end
end
