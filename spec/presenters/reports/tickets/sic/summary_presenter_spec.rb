require 'rails_helper'

describe Reports::Tickets::Sic::SummaryPresenter do
  let(:date) { Date.today }
  let(:ticket_report) { create(:ticket_report, filters: { ticket_type: :sic, confirmed_at: { start: date.beginning_of_month, end: date.end_of_month}, finalized: 1 }) }
  let(:scope) { ticket_report.filtered_scope }


  subject(:presenter) { Reports::Tickets::Sic::SummaryPresenter.new(scope, ticket_report) }

  describe 'self.call' do
    it 'initialize' do
      allow(Reports::Tickets::Sic::SummaryPresenter).to receive(:new)

      presenter

      expect(Reports::Tickets::Sic::SummaryPresenter).to have_received(:new).with(scope, ticket_report)
    end
  end

  describe 'helpers' do

    before do
      # Criado fora do 155
      create(:ticket, :with_parent_sic)

      # Criado fora do 155 e finalizado
      create(:ticket, :with_parent_sic, :replied)

      # Criado pelo 155 e encaminhado
      create(:ticket, :with_parent_sic, :attendance)

      # Criado pelo 155, encaminhado e finalizado pelo órgão
      create(:ticket, :with_parent_sic, :attendance)

      # Criado pelo 155, enchaminhado e finalizado pelo 155
      ticket = create(:ticket, :with_parent_sic, :replied)
      create(:attendance, :sic_completed, ticket: ticket.parent)

      # Criado pelo 155 e finalizado sem encaminhar ao órgão
      ticket = create(:ticket, :sic, :confirmed)
      attendance = create(:attendance, :sic_completed, ticket: ticket)

      # Criad fora do 155 e reaberto
      create(:ticket, :sic, :with_reopen_and_log)
    end


    ## Scopo padrão: SIC

    it { expect(presenter.relevant_to_executive_count).to eq(7) }

    # Pelo atendente 155
    it { expect(presenter.call_center_sic_count).to eq(4) }

    # Pelo atendente 155 e encaminhado para um órgão
    it { expect(presenter.call_center_forwarded_count).to eq(2) }

    # Que não foram feitas pelo atendente 155
    it { expect(presenter.sic_without_attendance_count).to eq(3) }

    ## Finalizados

    # Pelo atendente 155
    it { expect(presenter.call_center_finalized_count).to eq(2) }

    # Que não foram feitas pelo atendente 155
    it { expect(presenter.finalized_without_call_center_count).to eq(1) }

    it { expect(presenter.reopened_count).to eq(1) }

    it { expect(presenter.relevant_to_executive_count_str).to eq(I18n.t('presenters.reports.tickets.sic.summary.relevant_to_executive_count', count: presenter.relevant_to_executive_count )) }
    it { expect(presenter.call_center_sic_count_str).to eq(I18n.t('presenters.reports.tickets.sic.summary.call_center_sic_count', count: presenter.call_center_sic_count )) }
    it { expect(presenter.call_center_forwarded_count_str).to eq(I18n.t('presenters.reports.tickets.sic.summary.call_center_forwarded_count', count: presenter.call_center_forwarded_count )) }
    it { expect(presenter.sic_without_attendance_count_str).to eq(I18n.t('presenters.reports.tickets.sic.summary.sic_without_attendance_count', count: presenter.sic_without_attendance_count )) }
    it { expect(presenter.call_center_finalized_count_str).to eq(I18n.t('presenters.reports.tickets.sic.summary.call_center_finalized_count', count: presenter.call_center_finalized_count )) }
    it { expect(presenter.finalized_without_call_center_count_str).to eq(I18n.t('presenters.reports.tickets.sic.summary.finalized_without_call_center_count', count: presenter.finalized_without_call_center_count )) }
    it { expect(presenter.reopened_count_str).to eq(I18n.t('presenters.reports.tickets.sic.summary.reopened_count', count: presenter.reopened_count)) }

  end
end
