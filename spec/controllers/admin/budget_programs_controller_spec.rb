require 'rails_helper'

describe Admin::BudgetProgramsController do

  let(:user) { create(:user, :admin) }

  let(:resources) { create_list(:budget_program, 1) }

  let(:permitted_params) do
    [
      :name,
      :code,
      :theme_id,
      :organ_id,
      :subnet_id
    ]
  end

  let(:valid_params) { { budget_program: attributes_for(:budget_program) } }

  let(:sort_columns) do
    {
      organ_acronym: 'organs.acronym',
      subnet_acronym: 'subnets.acronym',
      name: 'budget_programs.name',
      code: 'budget_programs.code',
      theme: 'themes.name'
    }
  end

  it_behaves_like 'controllers/admin/base/index' do
    it_behaves_like 'controllers/base/index/paginated'
    it_behaves_like 'controllers/base/index/search'
    it_behaves_like 'controllers/base/index/sorted'
    it_behaves_like 'controllers/admin/base/index/xhr'
    it_behaves_like 'controllers/admin/base/index/filter_disabled'
  end

  it_behaves_like 'controllers/admin/base/new'
  it_behaves_like 'controllers/admin/base/create'
  it_behaves_like 'controllers/admin/base/show'
  it_behaves_like 'controllers/admin/base/edit'
  it_behaves_like 'controllers/admin/base/toggle_disabled'

  describe '#update' do
    it_behaves_like 'controllers/admin/base/update'

    context 'change field to nil' do

      before { sign_in(user) }

      let(:organ) { create(:executive_organ) }
      let(:subnet) { create(:subnet) }

      it 'subnet when update for organ' do
        valid_budget_program = create(:budget_program, :with_subnet)
        valid_budget_program_params = valid_budget_program.attributes
        valid_budget_program_params.delete("subnet_id")
        valid_budget_program_params["organ_id"] = organ.id

        patch(:update, params: { id: valid_budget_program.id, budget_program: valid_budget_program_params} )

        valid_budget_program.reload

        expect(valid_budget_program.organ).not_to eq(nil)
        expect(valid_budget_program.subnet).to eq(nil)
      end

      it 'subnet when update for organ' do
        valid_budget_program = create(:budget_program, :with_organ)
        valid_budget_program_params = valid_budget_program.attributes
        valid_budget_program_params.delete("organ_id")
        valid_budget_program_params["subnet_id"] = subnet.id

        patch(:update, params: { id: valid_budget_program.id, budget_program: valid_budget_program_params , from_subnet: "1" })

        valid_budget_program.reload

        expect(valid_budget_program.organ).to eq(nil)
        expect(valid_budget_program.subnet).not_to eq(nil)
      end
    end
  end
end
