require 'rails_helper'

describe Operator::Reports::StatsTicketsController do

  let(:user) { create(:user, :operator) }
  let(:stats_ticket) { create(:stats_ticket) }

  context 'index' do
    before { sign_in(user) && get(:index) }

    it 'breadcrumbs' do

      expected = [
        { title: I18n.t('operator.home.index.title'), url: operator_root_path },
        { title: I18n.t('operator.reports.home.index.title'), url: operator_reports_root_path },
        { title: I18n.t('operator.reports.stats_tickets.index.title'), url: '' },
      ]

      expect(controller.breadcrumbs).to eq(expected)
    end
  end

	context 'show' do
    before { sign_in(user) && get(:show, params: { id: stats_ticket }) }

    it 'breadcrumbs' do

      expected = [
        { title: I18n.t('operator.home.index.title'), url: operator_root_path },
        { title: I18n.t('operator.reports.home.index.title'), url: operator_reports_root_path },
        { title: I18n.t('operator.reports.stats_tickets.index.title'), url: operator_reports_stats_tickets_path },
        { title: I18n.t('operator.reports.stats_tickets.show.title'), url: '' }
      ]

      expect(controller.breadcrumbs).to eq(expected)
    end
  end
end
