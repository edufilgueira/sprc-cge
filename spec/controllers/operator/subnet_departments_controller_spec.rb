require 'rails_helper'

describe Operator::SubnetDepartmentsController do

  let(:subnet) { create(:subnet) }
  let(:organ) { subnet.organ }

  let(:user) { create(:user, :operator_sectoral, organ: organ) }

  let(:department) { create(:department, :with_subnet, subnet: subnet) }

  let(:resources) { create_list(:department, 2, subnet: subnet) }

  it_behaves_like 'controllers/operator/base/index' do
    it_behaves_like 'controllers/operator/base/index/xhr'
    it_behaves_like 'controllers/operator/base/index/paginated'
    it_behaves_like 'controllers/operator/base/index/search'

    it_behaves_like 'controllers/base/index/sorted' do
      let(:sort_columns) do
        {
          subnet_acronym: 'subnets.acronym',
          name: 'departments.name'
        }
      end

      let(:first_unsorted) do
        create(:department, :with_subnet, subnet: subnet, name: '456')
      end

      let(:last_unsorted) do
        create(:department, :with_subnet, subnet: subnet, name: '123')
      end
    end

    context 'authorized' do
      before { sign_in(user) }


      context 'template' do
        render_views

        context 'print' do

        it 'responds with success and renders templates' do
          get(:index, params: { print: true })

          expect(response).to be_success
          expect(response).to render_template("layouts/print")
          expect(response).to render_template("operator/subnet_departments/print/index")
        end

        end
      end

      context 'helpers' do
        before { get(:index) }

        it 'organ' do
          expect(controller.view_context.organ).to eq(organ)
        end

        it 'filtered_resources' do
          expect(controller.view_context.filtered_resources).to eq(resources)
        end
      end
    end
  end

  it_behaves_like 'controllers/operator/base/show' do

    context 'authorized' do
      before { sign_in(user) }

      context 'template' do
        render_views

        context 'print' do

        it 'responds with success and renders templates' do
          get(:show, params: { id: department, print: true })

          expect(response).to be_success
          expect(response).to render_template("layouts/print")
          expect(response).to render_template("operator/subnet_departments/print/show")
        end

        end
      end
    end
  end
end
