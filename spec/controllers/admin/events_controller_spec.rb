require 'rails_helper'

describe Admin::EventsController do
  let(:user) { create(:user, :admin) }

  let(:event) { create(:event) }

  let(:resources) { [event] + create_list(:event, 1) }

  let(:permitted_params) do
    [
      :title,
      :starts_at,
      :category,
      :description
    ]
  end

  let(:valid_params) do
    { event: attributes_for(:event) }
  end

  it_behaves_like 'controllers/admin/base/index' do

    it_behaves_like 'controllers/admin/base/index/xhr'
    it_behaves_like 'controllers/base/index/paginated'
    it_behaves_like 'controllers/base/index/search'


    it_behaves_like 'controllers/base/index/sorted' do
      let(:sort_columns) do
        {
          title: 'events.event',
          starts_at: 'events.starts_at'
        }
      end

      let(:first_unsorted) { create(:event, title: '456') }

      let(:last_unsorted) { create(:event, title: '123') }
    end
  end

  it_behaves_like 'controllers/admin/base/new'

  it_behaves_like 'controllers/admin/base/create'

  it_behaves_like 'controllers/admin/base/show'

  it_behaves_like 'controllers/admin/base/edit'

  it_behaves_like 'controllers/admin/base/update'

  it_behaves_like 'controllers/admin/base/destroy'
end
