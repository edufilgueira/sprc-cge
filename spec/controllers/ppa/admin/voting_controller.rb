require 'rails_helper'

RSpec.describe PPA::Admin::VotingsController, type: :controller do

  let(:admin)     { create :ppa_admin }
  let(:resources) { [create(:ppa_voting)] }

  let(:permitted_params) do
    [
      :start_in,
      :end_in,
      :plan_id,
      :region_id
    ]     
  end

  let(:valid_params) do
    attrs = build(:ppa_voting, :future)
      .attributes
      .except('id', 'created_at', 'updated_at')

    { ppa_voting: attrs }
  end

  # it_behaves_like 'controllers/ppa/admin/base/index'
  # it_behaves_like 'controllers/ppa/admin/base/new'
  # it_behaves_like 'controllers/ppa/admin/base/show'
  # it_behaves_like 'controllers/ppa/admin/base/create'
  # it_behaves_like 'controllers/ppa/admin/base/edit'
  # it_behaves_like 'controllers/ppa/admin/base/update'
  # it_behaves_like 'controllers/ppa/admin/base/destroy'

end
