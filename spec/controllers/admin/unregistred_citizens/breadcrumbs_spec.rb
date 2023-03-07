require 'rails_helper'

describe Admin::UnregistredCitizensController do

  let(:user) { create(:user, :admin) }

  context 'index' do
    before { sign_in(user) && get(:index) }

    it 'breadcrumbs' do
      expected = [
        { title: I18n.t('admin.home.index.title'), url: admin_root_path },
        { title: I18n.t('admin.unregistred_citizens.index.title'), url: '' }
      ]

      expect(controller.breadcrumbs).to eq(expected)
    end
  end

  context 'show' do
    let(:ticket) { create(:ticket, :unregistred_user) }

    before { sign_in(user) && get(:show, params: { id: ticket }) }

    it 'breadcrumbs' do
      expected = [
        { title: I18n.t('admin.home.index.title'), url: admin_root_path },
        { title: I18n.t('admin.unregistred_citizens.index.title'), url: admin_unregistred_citizens_path },
        { title: ticket.name, url: '' }
      ]

      expect(controller.breadcrumbs).to eq(expected)
    end
  end
end
