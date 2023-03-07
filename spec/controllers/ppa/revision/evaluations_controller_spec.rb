require 'rails_helper'

RSpec.describe PPA::Revision::EvaluationsController, type: :controller do


  let(:user) { create(:user) }

  let(:region) { create(:ppa_region) }
  let(:schedule1) { create(:ppa_revision_schedule, plan: plan)}


  context 'unauthorized' do

    before {
      plan = create(:ppa_plan, :revising)
      get(:new, params: { plan_id: plan.id })
    }

    it { is_expected.to redirect_to(new_user_session_path) }
  end


  context 'authorized' do
    before { sign_in(user) }

    context 'Plan out of revision' do

      before {
        create(:ppa_revision_schedule)
        plan = PPA::Plan.first
        plan.update(status: 0) #Elaborating
        get(:new, params: { plan_id: plan.id })
      }

      it { is_expected.to respond_with(:forbidden) } # 403

    end

    context 'Plan out of schedule' do

      before {
        create(:ppa_revision_schedule, :out)

        plan = PPA::Plan.first
        plan.update(status: 3)
        get(:new, params: { plan_id: plan.id })
      }

      it { is_expected.to redirect_to(root_path)  } # 403
    end

    context 'Plan in revision and schedule ok' do

      before {
        create(:ppa_revision_schedule)

        plan = PPA::Plan.first
        plan.update(status: 3)
        get(:new, params: { plan_id: plan.id })
      }

      it { is_expected.to  respond_with(:success)  } # 403
    end
  end
end
