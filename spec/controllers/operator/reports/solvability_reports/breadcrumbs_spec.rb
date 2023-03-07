require 'rails_helper'

describe Operator::Reports::SolvabilityReportsController do

  let(:user) { create(:user, :operator) }
  let(:solvability_report) { create(:solvability_report, user: user) }

  context 'index' do
    before { sign_in(user) && get(:index) }

    it 'breadcrumbs' do
      expected = [
        { title: I18n.t('operator.home.index.title'), url: operator_root_path },
        { title: I18n.t('operator.reports.home.index.title'), url: operator_reports_root_path },
        { title: I18n.t('operator.reports.solvability_reports.index.title'), url: '' }
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
        { title: I18n.t('operator.reports.solvability_reports.index.title'), url: operator_reports_solvability_reports_path },
        { title: I18n.t('operator.reports.solvability_reports.new.title'), url: '' }
      ]

      expect(controller.breadcrumbs).to eq(expected)
    end
  end

  context 'create' do
    let(:invalid_params) { { solvability_report: attributes_for(:solvability_report, :invalid) } }
    let(:ticket) { create(:ticket, :confirmed) }

    before { ticket && sign_in(user) && post(:create, params: invalid_params) }

    context 'helper methods' do
      it 'breadcrumbs' do
        expected = [
          { title: I18n.t('operator.home.index.title'), url: operator_root_path },
          { title: I18n.t('operator.reports.home.index.title'), url: operator_reports_root_path },
          { title: I18n.t('operator.reports.solvability_reports.index.title'), url: operator_reports_solvability_reports_path },
          { title: I18n.t('operator.reports.solvability_reports.create.title'), url: '' }
        ]

        expect(controller.breadcrumbs).to eq(expected)
      end
    end
  end

  context 'show' do
    before { sign_in(user) && get(:show, params: { id: solvability_report }) }

    it 'breadcrumbs' do
      expected = [
        { title: I18n.t('operator.home.index.title'), url: operator_root_path },
        { title: I18n.t('operator.reports.home.index.title'), url: operator_reports_root_path },
        { title: I18n.t('operator.reports.solvability_reports.index.title'), url: operator_reports_solvability_reports_path },
        { title: solvability_report.title, url: '' }
      ]

      expect(controller.breadcrumbs).to eq(expected)
    end
  end
end

