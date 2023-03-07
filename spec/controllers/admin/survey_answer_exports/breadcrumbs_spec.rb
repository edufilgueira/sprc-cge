require 'rails_helper'

describe Admin::SurveyAnswerExportsController do
  let(:user) { create(:user, :admin) }
  let(:survey_answer_export) { create(:survey_answer_export) }

  context 'index' do
    before { sign_in(user) && get(:index) }

    it 'breadcrumbs' do
      expected = [
        { title: I18n.t('admin.home.index.title'), url: admin_root_path },
        { title: I18n.t('admin.survey_answer_exports.index.title'), url: '' }
      ]

      expect(controller.breadcrumbs).to eq(expected)
    end
  end

  context 'new' do
    before { sign_in(user) && get(:new) }

    it 'breadcrumbs' do
      expected = [
        { title: I18n.t('admin.home.index.title'), url: admin_root_path },
        { title: I18n.t('admin.survey_answer_exports.index.title'), url: admin_survey_answer_exports_path },
        { title: I18n.t('admin.survey_answer_exports.new.title'), url: '' }
      ]

      expect(controller.breadcrumbs).to eq(expected)
    end
  end

  context 'create' do
    let(:invalid_params) { { survey_answer: attributes_for(:survey_answer_export, :invalid) } }

    before { sign_in(user) && post(:create, params: invalid_params) }

    context 'helper methods' do
      it 'breadcrumbs' do
        expected = [
          { title: I18n.t('admin.home.index.title'), url: admin_root_path },
          { title: I18n.t('admin.survey_answer_exports.index.title'), url: admin_survey_answer_exports_path },
          { title: I18n.t('admin.survey_answer_exports.create.title'), url: '' }
        ]

        expect(controller.breadcrumbs).to eq(expected)
      end
    end
  end

  context 'show' do
    before { sign_in(user) && get(:show, params: { id: survey_answer_export }) }

    it 'breadcrumbs' do
      expected = [
        { title: I18n.t('admin.home.index.title'), url: admin_root_path },
        { title: I18n.t('admin.survey_answer_exports.index.title'), url: admin_survey_answer_exports_path },
        { title: survey_answer_export.title, url: '' }
      ]

      expect(controller.breadcrumbs).to eq(expected)
    end
  end
end
