require 'rails_helper'

describe Admin::UnregistredCitizensController do

  let(:user) { create(:user, :admin) }

  # XXX nomes fixos para que os testes de ordenação por nome funcionem!
  let(:ticket) { create(:ticket, :unregistred_user, name: 'José da Silva') }
  let(:resources) { [ticket] + create_list(:ticket, 1, :unregistred_user, name: 'Maria da Silva') }

  # before { resources }

  it_behaves_like 'controllers/admin/base/index' do

    it_behaves_like 'controllers/admin/base/index/xhr'
    it_behaves_like 'controllers/base/index/paginated'
    it_behaves_like 'controllers/base/index/search'


    it_behaves_like 'controllers/base/index/sorted' do
      let(:sort_columns) do
        {
          name: 'tickets.name',
          email: 'tickets.email'
        }
      end

      let(:first_unsorted) do
        create(:ticket, name: '456')
      end

      let(:last_unsorted) do
        create(:ticket, name: '123')
      end
    end

    context 'filters' do
      it 'person_type' do

        individual = create(:ticket, :unregistred_user, person_type: :individual)
        legal =  create(:ticket, :unregistred_user, person_type: :legal)

        get(:index, params: { person_type: :individual })

        expect(controller.tickets).to eq([individual])
      end
    end

    context 'search' do
      it 'name' do
        ticket = create(:ticket, :unregistred_user, name: 'abcdef')
        another_ticket = create(:ticket, :unregistred_user, name: 'ghijk')

        get(:index, params: { search: 'a d f' })

        expect(controller.tickets).to eq([ticket])
      end

      it 'email' do
        ticket = create(:ticket, :unregistred_user, email: '123456@example.com')
        another_ticket = create(:ticket, :unregistred_user, email: '7890@example.com')

        get(:index, params: { search: '1 4 6 @' })

        expect(controller.tickets).to eq([ticket])
      end

      it 'description' do
        ticket = create(:ticket, :unregistred_user, description: 'ticket')
        another_ticket = create(:ticket, :unregistred_user)

        get(:index, params: { search: 'tick' })

        expect(controller.tickets).to be_empty
      end
    end

    context 'scope' do
      it 'only created by unregistred users' do
        ticket
        create(:ticket, created_by: user)
        create(:ticket, :anonymous)

        expect(controller.tickets).to eq([ticket])
      end
    end

    context 'default sort_column' do
      it { expect(controller.sort_column).to eq('tickets.name') }
    end

  end

  it_behaves_like 'controllers/admin/base/show'

  it_behaves_like 'controllers/admin/base/destroy'
end
