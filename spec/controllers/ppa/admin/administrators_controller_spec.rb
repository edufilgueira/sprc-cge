require 'rails_helper'

RSpec.describe PPA::Admin::AdministratorsController, type: :controller do

  let(:admin)     { create :ppa_admin }
  let(:resources) { [admin] }

  let(:permitted_params) do
    [
      :name,
      :cpf,
      :email,
    ]
  end

  let(:valid_params) do
    attrs = build(:ppa_administrator)
      .attributes
      .except('id', 'created_at', 'updated_at')

    { ppa_administrator: attrs }
  end

  it_behaves_like 'controllers/ppa/admin/base/index'
  it_behaves_like 'controllers/ppa/admin/base/new'
  it_behaves_like 'controllers/ppa/admin/base/show'
  it_behaves_like 'controllers/ppa/admin/base/create'
  it_behaves_like 'controllers/ppa/admin/base/edit'
  it_behaves_like 'controllers/ppa/admin/base/update'
  it_behaves_like 'controllers/ppa/admin/base/destroy'

  describe '#toggle_lock' do
    let(:other_admin) { create :ppa_admin }

    before { sign_in(admin) }

    context 'response' do
      before { post :toggle_lock, params: { id: other_admin.id } }

      it { expect(response).to redirect_to(ppa_admin_administrators_path) }
    end

    context 'when admin is signed_in' do
      before do
        post :toggle_lock, params: { id: admin.id }
        admin.reload
      end

      it 'dont unlock itself' do
        expect(admin.locked?).to be_falsey
      end

      it 'set a error message' do
        expect(flash[:alert]).to eq I18n.t('ppa.admin.administrators.toggle_lock.cannot_toggle_lock_one_self')
      end
    end

    context 'when admin is locked' do
      before do
        other_admin.lock_access!
        post :toggle_lock, params: { id: other_admin.id }
        other_admin.reload
      end

      it 'unlocks it' do
        expect(other_admin.locked?).to be_falsey
      end

      it 'set a success message' do
        expect(flash[:notice]).to eq I18n.t('ppa.admin.administrators.toggle_lock.unlock.done', name: other_admin.name)
      end
    end

    context 'when admin is unlocked' do
      before do
        post :toggle_lock, params: { id: other_admin.id }
        other_admin.reload
      end

      it 'locks it' do
        expect(other_admin.locked?).to be_truthy
      end

      it 'set a success message' do
        expect(flash[:notice]).to eq I18n.t('ppa.admin.administrators.toggle_lock.lock.done', name: other_admin.name)
      end
    end
  end

end
