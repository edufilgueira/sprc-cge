require 'rails_helper'

describe HomeController do

  context 'index' do

    before { get(:index) }

    context 'template' do
      render_views

      it { is_expected.to respond_with(:success) }
    end
  end

  context 'privacy_policy' do

    before { get(:privacy_policy) }

    context 'template' do
      render_views

      it { is_expected.to respond_with(:success) }
    end
  end

  context 'terms_of_use' do

    before { get(:terms_of_use) }

    context 'template' do
      render_views

      it { is_expected.to respond_with(:success) }
    end
  end

  context 'site_map' do

    before { get(:site_map) }

    context 'template' do
      render_views

      it { is_expected.to respond_with(:success) }
      it { is_expected.to render_template('home/site_map/index') }
    end
  end
end
