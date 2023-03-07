require 'rails_helper'

describe ClassificationsHelper do

  let(:organ) { create(:executive_organ) }
  let(:topic) { create(:topic, organ: organ) }
  let(:subnet) { create(:subnet) }
  let(:subtopic) { create(:subtopic, topic: topic) }
  let(:department) { create(:department) }
  let(:sub_department) { create(:sub_department, department: department) }
  let(:budget_program) { create(:budget_program) }
  let(:service_type) { create(:service_type, organ: organ) }

  context 'topics_for_select' do

    let(:topic_without_organ) { create(:topic) }
    let(:other_organs) { create(:topic, :other_organs) }

    before do
      topic_without_organ
      other_organs
    end

    it 'with organ' do
      expected = [
        [topic.title, topic.id, { other_organs: false }],
        [topic_without_organ.title, topic_without_organ.id, { other_organs: false }]
      ].sort

      expect(topics_for_select(organ)).to match_array(expected)
    end

    it 'without organ' do
      expected = [
        [topic_without_organ.title, topic_without_organ.id, { other_organs: false }]
      ].sort

      expect(topics_for_select).to eq(expected)
    end
  end

  it 'subtopics_by_topic_for_select' do
    create(:subtopic)
    create(:subtopic, :other_organs, topic: topic)

    expected = [ [subtopic.title, subtopic.id, { other_organs: false }] ].sort

    expect(subtopics_by_topic_for_select(topic)).to eq(expected)
  end

  it 'sub_departments_for_select' do

    expected = [ [sub_department.title, sub_department.id] ].sort

    expect(sub_departments_for_select).to eq(expected)

  end

  it 'sub_departments_by_department_for_select' do
    create(:sub_department)

    expected = [ [sub_department.title, sub_department.id] ].sort

    expect(sub_departments_by_department_for_select(department)).to eq(expected)

  end

  context 'classifications_sub_departments_by_user_for_select' do
    it 'operator internal' do
      user = create(:user, :operator_internal)
      sub_department_user = create(:sub_department, department: user.department)

      expected = [ [sub_department_user.title, sub_department_user.id] ].sort

      expect(classifications_sub_departments_by_user_for_select(user)).to eq(expected)
    end

    it 'operator sectoral' do
      user = create(:user, :operator_sectoral)
      department = create(:department, organ: user.organ)
      sub_department_user = create(:sub_department, department: department)

      expected = [ [sub_department_user.title, sub_department_user.id] ].sort

      expect(classifications_sub_departments_by_user_for_select(user)).to eq(expected)
    end

    it 'operator subnet' do
      user = create(:user, :operator_subnet)
      department = create(:department, subnet: user.subnet)
      sub_department_user = create(:sub_department, department: department)

      expected = [ [sub_department_user.title, sub_department_user.id] ].sort

      expect(classifications_sub_departments_by_user_for_select(user)).to eq(expected)
    end

    it 'operator CGE' do
      user = create(:user, :operator_cge)
      other_sub_department = create(:sub_department)

      expected = [
        [sub_department.title, sub_department.id],
        [other_sub_department.title, other_sub_department.id]
      ].sort

      expect(classifications_sub_departments_by_user_for_select(user)).to eq(expected)
    end
  end

  context 'budget_programs_for_select' do

    let(:other_organs) { create(:budget_program, :other_organs) }
    let(:budget_program_organ) { create(:budget_program, :with_organ, organ: organ) }
    let(:budget_program_subnet) { create(:budget_program, :with_subnet, subnet: subnet) }

    it 'with organ' do
      expected = [
        [budget_program_organ.title, budget_program_organ.id, { other_organs: false }],
        [budget_program.title, budget_program.id, { other_organs: false }]
      ]

      expect(budget_programs_for_select(organ)).to eq(expected)
    end

    it 'with subnet' do
      expected = [
        [budget_program_subnet.title, budget_program_subnet.id, { other_organs: false }],
        [budget_program.title, budget_program.id, { other_organs: false }]
      ]

      expect(budget_programs_for_select(nil, subnet)).to eq(expected)
    end

    it 'without organ and subnet' do
      expected = [
        [budget_program.title, budget_program.id, { other_organs: false }],
        [budget_program_subnet.title, budget_program_subnet.id, { other_organs: false }],
        [budget_program_organ.title, budget_program_organ.id, { other_organs: false }]
      ]

      expect(budget_programs_for_select).to match_array(expected)
    end
  end

  context 'service_types_for_select' do

    let(:service_type_without_organ) { create(:service_type, organ: nil) }
    let(:other_organs) { create(:service_type, :other_organs) }
    let(:subnet) { create(:subnet) }
    let(:service_type_subnet) { create(:service_type, subnet: subnet) }

    before do
      service_type_without_organ
      other_organs
    end

    it 'with organ' do
      expected = [
        [service_type.title, service_type.id, { other_organs: false }],
        [service_type_without_organ.title, service_type_without_organ.id, { other_organs: false }]
      ].sort

      expect(service_types_for_select(organ)).to eq(expected)
    end

    it 'with subnet' do
      expected = [
        [service_type_subnet.title, service_type_subnet.id, { other_organs: false }],
        [service_type_without_organ.title, service_type_without_organ.id, { other_organs: false }]
      ].sort

      expect(service_types_for_select(organ, subnet)).to eq(expected)
    end

    it 'without organ' do
      expected = [
        [service_type_without_organ.title, service_type_without_organ.id, { other_organs: false }]
      ].sort

      expect(service_types_for_select).to eq(expected)
    end

  end
end
