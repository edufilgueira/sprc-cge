require 'rails_helper'

describe SubDepartmentsHelper do
  let(:sub_department) { create(:sub_department) }

  context 'sub_department_by_id_for_select' do
    it 'when filter is selected' do
      expected = [
        [sub_department.title, sub_department.id]
      ].sort.to_h

      expect(sub_department_by_id_for_select(sub_department.id)).to eq(expected)
    end

    it 'when filter is not selected' do
      expected = []

      expect(sub_department_by_id_for_select(nil)).to eq(expected)
    end
  end
end
