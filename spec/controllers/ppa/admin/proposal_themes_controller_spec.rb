require 'rails_helper'

RSpec.describe PPA::Admin::ProposalThemesController, type: :controller do

  let(:admin)     { create :ppa_admin }
  let(:resources) { [create(:ppa_proposal_theme)] }

  let(:permitted_params) do
    [
      :start_in,
      :end_in,
      :plan_id,
      :region_id
    ]     
  end

  let(:valid_params) do
    attrs = build(:ppa_proposal_theme, :future)
      .attributes
      .except('id', 'created_at', 'updated_at')

    { ppa_proposal_theme: attrs }
  end
end