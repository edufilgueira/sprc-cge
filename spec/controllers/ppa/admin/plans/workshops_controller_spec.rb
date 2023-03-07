require 'rails_helper'

RSpec.describe PPA::Admin::Plans::WorkshopsController, type: :controller do

  let(:admin)     { create :ppa_admin }
  let!(:plan)     { create :ppa_plan }
  let!(:resources) { [create(:ppa_workshop, plan: plan)] }

  let(:permitted_params) do
    [
      :name,
      :start_at,
      :end_at,
      :address,
      :city_id,
      :participants_count,
      documents_attributes: [ :attachment, :_destroy, :id ],
      photos_attributes: [ :attachment, :_destroy, :id ],
    ]
  end

  let(:valid_params) do
    attrs = build(:ppa_workshop, plan: plan)
      .attributes
      .except('id', 'created_at', 'updated_at')

    { ppa_workshop: attrs }
  end

  let(:request_params) { { plan_id: plan.id } }

  it_behaves_like 'controllers/ppa/admin/base/index'
  it_behaves_like 'controllers/ppa/admin/base/new'
  it_behaves_like 'controllers/ppa/admin/base/show'
  it_behaves_like 'controllers/ppa/admin/base/create'
  it_behaves_like 'controllers/ppa/admin/base/edit'
  it_behaves_like 'controllers/ppa/admin/base/update'
  it_behaves_like 'controllers/ppa/admin/base/destroy'
end
