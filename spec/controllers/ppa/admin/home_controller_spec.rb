require 'rails_helper'

RSpec.describe PPA::Admin::HomeController, type: :controller do

  let(:admin) { create :ppa_admin }
  before { sign_in admin }

  describe '#show' do
    subject(:get_show) { get(:show) }

    it 'requires authentication' do
      sign_out admin
      get_show

      expect(response).to redirect_to new_ppa_admin_session_path
    end

    context 'template' do
      render_views

      it { is_expected.to render_template('layouts/ppa/admin') }
      it { is_expected.to render_template(:show) }
    end
  end
end
