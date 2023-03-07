require 'rails_helper'

RSpec.describe PPA::Themes::RegionalStrategies::LikesController, type: :controller do

  let(:biennium)  { PPA::Biennium.new '2016-2017' }
  let(:region)    { create :ppa_region }

  let(:theme)    { create :ppa_theme }
  let(:strategy) { create :ppa_strategy }
  let(:regional_strategy) do
    create :ppa_biennial_regional_strategy, biennium: biennium, region: region, strategy: strategy
  end

  let(:base_params) do {
    biennium: biennium.to_s,
    region_code: region.code,
    theme_id: theme.id,
    regional_strategy_id: regional_strategy.id
  } end

  # requires authentication
  let(:user) { create :user, :citizen }
  before { sign_in user }

  it_behaves_like PPA::LikableControlling do
    let(:likable) { regional_strategy }
    let(:params) { base_params }
  end


  describe '#create' do
    subject(:post_create) { post :create, params: base_params }

    it 'requires authentication' do
      sign_out user
      post_create
      expect(response).to redirect_to new_user_session_path
    end
  end

end
