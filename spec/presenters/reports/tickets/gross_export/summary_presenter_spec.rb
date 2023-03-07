require 'rails_helper'

describe Reports::Tickets::GrossExport::SummaryPresenter do
  let(:date) { Date.today }
  let(:gross_export) { create(:gross_export, filters: { ticket_type: :sou, confirmed_at: { start: date.beginning_of_month, end: date.end_of_month} }) }
  let(:scope) { gross_export.filtered_scope }

  subject(:presenter) { Reports::Tickets::GrossExport::SummaryPresenter.new(scope, gross_export) }

  describe 'self.call' do
    it 'initialize' do
      allow(Reports::Tickets::GrossExport::SummaryPresenter).to receive(:new)

      presenter

      expect(Reports::Tickets::GrossExport::SummaryPresenter).to have_received(:new).with(scope, gross_export)
    end
  end

  describe 'helpers' do
    before do
      create(:ticket, :confirmed, :sic)
      create(:ticket, :confirmed, :in_sectoral_attendance)
      create(:ticket, :replied)
      create(:ticket, :confirmed, :with_reopen_and_log, confirmed_at: date, reopened_count: 2)
      create(:ticket, :confirmed, :with_subnet)
      create(:ticket, :confirmed, :invalidated)
      create(:ticket, :confirmed, :anonymous)

      other_organs = create(:ticket, :confirmed, :with_reopen_and_log)
      create(:classification, :other_organs, ticket: other_organs)

      create(:classification, :other_organs_invalidated).ticket
    end

    it { expect(presenter.name_report).to eq(I18n.t('presenters.reports.tickets.gross_export.summary.infos.name_report', name: gross_export.title)) }
    it { expect(presenter.created_by).to eq(I18n.t('presenters.reports.tickets.gross_export.summary.infos.created_by', name: gross_export.user.name)) }
    it { expect(presenter.created_at).to eq(I18n.t('presenters.reports.tickets.gross_export.summary.infos.created_at', date:  I18n.l(gross_export.created_at, format: :long))) }
    it { expect(presenter.creator_email).to eq(I18n.t('presenters.reports.tickets.gross_export.summary.infos.creator_email', email: gross_export.user.email)) }
    it { expect(presenter.operator_type).to eq(I18n.t('presenters.reports.tickets.gross_export.summary.infos.operator_type', operator_type: gross_export.user.operator_type_str)) }
    it { expect(presenter.tickets_count).to eq(I18n.t('presenters.reports.tickets.gross_export.summary.infos.tickets_count', count: scope.without_other_organs.count)) }
    it { expect(presenter.tickets_invalidate_count).to eq(I18n.t('presenters.reports.tickets.gross_export.summary.infos.tickets_invalidated_count', count: scope.invalidated.count)) }
    it { expect(presenter.tickets_other_organs_count).to eq(I18n.t('presenters.reports.tickets.gross_export.summary.infos.tickets_other_organs_count', count: 3)) }
    it { expect(presenter.tickets_reopened_count).to eq(I18n.t('presenters.reports.tickets.gross_export.summary.infos.reopened_at.sou', count: 2)) }

  end
end
