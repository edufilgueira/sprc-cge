require 'rails_helper'

describe Operator::Reports::AttendanceReportsController do

  let(:user) { create(:user, :operator) }
  let(:attendance_report) { create(:attendance_report, user: user) }

  before { sign_in(user) }

  describe 'index' do
    before { get(:index) }

    it 'breadcrumbs' do
      expected = [
        { title: I18n.t('operator.home.index.title'), url: operator_root_path },
        { title: I18n.t('operator.reports.home.index.title'), url: operator_reports_root_path },
        { title: I18n.t('operator.reports.attendance_reports.index.title'), url: '' }
      ]

      expect(controller.breadcrumbs).to eq(expected)
    end
  end

  describe 'new' do
    before { get(:new) }

    it 'breadcrumbs' do
      expected = [
        { title: I18n.t('operator.home.index.title'), url: operator_root_path },
        { title: I18n.t('operator.reports.home.index.title'), url: operator_reports_root_path },
        { title: I18n.t("operator.reports.attendance_reports.index.title"), url: operator_reports_attendance_reports_path },
        { title: I18n.t('operator.reports.attendance_reports.new.title'), url: '' }
      ]

      expect(controller.breadcrumbs).to eq(expected)
    end
  end

  describe 'create' do
    before { post(:create, params: { attendance_report: { title: '' }}) }

    it 'breadcrumbs' do
      expected = [
        { title: I18n.t('operator.home.index.title'), url: operator_root_path },
        { title: I18n.t('operator.reports.home.index.title'), url: operator_reports_root_path },
        { title: I18n.t("operator.reports.attendance_reports.index.title"), url: operator_reports_attendance_reports_path },
        { title: I18n.t('operator.reports.attendance_reports.new.title'), url: '' }
      ]

      expect(controller.breadcrumbs).to eq(expected)
    end
  end

  describe 'show' do
    before { get(:show, params: { id: attendance_report }) }

    it 'breadcrumbs' do
      expected = [
        { title: I18n.t('operator.home.index.title'), url: operator_root_path },
        { title: I18n.t('operator.reports.home.index.title'), url: operator_reports_root_path },
        { title: I18n.t("operator.reports.attendance_reports.index.title"), url: operator_reports_attendance_reports_path },
        { title: attendance_report.title, url: '' }
      ]

      expect(controller.breadcrumbs).to eq(expected)
    end
  end

end
