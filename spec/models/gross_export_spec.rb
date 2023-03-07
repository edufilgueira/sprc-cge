require 'rails_helper'

describe GrossExport do
  let(:date) { Date.today }
  let(:beginning_date) { date.beginning_of_month }
  let(:end_date) { date.end_of_month }
  subject(:gross_export) { build(:gross_export) }

  describe 'factory' do
    it { is_expected.to be_valid }
  end

  describe 'db' do
    describe 'columns' do
      it { is_expected.to have_db_column(:user_id).of_type(:integer) }
      it { is_expected.to have_db_column(:title).of_type(:string) }
      it { is_expected.to have_db_column(:filters).of_type(:text) }
      it { is_expected.to have_db_column(:status).of_type(:integer) }
      it { is_expected.to have_db_column(:filename).of_type(:string) }
      it { is_expected.to have_db_column(:processed).of_type(:integer) }
      it { is_expected.to have_db_column(:total).of_type(:integer) }
      it { is_expected.to have_db_column(:load_creator_info).of_type(:boolean).with_options(default: false) }
      it { is_expected.to have_db_column(:load_description).of_type(:boolean).with_options(default: false) }
      it { is_expected.to have_db_column(:load_answers).of_type(:boolean).with_options(default: false) }
      # Audits
      it { is_expected.to have_db_column(:created_at).of_type(:datetime) }
      it { is_expected.to have_db_column(:updated_at).of_type(:datetime) }
    end
  end

  describe 'enums' do
    it 'status' do
      expected_statuses = [:preparing, :generating, :error, :success]

      is_expected.to define_enum_for(:status).with_values(expected_statuses)
    end
  end

  describe 'serializations' do
    # https://github.com/thoughtbot/shoulda-matchers/issues/913
    it { expect(gross_export.filters).to be_a Hash }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:user) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:user) }
    it { is_expected.to validate_presence_of(:status) }
  end

  describe 'scopes' do
    it 'sorted' do
      expect(GrossExport.sorted).to eq(GrossExport.order(created_at: :desc))
    end
  end

  describe 'helpers' do
    it 'status_str' do
      expected = I18n.t("gross_export.statuses.#{gross_export.status}")

      expect(gross_export.status_str).to eq(expected)
    end

    it 'progress' do
      gross_export.processed = 13
      gross_export.total_to_process = 59

      expected = ((13/59.to_f)*100).to_i
      expect(gross_export.progress).to eq(expected)

      gross_export.processed = 0
      gross_export.total_to_process = 0

      expected = 0
      expect(gross_export.progress).to eq(expected)
    end

    it 'processing?' do
      gross_export.status = :preparing
      expect(gross_export).to be_processing

      gross_export.status = :generating
      expect(gross_export).to be_processing

      gross_export.status = :success
      expect(gross_export).not_to be_processing

      gross_export.status = :error
      expect(gross_export).not_to be_processing
    end

    it 'file' do
      gross_export.filters[:confirmed_at] =  { start: beginning_date, end: end_date}
      gross_export.save
      CreateGrossExportSpreadsheet.call(gross_export.id)
      expect(gross_export.file.path).to eq(File.new(gross_export.file_path).path)
    end
  end

  describe 'filters' do
    it 'ticket_type' do
      sic_ticket = create(:ticket, :confirmed, ticket_type: :sic)
      sou_ticket = create(:ticket, :confirmed, ticket_type: :sou)

      filters = { ticket_type: :sou }


      gross_export.filters = filters


      expect(gross_export.filtered_scope).to eq([sou_ticket])
    end

    it 'organ' do
      organ = create(:executive_organ)
      another_organ = create(:executive_organ)

      ticket_with_organ = create(:ticket, :with_parent, organ: organ)
      ticket_with_another_organ = create(:ticket, :with_parent, organ: another_organ)

      gross_export.filters[:organ] = organ.id

      expect(gross_export.filtered_scope).to eq([ticket_with_organ])
    end

    it 'topic' do
      ticket = create(:ticket, :confirmed, :with_classification)
      create(:ticket, :confirmed, :with_classification)

      classification = ticket.classification
      topic = classification.topic

      gross_export.filters = { topic: topic.id }

      expect(gross_export.filtered_scope).to eq([ticket])
    end

    it 'subtopic' do
      ticket = create(:ticket, :confirmed, :with_classification_with_subtopic)
      create(:ticket, :confirmed, :with_classification_with_subtopic)

      classification = ticket.classification
      topic = classification.topic
      subtopic = classification.subtopic


      gross_export.filters[:subtopic] = subtopic.id

      expect(gross_export.filtered_scope).to eq([ticket])
    end

    it 'sou_type' do
      phone_ticket = create(:ticket, :confirmed, used_input: :phone)
      letter_ticket = create(:ticket, :confirmed, used_input: :letter)

      filters = { ticket_type: :sou , used_input: :phone}


      gross_export.filters = filters


      expect(gross_export.filtered_scope).to eq([phone_ticket])
    end

    it 'protocol' do
      ticket = create(:ticket, :confirmed, :with_parent)
      create(:ticket, :confirmed, used_input: :letter)
      parent_protocol = ticket.parent_protocol

      filters = { ticket_type: :sou , parent_protocol: parent_protocol}

      gross_export.filters = filters

      expect(gross_export.filtered_scope).to eq([ticket])
    end

    it 'subnet' do
      ticket = create(:ticket, :confirmed, :with_subnet)
      create(:ticket, :confirmed, used_input: :letter)
      subnet = ticket.subnet

      filters = { ticket_type: :sou , subnet: subnet.id}

      gross_export.filters = filters

      expect(gross_export.filtered_scope).to eq([ticket])
    end

    it 'budget_program' do
      ticket = create(:ticket, :confirmed, :with_classification)
      create(:ticket, :confirmed, :with_classification)

      classification = ticket.classification
      budget_program = classification.budget_program

      gross_export.filters[:budget_program] = budget_program.id

      expect(gross_export.filtered_scope).to eq([ticket])
    end

    it 'department' do
      ticket = create(:ticket, :confirmed, :with_classification)
      create(:ticket, :confirmed, :with_classification)

      classification = ticket.classification
      department = classification.department

      gross_export.filters[:department] = department.id

      expect(gross_export.filtered_scope).to eq([ticket])
    end

    it 'sub_department' do
      ticket = create(:ticket, :confirmed, :with_classification)
      create(:ticket, :confirmed, :with_classification)

      classification = ticket.classification
      sub_department = classification.sub_department

      gross_export.filters[:sub_department] = sub_department.id

      expect(gross_export.filtered_scope).to eq([ticket])
    end

    it 'service_type' do
      ticket = create(:ticket, :confirmed, :with_classification)
      create(:ticket, :confirmed, :with_classification)

      classification = ticket.classification
      service_type = classification.service_type

      gross_export.filters[:service_type] = service_type.id

      expect(gross_export.filtered_scope).to eq([ticket])
    end

    it 'answer_type' do
      phone_ticket = create(:ticket, :confirmed, :answer_by_phone)
      letter_ticket = create(:ticket, :confirmed, :answer_by_letter)

      filters = { ticket_type: :sou , answer_type: :phone}

      gross_export.filters = filters

      expect(gross_export.filtered_scope).to eq([phone_ticket])
    end

    it 'deadline' do
      ticket = create(:ticket, :confirmed, deadline: 2)
      create(:ticket, :confirmed, deadline: -13)

      gross_export.filters[:deadline] = :not_expired

      expect(gross_export.filtered_scope).to eq([ticket])
    end

    it 'denunciation' do
      create(:ticket, :confirmed, internal_status: :in_filling)
      create(:ticket, :confirmed, :invalidated)
      ticket_denunciation = create(:ticket, :denunciation)

      gross_export.filters[:denunciation] = true

      expect(gross_export.filtered_scope.sort).to eq([ticket_denunciation])
    end

    context 'expired' do
      it 'selected' do
        expired_ticket = create(:ticket, :confirmed, deadline: -1)
        not_expired_ticket = create(:ticket, :confirmed, deadline: 1)

        gross_export.filters[:expired] = 1

        expect(gross_export.filtered_scope).to eq([expired_ticket])
      end

      it 'not selected' do
        expired_ticket = create(:ticket, :confirmed, deadline: -1)
        not_expired_ticket = create(:ticket, :confirmed, deadline: 1)

        gross_export.filters[:expired] = 0

        expect(gross_export.filtered_scope).to match_array([not_expired_ticket, expired_ticket])
      end
    end

    it 'priority' do
      ticket = create(:ticket, :confirmed, priority: true)
      create(:ticket, :confirmed, priority: false)

      gross_export.filters[:priority] = true

      expect(gross_export.filtered_scope).to eq([ticket])
    end

    it 'search' do
      ticket = create(:ticket, :confirmed, email: '123456@example.com')
      create(:ticket, :confirmed, email: '7890@example.com')

      gross_export.filters[:search] = '1 4 6 @'

      expect(gross_export.filtered_scope).to eq([ticket])
    end

    it 'sou_type' do
      compliment_ticket = create(:ticket, :confirmed, sou_type: :compliment)
      suggestion_ticket = create(:ticket, :confirmed, sou_type: :suggestion)

      filters = { ticket_type: :sou , sou_type: :compliment}


      gross_export.filters = filters


      expect(gross_export.filtered_scope).to eq([compliment_ticket])
    end

    it 'internal_status' do
      ticket = create(:ticket, :confirmed, internal_status: :final_answer)
      create(:ticket, :confirmed)

      gross_export.filters[:internal_status] = :final_answer

      expect(gross_export.filtered_scope).to eq([ticket])
    end

    context 'departments_deadline' do
      let(:user) { create(:user, :operator_sectoral) }
      let(:internal_department) { create(:department) }

      let(:not_expired) do
        ticket = create(:ticket, :with_parent)
        create(:ticket_department, deadline: 2, ticket: ticket)
        ticket
      end

      let(:expired_can_extend) do
        ticket_days = Ticket::LIMIT_TO_EXTEND_DEADLINE - 1
        in_limit = DateTime.now - ticket_days.days
        internal_expired = create(:ticket, :confirmed, :with_organ, internal_status: :internal_attendance)
        create(:ticket_department, department: internal_department, ticket: internal_expired, deadline: Ticket::SOU_DEADLINE - ticket_days, created_at: in_limit)
        internal_expired
      end

      let(:expired) do
        ticket = create(:ticket, :confirmed, :with_organ, extended: true)
        create(:ticket_department, department: internal_department, deadline: -1, ticket: ticket)
        ticket
      end

      before do
        not_expired
        expired_can_extend
        expired
      end

      it 'not_expired' do
        gross_export.filters[:departments_deadline] = :not_expired

        expect(gross_export.filtered_scope).to eq([not_expired])
      end

      it 'expired_can_extend' do
        gross_export.filters[:departments_deadline] = :expired_can_extend

        expect(gross_export.filtered_scope).to eq([expired_can_extend])
      end

      it 'expired' do
        gross_export.filters[:departments_deadline] = :expired

        expect(gross_export.filtered_scope).to match_array([expired, expired_can_extend])
      end
    end

    it 'rede_ouvir_scope' do
      rede_ouvir_organ = create(:rede_ouvir_organ)
      executive_organ = create(:executive_organ)

      ticket_with_rede_ouvir_organ = create(:ticket, :with_parent, :with_rede_ouvir, organ: rede_ouvir_organ)
      ticket_with_executive_organ = create(:ticket, :with_parent, organ: executive_organ)

      gross_export.filters[:rede_ouvir_scope] = true

      expect(gross_export.filtered_scope).to eq([ticket_with_rede_ouvir_organ])
    end

    it 'without rede_ouvir_scope' do
      rede_ouvir_organ = create(:rede_ouvir_organ)
      executive_organ = create(:executive_organ)

      ticket_with_rede_ouvir_organ = create(:ticket, rede_ouvir: true, organ: rede_ouvir_organ)
      ticket_with_executive_organ = create(:ticket, organ: executive_organ)

      expect(gross_export.filtered_scope.count).to eq([ticket_with_executive_organ].count)
    end
  end

  describe 'callbacks' do

    context 'before_destroy' do
      it 'removes spreadsheet file before destroy' do
        gross_export.save

        expect(RemoveReportableSpreadsheet).to receive(:call).with(gross_export)

        gross_export.destroy
      end
    end

    context 'before_save' do
      it 'clear empty filters' do

        gross_export.filters = {
          ticket_type: :sou,
          organ: '',
          confirmed_at: {
            start: '',
            end: nil
          }
        }
        expected = {
          ticket_type: :sou
        }
        gross_export.save
        expect(gross_export.filters).to eq(expected)
      end
    end
  end
end
