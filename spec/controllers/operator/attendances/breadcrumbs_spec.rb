require 'rails_helper'

describe Operator::AttendancesController do

  let(:user) { create(:user, :operator_call_center_supervisor) }
  let(:attendance) { create(:attendance).reload }

  context 'index' do
    before { get(:index) }

    it 'breadcrumbs' do
      expected = [
        { title: I18n.t('operator.home.index.breadcrumb_title'), url: operator_root_path },
        { title: I18n.t('operator.attendances.index.title'), url: '' }
      ]

      expect(controller.breadcrumbs).to eq(expected)
    end
  end

  context 'show' do
    before { sign_in(user) && get(:show, params: { id: attendance }) }

    it 'breadcrumbs' do
      expected = [
        { title: I18n.t('operator.home.index.title'), url: operator_root_path },
        { title: I18n.t('operator.attendances.index.title'), url: operator_attendances_path },
        { title: I18n.t("operator.attendances.show.title", protocol: attendance.protocol), url: '' }
      ]

      expect(controller.breadcrumbs).to eq(expected)
    end
  end

  context 'edit' do
    before { sign_in(user) && get(:edit, params: { id: attendance }) }

    it 'breadcrumbs' do
      expected = [
        { title: I18n.t('operator.home.index.title'), url: operator_root_path },
        { title: I18n.t('operator.attendances.index.title'), url: operator_attendances_path },
        { title: I18n.t("operator.attendances.show.title", protocol: attendance.protocol), url: '' }
      ]

      expect(controller.breadcrumbs).to eq(expected)
    end
  end
end

