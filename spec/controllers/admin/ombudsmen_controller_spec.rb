require 'rails_helper'

describe Admin::OmbudsmenController do
  let(:user) { create(:user, :admin) }

  let(:resources) { create_list(:ombudsman, 1) }

  let(:permitted_params) do
    [
      :title,
      :contact_name,
      :phone,
      :email,
      :address,
      :operating_hours,
      :kind
    ]
  end

  let(:valid_params) { { ombudsman: attributes_for(:ombudsman) } }

  let(:sort_columns) do
    {
      title: 'ombudsmen.title',
      email: 'ombudsmen.email',
      kind: 'ombudsmen.kind'
    }
  end

  it_behaves_like 'controllers/admin/base/index' do

    context 'filters' do
      it 'kind' do
        ombudsman = create(:ombudsman, kind: :sesa)
        resources.first

        get(:index, params: { kind: :sesa })

        expect(controller.ombudsmen).to eq([ombudsman])
      end
    end

    it_behaves_like 'controllers/base/index/paginated'
    it_behaves_like 'controllers/base/index/search'
    it_behaves_like 'controllers/base/index/sorted'
    it_behaves_like 'controllers/admin/base/index/xhr'
  end

  it_behaves_like 'controllers/admin/base/new'
  it_behaves_like 'controllers/admin/base/create'
  it_behaves_like 'controllers/admin/base/show'
  it_behaves_like 'controllers/admin/base/edit'
  it_behaves_like 'controllers/admin/base/update'
  it_behaves_like 'controllers/admin/base/destroy'
end
