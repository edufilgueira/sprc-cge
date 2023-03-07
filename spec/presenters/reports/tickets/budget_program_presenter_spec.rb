require 'rails_helper'

describe Reports::Tickets::BudgetProgramPresenter do
  include ActionView::Helpers::NumberHelper

  let(:date) { Date.today }
  let(:ticket_report) { create(:ticket_report, filters: { ticket_type: :sic, confirmed_at: { start: date.beginning_of_month, end: date.end_of_month}, finalized: 1 }) }
  let(:scope) { ticket_report.filtered_scope }

  subject(:presenter) { Reports::Tickets::BudgetProgramPresenter.new(scope, ticket_report) }

  describe 'self.call' do
    it 'initialize' do
      allow(Reports::Tickets::BudgetProgramPresenter).to receive(:new)

      presenter

      expect(Reports::Tickets::BudgetProgramPresenter).to have_received(:new).with(scope, ticket_report)
    end
  end

  describe 'helpers' do
    context 'rows' do
      context 'when cge operator' do
        let(:organ_a) { create(:executive_organ, acronym: 'A') }
        let(:organ_b) { create(:executive_organ, acronym: 'B') }

        let(:budget_program_1) { create(:budget_program) }
        let(:budget_program_2) { create(:budget_program) }

        let(:scope) { Ticket.leaf_tickets }

        let(:row_1) do
          [
            organ_a.acronym,
            budget_program_1.name,
            1,
            number_to_percentage(20, precision: 2)
          ]
        end

        let(:row_2) do
          [
            organ_a.acronym,
            budget_program_2.name,
            1,
            number_to_percentage(20, precision: 2)
          ]
        end

        let(:row_3) do
          [
            organ_b.acronym,
            budget_program_2.name,
            1,
            number_to_percentage(20, precision: 2)
          ]
        end

        let(:row_4) do
          [
            organ_b.acronym,
            nil,
            1,
            number_to_percentage(20, precision: 2)
          ]
        end

        let(:row_5) do
          [
            nil,
            nil,
            1,
            number_to_percentage(20, precision: 2)
          ]
        end

        let(:expected) { [row_1, row_2, row_3, row_4, row_5] }

        before do
          ticket = create(:ticket, :with_parent, organ: organ_a)
          create(:classification, ticket: ticket, budget_program: budget_program_1)

          ticket = create(:ticket, :with_parent, organ: organ_a)
          create(:classification, ticket: ticket, budget_program: budget_program_2)

          ticket = create(:ticket, :with_parent, organ: organ_b)
          create(:classification, ticket: ticket, budget_program: budget_program_2)

          create(:ticket, :with_parent, organ: organ_b)

          create(:ticket, :confirmed)
        end

        it { expect(presenter.rows).to match_array(expected) }
      end

      context 'when sectoral operator' do
        let(:ticket_report) { create(:ticket_report, :sectoral) }
        let(:organ_a) { ticket_report.user.organ }
        let(:budget_program_1) { create(:budget_program, name: 'budget_program_1') }
        let(:row_1) do
          [
            budget_program_1.name,
            4,
            number_to_percentage(100, precision: 2)
          ]
        end
        let(:expected) { [row_1] }

        before do
          ticket = create(:ticket, :with_parent, organ: organ_a)
          create(:classification, ticket: ticket, budget_program: budget_program_1)

          reopened = create(:ticket, :with_parent, :with_reopen_and_log, reopened_at: Time.now, reopened_count: 2, organ: organ_a)
          create(:classification, ticket: reopened, budget_program: budget_program_1)
        end

        it 'array expected' do
          expect(presenter.rows).to match_array(expected)
        end
      end
    end
  end
end
