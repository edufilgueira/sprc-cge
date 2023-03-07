require 'rails_helper'

describe About::SouController do

  describe '#index' do
    before { get(:index) }

    context 'template' do
      render_views

      it { is_expected.to respond_with(:success) }
    end
  end
end
