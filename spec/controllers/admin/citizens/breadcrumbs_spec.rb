require 'rails_helper'

describe Admin::CitizensController do

  let(:user) { create(:user, :admin) }

  context 'index' do
    before { sign_in(user) && get(:index) }

    it 'breadcrumbs' do
      expected = [
        { title: I18n.t('admin.home.index.title'), url: admin_root_path },
        { title: I18n.t('admin.citizens.index.title'), url: '' }
      ]

      expect(controller.breadcrumbs).to eq(expected)
    end
  end

  context 'show' do
    let(:citizen) { create(:user, :user) }

    before { sign_in(user) && get(:show, params: { id: citizen }) }

    it 'breadcrumbs' do
      expected = [
        { title: I18n.t('admin.home.index.title'), url: admin_root_path },
        { title: I18n.t('admin.citizens.index.title'), url: admin_citizens_path },
        { title: citizen.title, url: '' }
      ]

      expect(controller.breadcrumbs).to eq(expected)
    end
  end
end
