require 'rails_helper'

RSpec.describe PPA::Revision::RegionThemesController, type: :controller do


  let(:user) { create(:user) }
  let(:plan) { create(:ppa_plan, :revising) }
  let(:region) { create(:ppa_region) }
  let(:review) { create(:ppa_revision_review_problem_situation_strategy) }
  let(:region_theme) { create(:ppa_revision_review_region_theme, problem_situation_strategy: review ) }
  let(:problem_situation) { create(:ppa_revision_review_problem_situation, region_theme_id: region_theme.id) }
  let(:new_problem_situation) { create(:ppa_revision_review_new_problem_situation, region_theme_id: region_theme.id) }
  let(:new_regional_strategy) { create(:ppa_revision_review_new_regional_strategy, region_theme_id: region_theme.id) }
  let(:regional_strategy) { create(:ppa_revision_review_regional_strategy, region_theme_id: region_theme.id) }

  let(:model_problem_situation) { PPA::Revision::Review::ProblemSituation }
  let(:model_new_problem_situation) { PPA::Revision::Review::NewProblemSituation }
  let(:model_regional_strategy) { PPA::Revision::Review::RegionalStrategy }
  let(:model_new_regional_strategy) { PPA::Revision::Review::NewRegionalStrategy }



  context 'authorized' do
    before do
      sign_in(user)
      review
      region_theme
      problem_situation
      new_problem_situation
      new_regional_strategy
      regional_strategy
    end

    it 'update' do
      params = {
        "ppa_revision_review_region_theme" => {
          "id" => review.id,
          "region_code" => region.id,
          "problem_situations_attributes" => {
            "0" => {
              "id" => problem_situation.id,
              "persist" => "false"
            }
          },
          "new_problem_situations_attributes" => {
            "0" => {
              "description" => "alterado",
              "city_id" => region.id,
              "id" => new_problem_situation.id
            }
          },
          "regional_strategies_attributes" => {
            "0" => {
              "id" => regional_strategy.id,
              "persist" => "false"
            }
          },
          "new_regional_strategies_attributes" => {
            "0" => {
              "description" => "alterado",
              "id" => new_regional_strategy.id
            }
          },
        },
        "plan_id" => "2",
        "review_problem_situation_strategy_id" => review.id,
        "id" => region_theme.id
      }

      post :update, params: params

      #expect(PPA::Revision::Review::ProblemSituation.first.description).to eq("alterado")
      #expect(PPA::Revision::Review::RegionalStrategy.first.persist).to eq(false)


    end
  end
end
