require 'rails_helper'

describe Operator::AnswerTemplatesController do

  let(:user) { create(:user, :operator) }
  let(:answer_template) { create(:answer_template, user: user) }

  before { sign_in(user) }

  context 'index' do
    before { get(:index) }

    it 'breadcrumbs' do
      expected = [
        { title: I18n.t('operator.home.index.breadcrumb_title'), url: operator_root_path },
        { title: I18n.t('operator.answer_templates.index.title'), url: '' }
      ]

      expect(controller.breadcrumbs).to eq(expected)
    end
  end

  context 'new' do
    before { get(:new) }

    it 'breadcrumbs' do
      expected = [
        { title: I18n.t('operator.home.index.title'), url: operator_root_path },
        { title: I18n.t('operator.answer_templates.index.title'), url: operator_answer_templates_path },
        { title: I18n.t('operator.answer_templates.new.title'), url: '' }
      ]

      expect(controller.breadcrumbs).to eq(expected)
    end
  end

  context 'create' do
    let(:invalid_params) { { answer_template: attributes_for(:answer_template, :invalid) } }

    before { post(:create, params: invalid_params) }

    context 'helper methods' do
      it 'breadcrumbs' do
        expected = [
          { title: I18n.t('operator.home.index.title'), url: operator_root_path },
          { title: I18n.t('operator.answer_templates.index.title'), url: operator_answer_templates_path },
          { title: I18n.t('operator.answer_templates.create.title'), url: '' }
        ]

        expect(controller.breadcrumbs).to eq(expected)
      end
    end
  end

  context 'show' do
    before { get(:show, params: { id: answer_template }) }

    it 'breadcrumbs' do
      expected = [
        { title: I18n.t('operator.home.index.title'), url: operator_root_path },
        { title: I18n.t('operator.answer_templates.index.title'), url: operator_answer_templates_path },
        { title: answer_template.title, url: '' }
      ]

      expect(controller.breadcrumbs).to eq(expected)
    end
  end

  context 'edit' do
    before { get(:edit, params: { id: answer_template }) }

    it 'breadcrumbs' do
      expected = [
        { title: I18n.t('operator.home.index.title'), url: operator_root_path },
        { title: I18n.t('operator.answer_templates.index.title'), url: operator_answer_templates_path },
        { title: answer_template.title, url: '' }
      ]

      expect(controller.breadcrumbs).to eq(expected)
    end
  end

  context 'update' do
    let(:invalid_params) { { id: answer_template, answer_template: attributes_for(:answer_template, :invalid) } }

    before { patch(:update, params: invalid_params) }

    it 'breadcrumbs' do
      expected = [
        { title: I18n.t('operator.home.index.title'), url: operator_root_path },
        { title: I18n.t('operator.answer_templates.index.title'), url: operator_answer_templates_path },
        { title: invalid_params[:answer_template][:name], url: '' }
      ]

      expect(controller.breadcrumbs).to eq(expected)
    end
  end
end

