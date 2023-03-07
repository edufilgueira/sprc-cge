require 'rails_helper'

describe Platform::UsersController do

  let(:user) { create(:user, :user) }

  describe '#edit' do
    before { get(:edit, params: { id: user }) }

    it 'breadcrumbs' do
      expected = [
        { title: I18n.t('app.home'), url: root_path },
        { title: I18n.t('platform.users.edit.breadcrumb_title'), url: '' }
      ]

      expect(controller.breadcrumbs).to eq(expected)
    end
  end

end
