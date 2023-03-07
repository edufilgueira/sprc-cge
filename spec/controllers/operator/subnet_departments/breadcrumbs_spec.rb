require 'rails_helper'

describe Operator::SubnetDepartmentsController do

  let(:subnet) { create(:subnet) }
  let(:organ) { subnet.organ }

  let(:user) { create(:user, :operator_sectoral, organ: organ) }

  let(:department) { create(:department, :with_subnet, subnet: subnet) }

  context 'index' do
    before { sign_in(user) && get(:index) }

    it 'breadcrumbs' do
      expected = [
        { title: I18n.t('operator.home.index.title'), url: operator_root_path },
        { title: I18n.t('operator.subnet_departments.index.title', organ_acronym: organ.acronym), url: '' }
      ]

      expect(controller.breadcrumbs).to eq(expected)
    end
  end

  context 'show' do
    before { sign_in(user) && get(:show, params: { id: department }) }

    it 'breadcrumbs' do
      expected = [
        { title: I18n.t('operator.home.index.title'), url: operator_root_path },
        { title: I18n.t('operator.subnet_departments.index.title', organ_acronym: organ.acronym), url: operator_subnet_departments_path },
        { title: department.title, url: '' }
      ]

      expect(controller.breadcrumbs).to eq(expected)
    end
  end
end
