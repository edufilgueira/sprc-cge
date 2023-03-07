require 'rails_helper'

describe PPA::Admin::PlansController do
  let(:plan) { create :ppa_plan }

  before { @request.env['devise.mapping'] = Devise.mappings[:ppa_admin] }

  context 'index' do
    before { get :index }

    it 'breadcrumbs' do
      expected = [
        { title: I18n.t('ppa.admin.breadcrumbs.home.index.title'), url: ppa_admin_root_path },
        { title: I18n.t('ppa.admin.breadcrumbs.plans.index.title'), url: '' },
      ]

      expect(controller.breadcrumbs).to eq(expected)
    end
  end

  context 'new' do
    before { get(:new) }

    it 'breadcrumbs' do
      expected = [
        { title: I18n.t('ppa.admin.breadcrumbs.home.index.title'), url: ppa_admin_root_path },
        { title: I18n.t('ppa.admin.breadcrumbs.plans.index.title'), url: ppa_admin_plans_path },
        { title: I18n.t('ppa.admin.breadcrumbs.plans.new.title'), url: '' }
      ]

      expect(controller.breadcrumbs).to eq(expected)
    end
  end

  context 'show and edit' do
    [:show, :edit].each do |action|
      before { get action, params: {id: plan.id} }

      it 'breadcrumbs' do
        expected = [
          { title: I18n.t('ppa.admin.breadcrumbs.home.index.title'), url: ppa_admin_root_path },
          { title: I18n.t('ppa.admin.breadcrumbs.plans.index.title'), url: ppa_admin_plans_path },
          { title: plan.start_year.to_s, url: '' }
        ]

        expect(controller.breadcrumbs).to eq(expected)
      end
    end
  end
end
