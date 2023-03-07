require 'rails_helper'

RSpec.describe PPA::Revision::ReviewProblemSituationStrategiesController, type: :controller do

  let(:user) { create(:user) }
  let(:plan) { create(:ppa_plan, :revising) }
  let(:invalid_plan) { create(:ppa_plan, :revising) }
  let(:region) { create(:ppa_region) }



  context 'unauthorized' do
    before {
      get(:new, params: { plan_id: plan.id, region_code: region.code })
    }

    it { is_expected.to redirect_to(new_user_session_path) }
  end

  context 'plan_invalid' do
    before {
      get(:new, params: { plan_id: invalid_plan.id, region_code: region.code })
    }

    it { is_expected.to redirect_to(new_user_session_path) }
  end

  context 'authorized' do
     before { sign_in(user) }

    context 'new' do
      before {
        get(:new, params: { plan_id: plan.id, region_code: region.code })
      }

      render_views

      it 'response' do
        expect(response).to be_success
      end

      it 'views' do
        is_expected.to render_template('ppa/revision/review_problem_situation_strategies/new')
        is_expected.to render_template('ppa/revision/review_problem_situation_strategies/multisteps/_region')
        is_expected.to render_template('ppa/revision/review_problem_situation_strategies/multisteps/_revision')
        is_expected.to render_template('ppa/revision/review_problem_situation_strategies/multisteps/_theme')
        is_expected.to render_template('ppa/revision/review_problem_situation_strategies/_multistep_form_new')
        is_expected.to render_template('ppa/revision/review_problem_situation_strategies/_multistep_flow')
        is_expected.to render_template('ppa/revision/review_problem_situation_strategies/multisteps/revision/_new_problem_situation')
        is_expected.to render_template('ppa/revision/review_problem_situation_strategies/multisteps/revision/_problem_situation')
        is_expected.to render_template('ppa/revision/review_problem_situation_strategies/multisteps/revision/_new_regional_strategy')
        is_expected.to render_template('ppa/revision/review_problem_situation_strategies/multisteps/revision/_regional_strategy')
        is_expected.to render_template('ppa/revision/review_problem_situation_strategies/multisteps/revision/_top')

      end
    end

    context 'create' do
      let(:review) { build(:ppa_revision_review_problem_situation_strategy).attributes }
      let(:region_theme_params1) { build(:ppa_revision_review_region_theme, problem_situation_strategy: nil ).attributes }

      let(:problem_situation_params1) { build(:ppa_revision_review_problem_situation, region_theme_id: nil).attributes }
      let(:new_problem_situation_params1) { build(:ppa_revision_review_new_problem_situation, region_theme_id: nil).attributes }
      let(:new_regional_strategy_params1) { build(:ppa_revision_review_new_regional_strategy, region_theme_id: nil).attributes }
      let(:regional_strategy_params1) { build(:ppa_revision_review_regional_strategy, region_theme_id: nil).attributes }

      let(:region_theme_params2) { build(:ppa_revision_review_region_theme, problem_situation_strategy: nil ).attributes }
      let(:problem_situation_params2) { build(:ppa_revision_review_problem_situation, region_theme_id: nil).attributes }
      let(:new_problem_situation_params2) { build(:ppa_revision_review_new_problem_situation, region_theme_id: nil).attributes }
      let(:new_regional_strategy_params2) { build(:ppa_revision_review_new_regional_strategy, region_theme_id: nil).attributes }
      let(:regional_strategy_params2) { build(:ppa_revision_review_regional_strategy, region_theme_id: nil).attributes }

      let(:model_class) { PPA::Revision::Review::ProblemSituationStrategy }
      let(:model_problem_situation) { PPA::Revision::Review::ProblemSituation }
      let(:model_new_problem_situation) { PPA::Revision::Review::NewProblemSituation }
      let(:model_regional_strategy) { PPA::Revision::Review::RegionalStrategy }
      let(:model_new_regional_strategy) { PPA::Revision::Review::NewRegionalStrategy }
      let(:model_region_theme) { PPA::Revision::Review::RegionTheme }

      render_views

      it 'full revision' do


        params = { plan_id: plan.id, ppa_revision_review_problem_situation_strategy: review }

        params[:ppa_revision_review_problem_situation_strategy][:region_themes_attributes] = { '0': region_theme_params1 }
        params[:ppa_revision_review_problem_situation_strategy][:region_themes_attributes][:'0'][:problem_situations_attributes] = { '0': problem_situation_params1 }
        params[:ppa_revision_review_problem_situation_strategy][:region_themes_attributes][:'0'][:new_problem_situations_attributes] = { '0': new_problem_situation_params1 }
        params[:ppa_revision_review_problem_situation_strategy][:region_themes_attributes][:'0'][:regional_strategies_attributes] = { '0': regional_strategy_params1 }
        params[:ppa_revision_review_problem_situation_strategy][:region_themes_attributes][:'0'][:new_regional_strategies_attributes] = { '0': new_regional_strategy_params1 }

        params[:ppa_revision_review_problem_situation_strategy][:region_themes_attributes][:'1'] =  region_theme_params2 
        params[:ppa_revision_review_problem_situation_strategy][:region_themes_attributes][:'1'][:problem_situations_attributes] = { '0': problem_situation_params2 }
        params[:ppa_revision_review_problem_situation_strategy][:region_themes_attributes][:'1'][:new_problem_situations_attributes] = { '0': new_problem_situation_params2 }
        params[:ppa_revision_review_problem_situation_strategy][:region_themes_attributes][:'1'][:regional_strategies_attributes] = { '0': regional_strategy_params2 }
        params[:ppa_revision_review_problem_situation_strategy][:region_themes_attributes][:'1'][:new_regional_strategies_attributes] = { '0': new_regional_strategy_params2 }


        expect(model_class.count).to eq(0)
        expect(model_problem_situation.count).to eq(0)
        expect(model_new_problem_situation.count).to eq(0)
        expect(model_regional_strategy.count).to eq(0)
        expect(model_new_regional_strategy.count).to eq(0)
        
        post :create, params: params
       
        expect(response).to be_a_redirect
        expect(model_class.count).to eq(1)
        expect(model_problem_situation.count).to eq(2)
        expect(model_new_problem_situation.count).to eq(2)
        expect(model_regional_strategy.count).to eq(2)
        expect(model_new_regional_strategy.count).to eq(2)
        expect(model_region_theme.count).to eq(2)
        
      end
    end
  end  
end
