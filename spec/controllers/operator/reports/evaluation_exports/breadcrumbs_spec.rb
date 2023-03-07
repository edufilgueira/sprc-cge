require 'rails_helper'

describe Operator::Reports::EvaluationExportsController do

  let(:user) { create(:user, :operator) }
  let!(:ticket) { create(:ticket, :confirmed) }
  let(:evaluation_export) { create(:evaluation_export, user: user) }

  before { sign_in(user) }

  describe 'index' do
    before { get(:index) }

    it 'breadcrumbs' do
      expected = [
        { title: I18n.t('operator.home.index.title'), url: operator_root_path },
        { title: I18n.t('operator.reports.home.index.title'), url: operator_reports_root_path },
        { title: I18n.t('operator.reports.evaluation_exports.index.title'), url: '' }
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
        { title: I18n.t("operator.reports.evaluation_exports.index.title"), url: operator_reports_evaluation_exports_path },
        { title: I18n.t('operator.reports.evaluation_exports.new.title'), url: '' }
      ]

      expect(controller.breadcrumbs).to eq(expected)
    end
  end

  describe 'create' do
    before { post(:create, params: { evaluation_export: { title: '' }}) }

    it 'breadcrumbs' do
      expected = [
        { title: I18n.t('operator.home.index.title'), url: operator_root_path },
        { title: I18n.t('operator.reports.home.index.title'), url: operator_reports_root_path },
        { title: I18n.t("operator.reports.evaluation_exports.index.title"), url: operator_reports_evaluation_exports_path },
        { title: I18n.t('operator.reports.evaluation_exports.new.title'), url: '' }
      ]

      expect(controller.breadcrumbs).to eq(expected)
    end
  end

  describe 'show' do
    before { get(:show, params: { id: evaluation_export }) }

    it 'breadcrumbs' do
      expected = [
        { title: I18n.t('operator.home.index.title'), url: operator_root_path },
        { title: I18n.t('operator.reports.home.index.title'), url: operator_reports_root_path },
        { title: I18n.t("operator.reports.evaluation_exports.index.title"), url: operator_reports_evaluation_exports_path },
        { title: evaluation_export.title, url: '' }
      ]

      expect(controller.breadcrumbs).to eq(expected)
    end
  end

end
