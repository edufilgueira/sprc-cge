require 'rails_helper'

describe TransferDepartmentsHelper do

  let(:user) { create(:user, :operator_internal) }
  let(:ticket) { create(:ticket, organ: user.organ) }
  let(:ticket_department) { create(:ticket_department, department: user.department, ticket: ticket) }


  describe '#ticket_department_associated' do
    it {
      ticket_department
      expect(ticket_department_associated(ticket, user)).to eq(ticket_department)
    }
  end
end
