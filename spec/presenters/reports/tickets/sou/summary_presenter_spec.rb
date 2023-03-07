require 'rails_helper'

describe Reports::Tickets::Sou::SummaryPresenter do
  let(:date) { Date.today }
  let(:ticket_report) { create(:ticket_report, filters: { ticket_type: :sou, confirmed_at: { start: date.beginning_of_month, end: date.end_of_month}, finalized: true }) }
  let(:scope) { ticket_report.filtered_scope }

  subject(:presenter) { Reports::Tickets::Sou::SummaryPresenter.new(scope, ticket_report) }

  describe 'self.call' do
    it 'initialize' do
      allow(Reports::Tickets::Sou::SummaryPresenter).to receive(:new)

      presenter

      expect(Reports::Tickets::Sou::SummaryPresenter).to have_received(:new).with(scope, ticket_report)
    end
  end

  describe 'helpers' do
    before do
      create(:ticket, :confirmed, :sic)
      create(:ticket, :confirmed, :in_sectoral_attendance)
      create(:ticket, :replied)
      reopened = create(:ticket, :confirmed, :with_reopen_and_log, reopened_count: 2)

      create(:ticket, :confirmed, :with_subnet)
      create(:ticket, :confirmed, :invalidated)
      create(:ticket, :confirmed, :anonymous)

      other_organs = create(:classification, :other_organs).ticket
      # Does not count reopens for other organs
      create(:ticket_log, :reopened, ticket: other_organs)

      create(:classification, :other_organs_invalidated).ticket
    end

    # ignora:
    # - invalidadas
    # - clasificado como outros órgãos
    # - pai com filhos (nesse caso considera apenas os filhos)
    it { expect(presenter.valid_count).to eq(5) }

    # Mesma contagem de valid_count
    it { expect(presenter.relevant_to_executive_count).to eq(5) }

    # Mesma contagem de valid_count
    it { expect(presenter.relevant_to_executive_count).to eq(5) }

    # Considera invalidados
    it { expect(presenter.invalidated_count).to eq(2) }

    it { expect(presenter.other_organs_count).to eq(1) }
    it { expect(presenter.anonymous_count).to eq(1) }
    it { expect(presenter.total_count).to eq(8) }

    it { expect(presenter.reopened_count).to eq(2) }


    # Tempo médio de resposta (:responded_at - :confirmed_at) / total
    it 'average_time_answer' do
      responded_scope = scope.where.not(responded_at: nil)

      total_days = responded_scope.sum { |t| (t.responded_at.to_date - t.confirmed_at.to_date).to_i }
      average = total_days / responded_scope.count

      expect(presenter.average_time_answer).to eq(average)
    end

    it { expect(presenter.relevant_to_executive_count_str).to eq(I18n.t('presenters.reports.tickets.sou.summary.relevant_to_executive_count', count: presenter.relevant_to_executive_count)) }
    it { expect(presenter.invalidated_count_str).to eq(I18n.t('presenters.reports.tickets.sou.summary.invalidated_count', count: presenter.invalidated_count)) }
    it { expect(presenter.other_organs_count_str).to eq(I18n.t('presenters.reports.tickets.sou.summary.other_organs_count', count: presenter.other_organs_count)) }
    it { expect(presenter.anonymous_count_str).to eq(I18n.t('presenters.reports.tickets.sou.summary.anonymous_count', count: presenter.anonymous_count)) }
    it { expect(presenter.total_count_str).to eq(I18n.t('presenters.reports.tickets.sou.summary.total_count', count: presenter.total_count)) }
    it { expect(presenter.reopened_count_str).to eq(I18n.t('presenters.reports.tickets.sou.summary.reopened_count', count: presenter.reopened_count)) }
    it { expect(presenter.average_time_answer_str).to eq(I18n.t('presenters.reports.tickets.sou.summary.average_time_answer', count: presenter.average_time_answer)) }
  end
end
