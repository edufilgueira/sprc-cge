require 'rails_helper'

describe DepartmentHelper do
  let(:department) { create(:department) }

  it 'departments_by_organ_for_select' do
    create(:department)
    expected = [ [department.title, department.id] ].sort.to_h

    expect(departments_by_organ_for_select(department.organ)).to eq(expected)
  end

  context 'departments_by_user_for_select' do
    it 'subnet' do
      user = create(:user, :operator_subnet)
      department_subnet = create(:department, :with_subnet, subnet: user.subnet)
      expected = [ [department_subnet.title, department_subnet.id] ].sort.to_h

      expect(departments_by_user_for_select(user)).to eq(expected)
    end

    it 'organ' do
      user = create(:user, :operator_sectoral)
      department_organ = create(:department, organ: user.organ)
      expected = [ [department_organ.title, department_organ.id] ].sort.to_h

      expect(departments_by_user_for_select(user)).to eq(expected)
    end

    it 'without organ' do
      user = create(:user, :operator_cge)
      other_department = create(:department)
      expected = [
        [other_department.title, other_department.id],
        [department.title, department.id]
      ].sort.to_h

      expect(departments_by_user_for_select(user)).to eq(expected)
    end
  end

  it 'departments_by_subnet_for_select' do
    department
    subnet_department = create(:department, :with_subnet)
    expected = [ [subnet_department.title, subnet_department.id] ].sort.to_h

    expect(departments_by_subnet_for_select(subnet_department.subnet)).to eq(expected)
  end

  it 'departments_for_select' do
    expected = [ [department.title, department.id] ].sort.to_h

    expect(departments_for_select).to eq(expected)
  end

  it 'departments_sorted_by_organ_for_select' do
    expected = [ [department.title, department.id] ].sort.to_h

    expect(departments_sorted_by_organ_for_select).to eq(expected)
  end

  describe 'acronym_organs_list' do

    context 'not subnet' do
      let(:ticket) { create(:ticket, :with_parent) }

      let(:ticket_department_1) { create(:ticket_department, ticket: ticket) }
      let(:department_1) { ticket_department_1.department }

      let(:ticket_department_2) { create(:ticket_department, ticket: ticket) }
      let(:department_2) { ticket_department_2.department }

      before do
        ticket.reload
        department_1
        department_2
      end

      it { expect(acronym_departments_list(ticket)).to eq("#{ticket_department_1.title_for_sectoral}; #{ticket_department_2.title_for_sectoral}") }
    end

    context 'subnet' do
      let(:organ) { create(:executive_organ, :with_subnet) }
      let(:subnet) { create(:subnet, organ: organ) }
      let(:ticket) { create(:ticket, :with_parent, organ: organ, subnet: subnet) }

      it { expect(acronym_departments_list(ticket)).to eq(subnet.acronym) }
    end
  end

  context 'departments_by_ticket_for_select' do
    let(:department) { create(:department, :with_subnet) }
    let(:subnet) { department.subnet }
    let(:organ) { subnet.organ }
    let(:organ_department) { create(:department, organ: organ) }
    let(:other_department) { create(:department) }
    let(:ticket) { create(:ticket) }

    it 'with subnet' do
      ticket.subnet = subnet

      expected = [
        [department.title, department.id]
      ].sort.to_h

      expect(departments_by_ticket_for_select(ticket)).to eq(expected)
    end

    it 'with organ' do
      ticket.subnet = nil
      ticket.organ = organ

      expected = [
        [organ_department.title, organ_department.id]
      ].sort.to_h

      expect(departments_by_ticket_for_select(ticket)).to eq(expected)
    end

    it 'without organ' do
      ticket.subnet = nil
      ticket.organ = nil
      expected = [
        [department.title, department.id],
        [organ_department.title, organ_department.id],
        [other_department.title, other_department.id]
      ].sort.to_h

      expect(departments_by_ticket_for_select(ticket)).to eq(expected)
    end
  end


  context 'departments_for_referral_for_select' do
    let(:organ) { create(:executive_organ, :with_subnet) }
    let(:subnet) { create(:subnet, organ: organ) }
    let!(:department_subnet) { create(:department, :with_subnet, subnet: subnet) }
    let!(:organ_department) { create(:department, organ: organ) }
    let(:other_department) { create(:department) }
    let(:ticket) { create(:ticket, :with_parent, organ: organ, unknown_subnet: true) }
    let(:ticket_subnet) { create(:ticket, :with_subnet, subnet: subnet) }

    context 'with subnet' do
      it 'subnet operator' do
        user = create(:user, :operator_subnet, subnet: subnet)

        expected = [
          [department_subnet.title, department_subnet.id]
        ].sort.to_h

        expect(departments_for_referral_for_select(ticket_subnet, user)).to eq(expected)
      end

      it 'operator sectoral' do
        user = create(:user, :operator_sectoral, organ: organ)

        expected = [
          [department_subnet.title, department_subnet.id],
          [organ_department.title, organ_department.id]
        ].sort.to_h

        expect(departments_for_referral_for_select(ticket_subnet, user)).to match_array(expected)
      end

      it 'subnet operator' do
        user = create(:user, :operator_subnet_internal, subnet: subnet, department: department_subnet)

        expected = [
          [department_subnet.title, department_subnet.id]
        ].sort.to_h

        expect(departments_for_referral_for_select(ticket_subnet, user)).to eq(expected)
      end
    end

    context 'with organ' do
      it 'operator sectoral' do
        user = create(:user, :operator_sectoral, organ: organ)

        expected = [
          [organ_department.title, organ_department.id]
        ].sort.to_h

        expect(departments_for_referral_for_select(ticket, user)).to match_array(expected)
      end
    end
  end

  context 'department_by_id_for_select' do
    it 'when filter is selected' do
      expected = [
        [department.title, department.id]
      ].sort.to_h

      expect(department_by_id_for_select(department.id)).to eq(expected)
    end

    it 'when filter is not selected' do
      expected = []

      expect(department_by_id_for_select(nil)).to eq(expected)
    end
  end
end
