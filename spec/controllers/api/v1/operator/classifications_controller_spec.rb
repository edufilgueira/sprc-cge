require 'rails_helper'

describe Api::V1::Operator::ClassificationsController do

  let(:user) { create(:user, :operator) }
  let(:empty_option) { { "#{I18n.t('messages.form.select')}": '' } }

  before { sign_in(user) }

  describe 'topics' do
    let(:organ) { create(:executive_organ) }
    let(:topic) { create(:topic) }
    let(:topic_with_organ) { create(:topic, organ: organ) }
    let(:topics_without_organ) { Topic.enabled.not_other_organs.where(organ: nil).sorted }
    let(:other_organs) { create(:topic, :other_organs) }
    let(:data) { JSON.parse(response.body) }
    let(:results) { data['results'].to_json }


    before do
      topic
      topic_with_organ
      other_organs
    end

    context 'with organ' do
      before { get(:topics, xhr: true, params: { organ: organ.id }) }
      let(:expected) do
        expected = {
          "#{topic.title}": topic.id,
          "#{topic_with_organ.title}": topic_with_organ.id
        }
        empty_option.merge(expected.sort.to_h).to_json
      end

      it { expect(results).to eq(expected) }
    end

    context 'without organ' do
      before { get(:topics, xhr: true) }

      let(:expected) do
        expected = {
          "#{topic.title}": topic.id
        }
        empty_option.merge(expected.sort.to_h).to_json
      end

      it { expect(results).to eq(expected) }
    end

    context 'with search paginated' do
      let!(:topics) { create_list(:topic, 10) }

      it "default per_page" do
        get(:topics, xhr: true, params: { page: '1' })

        topics = map_by_title(topics_without_organ.first(25))
        expected = empty_option.merge(topics).to_json

        expect(results).to eq(expected)
      end

      it "without params" do
        get(:topics, xhr: true)

        topics = map_by_title(topics_without_organ.first(25))
        expected = empty_option.merge(topics).to_json

        expect(results).to eq(expected)
      end

      context "params page" do
        it "page 1" do
          get(:topics, xhr: true, params: { page: '1' , per_page: '5'})

          topics = map_by_title(topics_without_organ.first(5))
          expected = empty_option.merge(topics).to_json

          expect(results).to eq(expected)
        end

        it "page 2" do
          get(:topics, xhr: true, params: { page: '2' , per_page: '5'})

          topics = map_by_title(topics_without_organ.limit(10).last(5))
          expected = topics.to_json

          expect(results).to eq(expected)
        end

        it "page default" do
          get(:topics, xhr: true, params: { per_page: '5'})

          topics = map_by_title(topics_without_organ.first(5))
          expected = empty_option.merge(topics).to_json

          expect(results).to eq(expected)
        end

        it "total_filtered" do
          get(:topics, xhr: true, params: { per_page: '5'})

          count = topics_without_organ.count
          topics = map_by_title(topics_without_organ.first(5))
          expected = empty_option.merge(topics).to_json

          expect(data['count_filtered']).to eq(count)
          expect(data['results'].length).not_to eq(count)
          expect(results).to eq(expected)
        end
      end

      context "with search params" do
        it "name" do
          topic = create(:topic, name: "gsn")

          get(:topics, xhr: true, params: { page: '1', term: 'gs' })

          topics = map_by_title([topic])
          expected = empty_option.merge(topics).to_json

          expect(results).to eq(expected)
        end

        it "acronym" do
          organ_acronym = create(:executive_organ, acronym: "gsn")
          topic = create(:topic, organ: organ_acronym)

          get(:topics, xhr: true, params: { page: '1', term: 'gs' , organ: organ_acronym.id})

          topics = map_by_title([topic])

          expected = empty_option.merge(topics).to_json

          expect(results).to eq(expected)
        end
      end
    end

    context 'without pagination' do
      it 'return all organ topics' do
        create(:topic, name: "topico com orgao", organ_id: organ.id)
        create(:topic, name: "topico sem orgao")

        get(:topics, xhr: true, params: { paginate: 'false', organ: organ.id })

        topics = Topic.where(organ: [organ.id, nil], other_organs: false).map do |r|
          { 'name': r.title, 'id': r.id}
        end.to_json

        expect(data).to eq(JSON.parse(topics))
      end

      it 'return all topics without organ' do
        create(:topic, name: "topico com orgao", organ_id: organ.id)
        create(:topic, name: "topico sem orgao")

        get(:topics, xhr: true, params: { paginate: 'false' })

        topics = Topic.where(organ: [nil], other_organs: false).map do |r|
          { 'name': r.title, 'id': r.id}
        end.to_json

        expect(data).to eq(JSON.parse(topics))
      end
    end
  end

  describe 'subtopics' do
    let(:topic) { create(:topic) }
    let(:subtopic) { create(:subtopic, topic: topic) }
    let(:other_organs) { create(:subtopic, :other_organs, topic: topic) }
    let(:other) { create(:subtopic) }
    let(:data) { JSON.parse(response.body) }
    let(:results) { data['results'].to_json }

    before do
      subtopic
      other
      other_organs
    end

    context 'with topic' do
      it 'default call' do
        get(:subtopics, xhr: true, params: { topic: topic.id })

        expected = {
          "#{subtopic.title}": subtopic.id
        }
        expected = empty_option.merge(expected.sort.to_h).to_json

        expect(results).to eq(expected)
      end

      context 'call with pagination' do
        let!(:created_subtopics) do
          create_list(:subtopic, 10, topic: topic)
          Subtopic.not_other_organs.where(topic: topic)
        end

        context "params page" do
          it "page 1" do
            get(:subtopics, xhr: true, params: { page: '1' , per_page: '5', topic: topic})

            subtopics = map_by_title(created_subtopics.order('name').first(5))
            expected = empty_option.merge(subtopics).to_json

            expect(results).to eq(expected)
          end

          it "page 2" do
            get(:subtopics, xhr: true, params: { page: '2' , per_page: '5', topic: topic})

            subtopics = map_by_title(created_subtopics.order('name').limit(10).last(5))
            expected = subtopics.to_json

            expect(results).to eq(expected)
          end

          it "page default" do
            get(:subtopics, xhr: true, params: { per_page: '5', topic: topic})

            subtopics = map_by_title(created_subtopics.order('name').first(5))
            expected = empty_option.merge(subtopics).to_json

            expect(results).to eq(expected)
          end

          it "total_filtered" do
            get(:subtopics, xhr: true, params: { per_page: '5', topic: topic})

            count = created_subtopics.count
            subtopics = map_by_title(created_subtopics.order('name').first(5))
            expected = empty_option.merge(subtopics).to_json

            expect(data['count_filtered']).to eq(count)
            expect(data['results'].length).not_to eq(count)
            expect(results).to eq(expected)
          end
        end

        context 'when subtopic is disabled' do
          it 'return only default option' do
            other_topic = create(:topic)
            subtopic = create(:subtopic, name: "gsn", topic: other_topic, disabled_at: Date.today)

            get(:subtopics, xhr: true, params: { page: '1', topic: other_topic})

            expected = empty_option.to_json

            expect(results).to eq(expected)
          end
        end

        context "with search params" do
          it "name" do
            subtopic = create(:subtopic, name: "gsn", topic: topic)

            get(:subtopics, xhr: true, params: { page: '1', term: 'gs', topic: topic})

            subtopics = map_by_title([subtopic])
            expected = empty_option.merge(subtopics).to_json

            expect(results).to eq(expected)
          end

          context 'when subtopic is disabled' do
            it 'return only default option' do
              subtopic = create(:subtopic, name: "gsn", topic: topic, disabled_at: Date.today)

              get(:subtopics, xhr: true, params: { page: '1', term: 'gs', topic: topic})

              expected = empty_option.to_json

              expect(results).to eq(expected)
            end
          end
        end
      end
    end

    context 'without topic' do
      before { get(:subtopics, xhr: true) }
      let(:expected) { empty_option.to_json }

      it { expect(results).to eq(expected) }
    end
  end

  describe 'departments' do
    let(:department) { create(:department) }
    let(:organ) { department.organ }
    let(:other) { create(:department) }
    let(:data) { JSON.parse(response.body) }
    let(:results) { data['results'].to_json }

    before do
      department
      other
    end

    context 'with organ' do

      it 'default call' do
        get(:departments, xhr: true, params: { organ: organ.id })

        expected = {
          "#{department.title}": department.id
        }
        expected = empty_option.merge(expected.sort.to_h).to_json

        expect(results).to eq(expected)
      end

      context 'call with pagination' do
        let(:organ) { create(:executive_organ) }
        let!(:created_departments) do
          create_list(:department, 10, organ: organ)
          Department.where(organ: organ).sorted
        end

        context "params page" do
          it "page 1" do
            get(:departments, xhr: true, params: { page: '1' , per_page: '5', organ: organ})

            departments = map_by_title(created_departments.sorted.first(5))
            expected = empty_option.merge(departments).to_json

            expect(results).to eq(expected)
          end

          it "page 2" do
            get(:departments, xhr: true, params: { page: '2' , per_page: '5', organ: organ})

            departments = map_by_title(created_departments.sorted.limit(10).last(5))
            expected = departments.to_json

            expect(results).to eq(expected)
          end

          it "page default" do
            get(:departments, xhr: true, params: { per_page: '5', organ: organ})

            departments = map_by_title(created_departments.sorted.first(5))
            expected = empty_option.merge(departments).to_json

            expect(results).to eq(expected)
          end

          it "total_filtered" do
            get(:departments, xhr: true, params: { per_page: '5', organ: organ})

            count = created_departments.count
            departments = map_by_title(created_departments.sorted.first(5))
            expected = empty_option.merge(departments).to_json

            expect(data['count_filtered']).to eq(count)
            expect(data['results'].length).not_to eq(count)
            expect(results).to eq(expected)
          end
        end

        context "with search params" do
          it "name" do
            department = create(:department, name: "gsn", organ: organ)

            get(:departments, xhr: true, params: { page: '1', term: 'gs', organ: organ})

            departments = map_by_title([department])
            expected = empty_option.merge(departments).to_json

            expect(results).to eq(expected)
          end

          it "organ acronym" do
            organ_acronym = create(:executive_organ, acronym: "gsn")
            department = create(:department, organ: organ_acronym)

            get(:departments, xhr: true, params: { page: '1', term: 'gs' , organ: organ_acronym.id})

            departments = map_by_title([department])

            expected = empty_option.merge(departments).to_json

            expect(results).to eq(expected)
          end

         it "subnet acronym" do
            subnet_organ = create(:executive_organ, :with_subnet)
            subnet = create(:subnet, organ: subnet_organ, acronym: 'GSN')
            department = create(:department, :with_subnet, subnet: subnet)

            get(:departments, xhr: true, params: { page: '1', term: 'gs' , organ: subnet_organ.id, subnet: subnet})

            departments = map_by_title([department])

            expected = empty_option.merge(departments).to_json

            expect(results).to eq(expected)
          end

          it "acronym" do
            department = create(:department, acronym: "gsn", organ: organ)

            get(:departments, xhr: true, params: { page: '1', term: 'gs', organ: organ})

            departments = map_by_title([department])
            expected = empty_option.merge(departments).to_json

            expect(results).to eq(expected)
          end
        end
      end
    end

    context 'without organ' do
      before { get(:departments, xhr: true) }
      let(:departments_hash) { Department.all.sorted.map { |r| [r.title, r.id] }.to_h }
      let(:expected) { empty_option.merge(departments_hash).to_json }

      it { expect(results).to eq(expected) }
    end

    context 'with subnet organ' do
      it 'default call' do
        subnet_organ = create(:executive_organ, :with_subnet)
        subnet = create(:subnet, organ: subnet_organ)
        department = create(:department, :with_subnet, subnet: subnet)
        department_organ = create(:department, organ: subnet_organ)

        get(:departments, xhr: true, params: { organ: subnet_organ.id, subnet: subnet.id})

        expected = {
          "#{department.title}": department.id
        }
        expected = empty_option.merge(expected.to_h).to_json

        expect(results).to eq(expected)
      end
    end
  end

  describe 'sub_departments' do
    let(:sub_department) { create(:sub_department) }
    let(:department) { sub_department.department }
    let(:other) { create(:sub_department) }
    let(:data) { JSON.parse(response.body) }
    let(:results) { data['results'].to_json }

    before do
      sub_department
      other
    end

    context 'with department' do
      it 'default call' do
        get(:sub_departments, xhr: true, params: { classification_department: department.id })

        expected = {
          "#{sub_department.title}": sub_department.id
        }
        expected = empty_option.merge(expected.sort.to_h).to_json

        expect(results).to eq(expected)
      end

      context 'call with pagination' do
        let(:organ) { create(:executive_organ) }
        let(:department) { create(:department, organ: organ)}
        let!(:created_sub_departments) do
          create_list(:sub_department, 10, department: department)
          SubDepartment.where(department: department)
        end

        context "params page" do
          it "page 1" do
            get(:sub_departments, xhr: true, params: { page: '1' , per_page: '5', department: department})

            sub_departments = map_by_title(created_sub_departments.first(5))
            expected = empty_option.merge(sub_departments).to_json

            expect(results).to eq(expected)
          end

          it "page 2" do
            get(:sub_departments, xhr: true, params: { page: '2' , per_page: '5', department: department})

            sub_departments = map_by_title(created_sub_departments.limit(10).last(5))
            expected = sub_departments.to_json

            expect(results).to eq(expected)
          end

          it "page default" do
            get(:sub_departments, xhr: true, params: { per_page: '5', department: department})

            sub_departments = map_by_title(created_sub_departments.first(5))
            expected = empty_option.merge(sub_departments).to_json

            expect(results).to eq(expected)
          end

          it "total_filtered" do
            get(:sub_departments, xhr: true, params: { per_page: '5', department: department})

            count = created_sub_departments.count
            sub_departments = map_by_title(created_sub_departments.first(5))
            expected = empty_option.merge(sub_departments).to_json

            expect(data['count_filtered']).to eq(count)
            expect(data['results'].length).not_to eq(count)
            expect(results).to eq(expected)
          end

          it "by organ" do
            new_organ = create(:executive_organ)
            new_department = create(:department, organ: new_organ)
            create(:sub_department, department_id: new_department.id)
            get(:sub_departments, xhr: true, params: { per_page: '5', organ: new_organ })

            filtered_result = map_by_title(SubDepartment.where(department_id: new_department.id))
            expected = empty_option.merge(filtered_result).to_json
            expect(results).to eq(expected)
          end
        end

        context "with search params" do
          it "name" do
            sub_department = create(:sub_department, name: "gsn", department: department)

            get(:sub_departments, xhr: true, params: { page: '1', term: 'gs', department: department})

            sub_departments = map_by_title([sub_department])
            expected = empty_option.merge(sub_departments).to_json

            expect(results).to eq(expected)
          end

          it "department acronym" do
            department_acronym = create(:department, acronym: "gsn")
            sub_department = create(:sub_department, department: department_acronym)

            get(:sub_departments, xhr: true, params: { page: '1', term: 'gs' , department: department_acronym})

            sub_departments = map_by_title([sub_department])

            expected = empty_option.merge(sub_departments).to_json

            expect(results).to eq(expected)
          end

          it "acronym" do
            sub_department = create(:sub_department, acronym: "gsn", department: department)

            get(:sub_departments, xhr: true, params: { page: '1', term: 'gs', department: department})

            sub_departments = map_by_title([sub_department])
            expected = empty_option.merge(sub_departments).to_json

            expect(results).to eq(expected)
          end
        end
      end
    end

    context 'without department' do
      before { get(:sub_departments, xhr: true) }
      let(:sub_departments_hash) { SubDepartment.all.sorted.map { |r| [r.title, r.id] }.to_h }
      let(:expected) { empty_option.merge(sub_departments_hash).to_json }

      it { expect(results).to eq(expected) }
    end
  end

  describe 'service_types' do
    let(:service_type) { create(:service_type) }
    let(:organ) { service_type.organ }
    let(:service_type_without_organ) { create(:service_type, organ: nil) }
    let(:other_organs) { create(:service_type, :other_organs) }
    let(:data) { JSON.parse(response.body) }
    let(:results) { data['results'].to_json }

    before do
      service_type
      service_type_without_organ
      other_organs
    end

    context 'with subnet' do
      let(:service_type) { create(:service_type, subnet: create(:subnet)) }
      let(:subnet) { service_type.subnet }

      before { get(:service_types, xhr: true, params: { subnet: subnet.id }) }

      let(:expected) do
        expected = {
          "#{service_type.title}": service_type.id,
          "#{service_type_without_organ.title}": service_type_without_organ.id
        }

        empty_option.merge(expected).to_json
      end

      it {
        expect(results).to eq(expected)
      }
    end

    context 'with organ' do

      before { get(:service_types, xhr: true, params: { organ: organ.id }) }

      let(:expected) do
        expected = {
          "#{service_type.title}": service_type.id,
          "#{service_type_without_organ.title}": service_type_without_organ.id
        }
        empty_option.merge(expected).to_json
      end

      it { expect(results).to eq(expected) }
    end

    context 'without organ' do
      before { get(:service_types, xhr: true) }
      let(:expected) do
        expected = {
          "#{service_type_without_organ.title}": service_type_without_organ.id
        }
        empty_option.merge(expected.sort.to_h).to_json
      end

      it { expect(results).to eq(expected) }
    end

    context 'with search paginated' do
      let!(:service_types) { create_list(:service_type, 10, organ: nil) }
      let(:service_types_without_organ) { ServiceType.enabled.not_other_organs.where(organ: nil).sorted }

      it "default per_page" do
        get(:service_types, xhr: true, params: { page: '1' })

        service_types = map_by_title(service_types_without_organ.first(25))
        expected = empty_option.merge(service_types).to_json

        expect(results).to eq(expected)
      end

      it "without params" do
        get(:service_types, xhr: true)

        service_types = map_by_title(service_types_without_organ.first(25))
        expected = empty_option.merge(service_types).to_json

        expect(results).to eq(expected)
      end

      context "params page" do
        it "page 1" do
          get(:service_types, xhr: true, params: { page: '1' , per_page: '5'})

          service_types = map_by_title(service_types_without_organ.first(5))
          expected = empty_option.merge(service_types).to_json

          expect(results).to eq(expected)
        end

        it "page 2" do
          get(:service_types, xhr: true, params: { page: '2' , per_page: '5'})

          service_types = map_by_title(service_types_without_organ.limit(10).last(5))
          expected = service_types.to_json

          expect(results).to eq(expected)
        end

        it "page default" do
          get(:service_types, xhr: true, params: { per_page: '5'})

          service_types = map_by_title(service_types_without_organ.first(5))
          expected = empty_option.merge(service_types).to_json

          expect(results).to eq(expected)
        end

        it "total_filtered" do
          get(:service_types, xhr: true, params: { per_page: '5'})

          count = service_types_without_organ.count
          service_types = map_by_title(service_types_without_organ.first(5))
          expected = empty_option.merge(service_types).to_json

          expect(data['count_filtered']).to eq(count)
          expect(data['results'].length).not_to eq(count)
          expect(results).to eq(expected)
        end
      end

      context "with search params" do
        it "name" do
          service_type = create(:service_type, name: "gsn")

          get(:service_types, xhr: true, params: { page: '1', term: 'gs', organ: service_type.organ.id })

          service_types = map_by_title([service_type])
          expected = empty_option.merge(service_types).to_json

          expect(results).to eq(expected)
        end

        it "acronym" do
          organ_acronym = create(:executive_organ, acronym: "gsn")
          service_type = create(:service_type, organ: organ_acronym)

          get(:service_types, xhr: true, params: { page: '1', term: 'gs', organ: organ_acronym.id })

          service_types = map_by_title([service_type])
          expected = empty_option.merge(service_types).to_json

          expect(results).to eq(expected)
        end
      end
    end
  end

  describe 'budget_programs' do
    let(:organ) { create(:executive_organ) }
    let(:budget_program) { create(:budget_program, organ: organ) }
    let(:other_organ) { create(:executive_organ) }
    let(:other) { create(:budget_program, organ: other_organ) }
    let(:other_organs) { create(:budget_program, :other_organs) }
    let(:data) { JSON.parse(response.body) }
    let(:results) { data['results'].to_json }

    before do
      budget_program
      other
      other_organs
    end

    context 'with organ' do

      it 'default call' do
        get(:budget_programs, xhr: true, params: { organ: organ.id })

        expected = {
          "#{budget_program.title}": budget_program.id
        }
        expected = empty_option.merge(expected.sort.to_h).to_json

        expect(results).to eq(expected)
      end

      context 'call with pagination' do
        let(:organ) { create(:executive_organ) }
        let!(:created_budget_programs) do
          create_list(:budget_program, 10, organ: organ)
          BudgetProgram.not_other_organs.where(organ: organ).sorted
        end

        context "params page" do
          it "page 1" do
            get(:budget_programs, xhr: true, params: { page: '1' , per_page: '5', organ: organ})

            budget_programs = map_by_title(created_budget_programs.first(5))
            expected = empty_option.merge(budget_programs).to_json

            expect(results).to eq(expected)
          end

          it "page 2" do
            get(:budget_programs, xhr: true, params: { page: '2' , per_page: '5', organ: organ})

            budget_programs = map_by_title(created_budget_programs.limit(10).last(5))
            expected = budget_programs.to_json

            expect(results).to eq(expected)
          end

          it "page default" do
            get(:budget_programs, xhr: true, params: { per_page: '5', organ: organ})

            budget_programs = map_by_title(created_budget_programs.first(5))
            expected = empty_option.merge(budget_programs).to_json

            expect(results).to eq(expected)
          end

          it "total_filtered" do
            get(:budget_programs, xhr: true, params: { per_page: '5', organ: organ})

            count = created_budget_programs.count
            budget_programs = map_by_title(created_budget_programs.first(5))
            expected = empty_option.merge(budget_programs).to_json

            expect(data['count_filtered']).to eq(count)
            expect(data['results'].length).not_to eq(count)
            expect(results).to eq(expected)
          end
        end

        context "with search params" do
          it "name" do
            budget_program = create(:budget_program, name: "gsn", organ: organ)

            get(:budget_programs, xhr: true, params: { page: '1', term: 'gs', organ: organ.id})

            budget_programs = map_by_title([budget_program])
            expected = empty_option.merge(budget_programs).to_json

            expect(results).to eq(expected)
          end

          it "organ acronym" do
            organ_acronym = create(:executive_organ, acronym: "gsn")
            budget_program = create(:budget_program, organ: organ_acronym)

            get(:budget_programs, xhr: true, params: { page: '1', term: 'gs' , organ: organ_acronym.id})

            budget_programs = map_by_title([budget_program])

            expected = empty_option.merge(budget_programs).to_json

            expect(results).to eq(expected)
          end

         it "subnet acronym" do
            subnet_organ = create(:executive_organ, :with_subnet)
            subnet = create(:subnet, organ: subnet_organ, acronym: 'GSN')
            budget_program = create(:budget_program, :with_subnet, subnet: subnet)

            get(:budget_programs, xhr: true, params: { page: '1', term: 'gs' , organ: subnet_organ.id, subnet: subnet})

            budget_programs = map_by_title([budget_program])

            expected = empty_option.merge(budget_programs).to_json

            expect(results).to eq(expected)
          end
        end
      end
    end

    context 'without organ' do
      before { get(:budget_programs, xhr: true) }
      let(:budget_programs_hash) { BudgetProgram.not_other_organs.enabled.sorted.where(organ: nil).map { |r| [r.title, r.id] }.to_h }
      let(:expected) { empty_option.merge(budget_programs_hash).to_json }

      it { expect(results).to eq(expected) }
    end

    context 'with subnet organ' do
      it 'default call' do
        subnet_organ = create(:executive_organ, :with_subnet)
        subnet = create(:subnet, organ: subnet_organ)
        budget_program = create(:budget_program, :with_subnet, subnet: subnet)
        budget_program_organ = create(:budget_program, organ: subnet_organ)

        get(:budget_programs, xhr: true, params: { organ: subnet_organ.id, subnet: subnet.id})

        expected = {
          "#{budget_program.title}": budget_program.id,
          "#{budget_program_organ.title}": budget_program_organ.id
        }
        expected = empty_option.merge(expected.to_h).to_json

        expect(results).to eq(expected)
      end
    end
  end

  private

  def map_by_title(objects)
    objects.map { |r| [r.title, r.id ] }.to_h
  end
end
