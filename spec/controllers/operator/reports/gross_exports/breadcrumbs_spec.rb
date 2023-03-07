require 'rails_helper'

describe Operator::Reports::GrossExportsController do

  let(:user) { create(:user, :operator) }
  let(:gross_export) { create(:gross_export, user: user) }

  before { sign_in(user) }

  describe 'index' do
    before { get(:index) }

    it 'breadcrumbs' do
      expected = [
        { title: I18n.t('operator.home.index.title'), url: operator_root_path },
        { title: I18n.t('operator.reports.home.index.title'), url: operator_reports_root_path },
        { title: I18n.t('operator.reports.gross_exports.index.title'), url: '' }
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
        { title: I18n.t("operator.reports.gross_exports.index.title"), url: operator_reports_gross_exports_path },
        { title: I18n.t('operator.reports.gross_exports.new.title'), url: '' }
      ]

      expect(controller.breadcrumbs).to eq(expected)
    end
  end

  describe 'create' do
    let(:ticket) { create(:ticket, :confirmed) }
    before { ticket && post(:create, params: { gross_export: { title: '' }}) }

    it 'breadcrumbs' do
      expected = [
        { title: I18n.t('operator.home.index.title'), url: operator_root_path },
        { title: I18n.t('operator.reports.home.index.title'), url: operator_reports_root_path },
        { title: I18n.t("operator.reports.gross_exports.index.title"), url: operator_reports_gross_exports_path },
        { title: I18n.t('operator.reports.gross_exports.new.title'), url: '' }
      ]

      expect(controller.breadcrumbs).to eq(expected)
    end
  end

  describe 'show' do
    before { get(:show, params: { id: gross_export }) }

    it 'breadcrumbs' do
      expected = [
        { title: I18n.t('operator.home.index.title'), url: operator_root_path },
        { title: I18n.t('operator.reports.home.index.title'), url: operator_reports_root_path },
        { title: I18n.t("operator.reports.gross_exports.index.title"), url: operator_reports_gross_exports_path },
        { title: gross_export.title, url: '' }
      ]

      expect(controller.breadcrumbs).to eq(expected)
    end
  end

end
