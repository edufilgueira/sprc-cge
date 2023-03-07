require 'rails_helper'

describe TicketReport do
  subject(:ticket_report) { build(:ticket_report) }

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
    it { expect(ticket_report.filters).to be_a Hash }
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
      expect(TicketReport.sorted).to eq(TicketReport.order(created_at: :desc))
    end
  end

  describe 'helpers' do
    it 'status_str' do
      expected = I18n.t("ticket_report.statuses.#{ticket_report.status}")

      expect(ticket_report.status_str).to eq(expected)
    end

    it 'progress' do
      ticket_report.processed = 13
      ticket_report.total_to_process = 59

      expected = ((13/59.to_f)*100).to_i
      expect(ticket_report.progress).to eq(expected)

      ticket_report.processed = 0
      ticket_report.total_to_process = 0

      expected = 0
      expect(ticket_report.progress).to eq(expected)
    end

    it 'processing?' do
      ticket_report.status = :preparing
      expect(ticket_report).to be_processing

      ticket_report.status = :generating
      expect(ticket_report).to be_processing

      ticket_report.status = :success
      expect(ticket_report).not_to be_processing

      ticket_report.status = :error
      expect(ticket_report).not_to be_processing
    end

    it 'file' do
      ticket_report.save
      CreateTicketReportSpreadsheet.call(ticket_report.id)
      expect(ticket_report.file.path).to eq(File.new(ticket_report.file_path).path)
    end
  end

  describe 'filters' do
    it 'ticket_type' do
      sic_ticket = create(:ticket, :confirmed, ticket_type: :sic)
      sou_ticket = create(:ticket, :confirmed, ticket_type: :sou)

      filters = { ticket_type: :sou }


      ticket_report.filters = filters


      expect(ticket_report.filtered_scope).to eq([sou_ticket])
    end

    context 'expired' do
      it 'selected' do
        expired_ticket = create(:ticket, :confirmed, deadline: -1)
        not_expired_ticket = create(:ticket, :confirmed, deadline: 1)

        ticket_report.filters[:expired] = 1

        expect(ticket_report.filtered_scope).to eq([expired_ticket])
      end

      it 'not selected' do
        expired_ticket = create(:ticket, :confirmed, deadline: -1)
        not_expired_ticket = create(:ticket, :confirmed, deadline: 1)

        ticket_report.filters[:expired] = 0

        expect(ticket_report.filtered_scope).to match_array([not_expired_ticket, expired_ticket])
      end
    end

    it 'organ' do
      organ = create(:executive_organ)
      another_organ = create(:executive_organ)

      ticket_with_organ = create(:ticket, :with_parent, organ: organ)
      ticket_with_another_organ = create(:ticket, :with_parent, organ: another_organ)

      ticket_report.filters[:organ] = organ.id

      expect(ticket_report.filtered_scope).to eq([ticket_with_organ])
    end

    context 'confirmed_at' do

      let(:ticket_old) { create(:ticket, :confirmed, confirmed_at: 20.days.ago.to_date) }
      let(:ticket_new) { create(:ticket, :confirmed, confirmed_at: Date.yesterday) }

      it 'empty start' do
        filters = {
          ticket_type: :sou,
          confirmed_at: {
            start: nil,
            end: 5.days.ago.to_date
          }
        }

        ticket_report.filters = filters

        expect(ticket_report.filtered_scope).to eq([ticket_old])
      end

      it 'empty end' do
        filters = {
          ticket_type: :sou,
          confirmed_at: {
            start: 5.days.ago.to_date,
            end: nil
          }
        }

        ticket_report.filters = filters

        expect(ticket_report.filtered_scope).to eq([ticket_new])
      end

      it 'empty start and end' do
        filters = {
          ticket_type: :sou,
          confirmed_at: {
            start: nil,
            end: nil
          }
        }

        ticket_report.filters = filters

        expect(ticket_report.filtered_scope).to match_array([ticket_old, ticket_new])
      end

      it 'with start and end' do

        filters = {
          ticket_type: :sou,
          confirmed_at: {
            start: 5.days.ago.to_date,
            end: Date.today
          }
        }

        ticket_report.filters = filters

        expect(ticket_report.filtered_scope).to eq([ticket_new])
      end
    end

    it 'budget_program' do
      ticket = create(:ticket, :confirmed, :with_classification)
      create(:ticket, :confirmed, :with_classification)

      classification = ticket.classification
      budget_program = classification.budget_program

      ticket_report.filters[:budget_program] = budget_program.id

      expect(ticket_report.filtered_scope).to eq([ticket])
    end

    it 'topic' do
      ticket = create(:ticket, :confirmed, :with_classification)
      create(:ticket, :confirmed, :with_classification)

      classification = ticket.classification
      topic = classification.topic

      ticket_report.filters = { topic: topic.id }

      expect(ticket_report.filtered_scope).to eq([ticket])
    end

    it 'subtopic' do
      ticket = create(:ticket, :confirmed, :with_classification_with_subtopic)
      create(:ticket, :confirmed, :with_classification_with_subtopic)

      classification = ticket.classification
      topic = classification.topic
      subtopic = classification.subtopic


      ticket_report.filters[:subtopic] = subtopic.id

      expect(ticket_report.filtered_scope).to eq([ticket])
    end

    it 'deadline' do
      ticket = create(:ticket, :confirmed, deadline: 2)
      create(:ticket, :confirmed, deadline: -13)

      ticket_report.filters[:deadline] = :not_expired

      expect(ticket_report.filtered_scope).to eq([ticket])
    end

    it 'priority' do
      ticket = create(:ticket, :confirmed, priority: true)
      create(:ticket, :confirmed, priority: false)

      ticket_report.filters[:priority] = true

      expect(ticket_report.filtered_scope).to eq([ticket])
    end

    it 'with finalized' do
      ticket_in_filling = create(:ticket, :confirmed, internal_status: :in_filling)
      ticket_sectoral_attendance = create(:ticket, :confirmed, :in_sectoral_attendance)
      ticket_final_answer = create(:ticket, :confirmed, internal_status: :final_answer)
      ticket_confirmed = create(:ticket, :confirmed)

      ticket_report.filters[:finalized] = true

      expect(ticket_report.filtered_scope.sort.map{|t| t.id}).to eq([ticket_in_filling, ticket_sectoral_attendance, ticket_final_answer, ticket_confirmed].map{|t| t.id})
    end

    it 'internal_status' do
      ticket = create(:ticket, :confirmed, internal_status: :final_answer)
      create(:ticket, :confirmed)

      ticket_report.filters[:internal_status] = :final_answer

      expect(ticket_report.filtered_scope).to eq([ticket])
    end

    it 'search' do
      ticket = create(:ticket, :confirmed, email: '123456@example.com')
      create(:ticket, :confirmed, email: '7890@example.com')

      ticket_report.filters[:search] = '1 4 6 @'

      expect(ticket_report.filtered_scope).to eq([ticket])
    end

    it 'denunciation' do
      create(:ticket, :confirmed, internal_status: :in_filling)
      create(:ticket, :confirmed, :invalidated)
      ticket_denunciation = create(:ticket, :denunciation)

      ticket_report.filters[:denunciation] = true

      expect(ticket_report.filtered_scope.sort).to eq([ticket_denunciation])
    end

    it 'sou_type' do
      compliment_ticket = create(:ticket, :confirmed, sou_type: :compliment)
      suggestion_ticket = create(:ticket, :confirmed, sou_type: :suggestion)

      filters = { ticket_type: :sou , sou_type: :compliment}


      ticket_report.filters = filters


      expect(ticket_report.filtered_scope).to eq([compliment_ticket])
    end

    it 'sou_type' do
      compliment_ticket = create(:ticket, :confirmed, sou_type: :compliment)
      suggestion_ticket = create(:ticket, :confirmed, sou_type: :suggestion)

      filters = { ticket_type: :sou , sou_type: :compliment}


      ticket_report.filters = filters


      expect(ticket_report.filtered_scope).to eq([compliment_ticket])
    end

    it 'with state' do
      ticket = create(:ticket, :confirmed, :with_city)
      city_ticket = ticket.city

      other_ticket = create(:ticket, :confirmed, :with_city)

      filters = { ticket_type: :sou , state: city_ticket.state}


      ticket_report.filters = filters


      expect(ticket_report.filtered_scope).to eq([ticket])
    end

    it 'with city' do
      ticket = create(:ticket, :confirmed, :with_city)
      city_ticket = ticket.city

      other_ticket = create(:ticket, :confirmed, :with_city)

      filters = { ticket_type: :sou , city: city_ticket}


      ticket_report.filters = filters


      expect(ticket_report.filtered_scope).to eq([ticket])
    end

    it 'sou_type' do
      phone_ticket = create(:ticket, :confirmed, used_input: :phone)
      letter_ticket = create(:ticket, :confirmed, used_input: :letter)

      filters = { ticket_type: :sou , used_input: :phone}


      ticket_report.filters = filters


      expect(ticket_report.filtered_scope).to eq([phone_ticket])
    end

    it 'subnet' do
      ticket = create(:ticket, :confirmed, :with_subnet)
      create(:ticket, :confirmed, used_input: :letter)
      subnet = ticket.subnet

      filters = { ticket_type: :sou , subnet: subnet.id}

      ticket_report.filters = filters

      expect(ticket_report.filtered_scope).to eq([ticket])
    end

    context 'other_organs' do
      it 'only this filter' do
        ticket = create(:ticket, :confirmed, :with_classification_other_organs)
        create(:ticket, :confirmed, priority: false)

        ticket_report.filters[:other_organs] = true

        expect(ticket_report.filtered_scope).to eq([ticket])
      end

      it 'do not apply filter budget_program' do
        ticket_other = create(:ticket, :confirmed, :with_classification_other_organs)
        ticket = create(:ticket, :confirmed, :with_classification)
        create(:ticket, :confirmed, :with_classification)

        classification = ticket.classification
        budget_program = classification.budget_program

        ticket_report.filters[:budget_program] = budget_program.id
        ticket_report.filters[:other_organs] = true

        expect(ticket_report.filtered_scope).to eq([ticket_other])
      end

      it 'do not apply filter topic' do
        ticket_other = create(:ticket, :confirmed, :with_classification_other_organs)
        ticket = create(:ticket, :confirmed, :with_classification)
        create(:ticket, :confirmed, :with_classification)

        classification = ticket.classification
        topic = classification.topic

        ticket_report.filters[:topic] = topic.id
        ticket_report.filters[:other_organs] = true

        expect(ticket_report.filtered_scope).to eq([ticket_other])
      end

      it 'do not apply filter subtopic' do
        ticket_other = create(:ticket, :confirmed, :with_classification_other_organs)
        ticket = create(:ticket, :confirmed, :with_classification_with_subtopic)
        create(:ticket, :confirmed, :with_classification_with_subtopic)

        classification = ticket.classification
        topic = classification.topic
        subtopic = classification.subtopic


        ticket_report.filters[:subtopic] = subtopic.id
        ticket_report.filters[:other_organs] = true

        expect(ticket_report.filtered_scope).to eq([ticket_other])
      end
    end

    it 'rede_ouvir_scope' do
      rede_ouvir_organ = create(:rede_ouvir_organ)
      executive_organ = create(:executive_organ)

      ticket_with_rede_ouvir_organ = create(:ticket, :with_parent, :with_rede_ouvir, organ: rede_ouvir_organ)
      ticket_with_executive_organ = create(:ticket, :with_parent, organ: executive_organ)

      ticket_report.filters[:rede_ouvir_scope] = true

      expect(ticket_report.filtered_scope).to eq([ticket_with_rede_ouvir_organ])
    end

    it 'without rede_ouvir_scope' do
      rede_ouvir_organ = create(:rede_ouvir_organ)
      executive_organ = create(:executive_organ)

      ticket_with_rede_ouvir_organ = create(:ticket, rede_ouvir: true, organ: rede_ouvir_organ)
      ticket_with_executive_organ = create(:ticket, organ: executive_organ)

      expect(ticket_report.filtered_scope).to eq([ticket_with_executive_organ])
    end

    context 'data_scope' do
      let!(:organ) { create(:ticket, :with_organ) }
      let!(:subnet) { create(:ticket, :with_subnet) }

      before do

      end

      it 'all' do
        filters = { data_scope: :all }

        ticket_report.filters = filters

        expect(ticket_report.filtered_scope).to match_array([organ, subnet])
      end

      it 'subnet' do
        filters = { data_scope: :subnet }

        ticket_report.filters = filters

        expect(ticket_report.filtered_scope).to eq([subnet])
      end

      it 'sectoral' do
        filters = { data_scope: :sectoral }

        ticket_report.filters = filters

        expect(ticket_report.filtered_scope).to eq([organ])
      end
    end
  end

  describe 'callbacks' do

    context 'before_destroy' do
      it 'removes spreadsheet file before destroy' do
        ticket_report.save

        expect(RemoveReportableSpreadsheet).to receive(:call).with(ticket_report)

        ticket_report.destroy
      end
    end

    context 'before_save' do
      it 'clear empty filters' do

        ticket_report.filters = {
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
        ticket_report.save
        expect(ticket_report.filters).to eq(expected)
      end
    end
  end

  describe "define SHEETS" do
    context 'when sou' do
      it 'list sou sheets' do
        expect(TicketReport::SOU_SHEETS).to eq(Reports::Tickets::Report::Sheets::SOU_SHEETS)
      end
    end

    context 'when sic' do
      it 'list sic sheets' do
        expect(TicketReport::SIC_SHEETS).to eq(Reports::Tickets::Report::Sheets::SIC_SHEETS)
      end
    end
  end

  describe "#sou_sheet_name" do
    TicketReport::SOU_SHEETS.each do |sou_sheet|
      it "translate #{sou_sheet}" do
        sheet = sou_sheet
        sheet_name = sheet.to_s.split('::').last.underscore.gsub('_service', '')
        sheet_name_translated = I18n.t("services.reports.tickets.sou.#{sheet_name}.sheet_name")

        sou_sheet_name = TicketReport.sou_sheet_name(sheet)
        expect(sou_sheet_name).to eq(sheet_name_translated)
      end
    end
  end

  describe "#sic_sheet_name" do
    TicketReport::SIC_SHEETS.each do |sic_sheet|
      it "translate #{sic_sheet}" do
        sheet = sic_sheet
        sheet_name = sheet.to_s.split('::').last.underscore.gsub('_service', '')
        sheet_name_translated = I18n.t("services.reports.tickets.sic.#{sheet_name}.sheet_name")

        sic_sheet_name = TicketReport.sic_sheet_name(sheet)
        expect(sic_sheet_name).to eq(sheet_name_translated)
      end
    end
  end
end
