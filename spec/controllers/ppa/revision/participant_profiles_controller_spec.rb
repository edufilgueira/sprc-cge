require 'rails_helper'

RSpec.describe PPA::Revision::ParticipantProfilesController, type: :controller do


  let(:user) { create(:user) }
  let(:plan) { create(:ppa_plan, :revising) }
  let(:region) { create(:ppa_region) }

  context 'unauthorized' do
    before {
      get(:new, params: { plan_id: plan.id, region_code: region.code })
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

      it {
        expect(response).to be_success
      }

      it {
        is_expected.to render_template('ppa/revision/participant_profiles/_form')
      }
    end

    # new_ppa_revision_participant_profile_path

    context 'create' do
      let(:params) { build(:ppa_revision_participant_profile) }
      let(:model_class) { PPA::Revision::ParticipantProfile }

      context 'valid form' do
        before {
          post(:create, params: {
            ppa_revision_participant_profile: params.attributes,
            plan_id: plan.id,
            region_code: region.code
          })
        }

        render_views

        it {
          is_expected.to redirect_to(
            new_ppa_revision_review_problem_situation_strategy_path(plan_id: plan.id)
          )
        }

        it { expect(model_class.count).to eq(1) }

      end
    end
  end
end
