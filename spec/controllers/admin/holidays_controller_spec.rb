require 'rails_helper'

describe Admin::HolidaysController, type: :controller do

  let(:user) { create(:user, :admin) }

  let(:resources) { create_list(:holiday, 1) }

  let(:permitted_params) do
    [
      :title,
      :day,
      :month
    ]
  end

  let(:valid_params) { { holiday: attributes_for(:holiday) } }

  it_behaves_like 'controllers/base/index/paginated'
  it_behaves_like 'controllers/base/index/search'

  it_behaves_like 'controllers/admin/base/index/xhr'

  it_behaves_like 'controllers/base/index/sorted' do

    let(:sort_columns) do
      {
        month: 'holidays.month',
        day: 'holidays.day',
        title: 'holidays.title'
      }
    end

    let(:first_unsorted) do
      create(:holiday, month: '10', day: '1')
    end

    let(:last_unsorted) do
      create(:holiday, month: '1', day: '4')
    end
  end

  it_behaves_like 'controllers/admin/base/new'
  it_behaves_like 'controllers/admin/base/create'
  it_behaves_like 'controllers/admin/base/show'
  it_behaves_like 'controllers/admin/base/edit'
  it_behaves_like 'controllers/admin/base/update'
  it_behaves_like 'controllers/admin/base/destroy'
end
