require 'rails_helper'

RSpec.describe Transparency::ContactsController, type: :controller do

  context 'index' do

    before { get(:index) }

    context 'template' do
      render_views

      it { is_expected.to respond_with(:success) }
    end
  end

end
