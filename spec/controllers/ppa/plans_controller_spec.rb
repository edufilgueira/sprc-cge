require 'rails_helper'

RSpec.describe PPA::PlansController, type: :controller do

  describe '#show' do
    let(:workshop) { create :ppa_workshop, :past }
    let(:plan) { create :ppa_plan, :monitoring }

    subject(:get_show) { get :show, params: { id: plan.id } }

    context 'get in show' do
      render_views
      
      it 'without next scheduled workshops' do
        get_show
        
        expect(response).to have_http_status(:success)
        expect(response).to render_template 'ppa/plans/show'
        expect(response).to render_template 'ppa/plans/_about_elaboration_phase'
        expect(response).to render_template 'ppa/plans/_workshops'
        expect(response).to render_template 'ppa/plans/_map'

      end
    end
  end
end
