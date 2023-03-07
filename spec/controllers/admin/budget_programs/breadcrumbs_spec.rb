require 'rails_helper'

describe Admin::BudgetProgramsController do

  let(:user) { create(:user, :admin) }
  let(:budget_program) { create(:budget_program) }

  context 'index' do
    before { sign_in(user) && get(:index) }

    it 'breadcrumbs' do
      expected = [
        { title: I18n.t('admin.home.index.title'), url: admin_root_path },
        { title: I18n.t('admin.budget_programs.index.title'), url: '' }
      ]

      expect(controller.breadcrumbs).to eq(expected)
    end
  end

  context 'new' do
    before { sign_in(user) && get(:new) }

    it 'breadcrumbs' do
      expected = [
        { title: I18n.t('admin.home.index.title'), url: admin_root_path },
        { title: I18n.t('admin.budget_programs.index.title'), url: admin_budget_programs_path },
        { title: I18n.t('admin.budget_programs.new.title'), url: '' }
      ]

      expect(controller.breadcrumbs).to eq(expected)
    end
  end

  context 'create' do
    let(:invalid_params) { { budget_program: attributes_for(:budget_program, :invalid) } }

    before { sign_in(user) && post(:create, params: invalid_params) }

    context 'helper methods' do
      it 'breadcrumbs' do
        expected = [
          { title: I18n.t('admin.home.index.title'), url: admin_root_path },
          { title: I18n.t('admin.budget_programs.index.title'), url: admin_budget_programs_path },
          { title: I18n.t('admin.budget_programs.create.title'), url: '' }
        ]

        expect(controller.breadcrumbs).to eq(expected)
      end
    end
  end

  context 'show' do
    before { sign_in(user) && get(:show, params: { id: budget_program }) }

    it 'breadcrumbs' do
      expected = [
        { title: I18n.t('admin.home.index.title'), url: admin_root_path },
        { title: I18n.t('admin.budget_programs.index.title'), url: admin_budget_programs_path },
        { title: budget_program.title, url: '' }
      ]

      expect(controller.breadcrumbs).to eq(expected)
    end
  end

  context 'edit' do
    before { sign_in(user) && get(:show, params: { id: budget_program }) }

    it 'breadcrumbs' do
      expected = [
        { title: I18n.t('admin.home.index.title'), url: admin_root_path },
        { title: I18n.t('admin.budget_programs.index.title'), url: admin_budget_programs_path },
        { title: budget_program.title, url: '' }
      ]

      expect(controller.breadcrumbs).to eq(expected)
    end
  end

  context 'update' do
    let(:valid_params) { { id: budget_program.id, budget_program: budget_program.attributes } }

    before { sign_in(user) && patch(:update, params: valid_params) }

    it 'breadcrumbs' do
      expected = [
        { title: I18n.t('admin.home.index.title'), url: admin_root_path },
        { title: I18n.t('admin.budget_programs.index.title'), url: admin_budget_programs_path },
        { title: budget_program.title, url: '' }
      ]

      expect(controller.breadcrumbs).to eq(expected)
    end
  end
end
