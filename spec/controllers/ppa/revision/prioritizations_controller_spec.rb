require 'rails_helper'

RSpec.describe PPA::Revision::PrioritizationsController, type: :controller do

	let(:user) { create(:user) }
  let(:plan) { create(:ppa_plan, :revising) }
  let(:model) { PPA::Revision::Prioritization }

  context 'unauthorized' do
    before {
      post(:create, params: { plan_id: plan.id })
    }

    it { is_expected.to redirect_to(new_user_session_path) }
  end

  context 'authorized' do
    before { sign_in(user) }

    context 'create' do
      before {
        post(:create, params: { plan_id: plan.id })
      }

      it 'redirect after create' do
      	id = model.last
      	path = edit_ppa_revision_prioritization_path(plan_id: plan.id, id: id)

        expect(response).to redirect_to(path)
      end

      it 'create one Prioritization' do
 				expect(model.count).to eq(1)
      end
    end
  end
end
