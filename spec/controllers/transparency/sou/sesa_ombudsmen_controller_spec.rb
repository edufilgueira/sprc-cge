require 'rails_helper'

RSpec.describe Transparency::Sou::SesaOmbudsmenController, type: :controller do

  describe 'index' do

    before { get(:index) }

    context 'template' do
      render_views

      it { is_expected.to respond_with(:success) }
    end
  end

  it_behaves_like 'controllers/base/index' do
    let(:resources) { create_list(:sesa_ombudsman, 1, kind: :sesa) }

    let(:sesa_ombudsman) { resources.first }

    it_behaves_like 'controllers/base/index/paginated'
    it_behaves_like 'controllers/base/index/search'
  end

  describe 'sesa ombudsmen' do
    before do
      create(:sesa_ombudsman)
      create(:executive_ombudsman)
      get :index, params: { search: '' }
    end

    let(:expected) { SesaOmbudsman.all }

    it { expect(controller.sesa_ombudsmen).to match_array(expected) }
  end
end
