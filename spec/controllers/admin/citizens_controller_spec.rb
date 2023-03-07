require 'rails_helper'

describe Admin::CitizensController do

  let(:user) { create(:user, :admin) }

  let(:citizen) { create(:user, :user) }

  let(:resources) { [citizen] + create_list(:user, 1, :user) }

  it_behaves_like 'controllers/admin/base/index' do

    it_behaves_like 'controllers/admin/base/index/xhr'
    it_behaves_like 'controllers/base/index/paginated'
    it_behaves_like 'controllers/base/index/search'


    it_behaves_like 'controllers/base/index/sorted' do
      let(:sort_columns) do
        {
          name: 'users.name',
          email: 'users.email'
        }
      end

      let(:first_unsorted) do
        create(:user, name: '456')
      end

      let(:last_unsorted) do
        create(:user, name: '123')
      end
    end

    context 'filters' do
      it 'person_type' do
        user_individual = create(:user, :individual)
        user_legal = create(:user, :legal)

        get(:index, params: { person_type: :individual })

        expect(controller.users).to eq([user_individual])
      end

      it_behaves_like 'controllers/admin/base/index/filter_disabled' do
        let(:resource) { create(:user) }
        let(:resource_disabled) { create(:user, disabled_at: DateTime.now) }
      end
    end

    context 'scope' do
      it 'only user_type :user' do
        user
        create(:user, :operator)
        citizen = create(:user, :user)

        expect(controller.users).to eq([citizen])
      end
    end
  end

  it_behaves_like 'controllers/admin/base/show'

  it_behaves_like 'controllers/admin/base/destroy'

end
