require 'rails_helper'

describe PPA::Admin::Plans::WorkshopsController do
  let(:plan)     { create :ppa_plan }
  let(:workshop) { create :ppa_workshop, plan: plan }

  before { @request.env['devise.mapping'] = Devise.mappings[:ppa_admin] }

  context 'index' do
    before { get :index, params: { plan_id: plan.id } }

    it 'breadcrumbs' do
      expected = [
        { title: I18n.t('ppa.admin.breadcrumbs.home.index.title'), url: ppa_admin_root_path },
        { title: I18n.t('ppa.admin.breadcrumbs.plans.index.title'), url: ppa_admin_plans_path },
        { title: plan.start_year.to_s, url: ppa_admin_plan_path(plan) },
        { title: I18n.t('ppa.admin.breadcrumbs.workshops.index.title'), url: '' }
      ]

      expect(controller.breadcrumbs).to eq(expected)
    end
  end

  context 'new' do
    before { get :new, params: { plan_id: plan.id } }

    it 'breadcrumbs' do
      expected = [
        { title: I18n.t('ppa.admin.breadcrumbs.home.index.title'), url: ppa_admin_root_path },
        { title: I18n.t('ppa.admin.breadcrumbs.plans.index.title'), url: ppa_admin_plans_path },
        { title: plan.start_year.to_s, url: ppa_admin_plan_path(plan) },
        { title: I18n.t('ppa.admin.breadcrumbs.workshops.index.title'), url: ppa_admin_plan_workshops_path(plan) },
        { title: I18n.t('ppa.admin.breadcrumbs.workshops.new.title'), url: '' }
      ]

      expect(controller.breadcrumbs).to eq(expected)
    end
  end

  [:show, :edit].each do |action|
    context action.to_s do
      before { get action, params: { plan_id: plan.id, id: workshop.id } }

      it 'breadcrumbs' do
        expected = [
          { title: I18n.t('ppa.admin.breadcrumbs.home.index.title'), url: ppa_admin_root_path },
          { title: I18n.t('ppa.admin.breadcrumbs.plans.index.title'), url: ppa_admin_plans_path },
          { title: plan.start_year.to_s, url: ppa_admin_plan_path(plan) },
          { title: I18n.t('ppa.admin.breadcrumbs.workshops.index.title'), url: ppa_admin_plan_workshops_path(plan) },
          { title: workshop.name, url: '' }
        ]

        expect(controller.breadcrumbs).to eq(expected)
      end
    end
  end
end
