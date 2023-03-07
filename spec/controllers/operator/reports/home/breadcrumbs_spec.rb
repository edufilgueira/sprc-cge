require 'rails_helper'

describe Operator::Reports::HomeController do

  let(:user) { create(:user, :operator) }

  before { sign_in(user) }

  describe 'index' do
    before { get(:index) }

    it 'breadcrumbs' do
      expected = [
        { title: I18n.t('operator.home.index.title'), url: operator_root_path },
        { title: I18n.t('operator.reports.home.index.title'), url: '' }
      ]

      expect(controller.breadcrumbs).to eq(expected)
    end
  end

end
