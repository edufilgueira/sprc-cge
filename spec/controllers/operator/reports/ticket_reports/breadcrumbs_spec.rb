require 'rails_helper'

describe Operator::Reports::TicketReportsController do

  let(:user) { create(:user, :operator) }
  let(:ticket_report) { create(:ticket_report, user: user) }

  context 'index' do
    before { sign_in(user) && get(:index) }

    it 'breadcrumbs' do
      expected = [
        { title: I18n.t('operator.home.index.title'), url: operator_root_path },
        { title: I18n.t('operator.reports.home.index.title'), url: operator_reports_root_path },
        { title: I18n.t('operator.reports.ticket_reports.index.title'), url: '' }
      ]

      expect(controller.breadcrumbs).to eq(expected)
    end
  end

  context 'new' do
    before { sign_in(user) && get(:new) }

    it 'breadcrumbs' do
      expected = [
        { title: I18n.t('operator.home.index.title'), url: operator_root_path },
        { title: I18n.t('operator.reports.home.index.title'), url: operator_reports_root_path },
        { title: I18n.t('operator.reports.ticket_reports.index.title'), url: operator_reports_ticket_reports_path },
        { title: I18n.t('operator.reports.ticket_reports.new.title'), url: '' }
      ]

      expect(controller.breadcrumbs).to eq(expected)
    end
  end

  context 'create' do
    let(:invalid_params) { { ticket_report: attributes_for(:ticket_report, :invalid) } }
    let(:ticket) { create(:ticket, :confirmed) }

    before { ticket && sign_in(user) && post(:create, params: invalid_params) }

    context 'helper methods' do
      it 'breadcrumbs' do
        expected = [
          { title: I18n.t('operator.home.index.title'), url: operator_root_path },
          { title: I18n.t('operator.reports.home.index.title'), url: operator_reports_root_path },
          { title: I18n.t('operator.reports.ticket_reports.index.title'), url: operator_reports_ticket_reports_path },
          { title: I18n.t('operator.reports.ticket_reports.create.title'), url: '' }
        ]

        expect(controller.breadcrumbs).to eq(expected)
      end
    end
  end

  context 'show' do
    before { sign_in(user) && get(:show, params: { id: ticket_report }) }

    it 'breadcrumbs' do
      expected = [
        { title: I18n.t('operator.home.index.title'), url: operator_root_path },
        { title: I18n.t('operator.reports.home.index.title'), url: operator_reports_root_path },
        { title: I18n.t('operator.reports.ticket_reports.index.title'), url: operator_reports_ticket_reports_path },
        { title: ticket_report.title, url: '' }
      ]

      expect(controller.breadcrumbs).to eq(expected)
    end
  end
end

