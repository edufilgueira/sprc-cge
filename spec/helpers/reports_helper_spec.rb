require 'rails_helper'

describe ReportsHelper do

  context 'report_filter_value' do

    it 'ticket_type' do
      filter_key = 'ticket_type'
      filter_value = :sic

      expected = Ticket.human_attribute_name("ticket_type.#{filter_value}")

      expect(report_filter_value(filter_key, filter_value)).to eq(expected)
    end

    context 'expired' do

      it 'true' do
        filter_key = 'expired'
        filter_value = 1

        expected = I18n.t("boolean.true")

        expect(report_filter_value(filter_key, filter_value)).to eq(expected)
      end

      it 'false' do
        filter_key = 'expired'
        filter_value = 0

        expected = I18n.t("boolean.false")

        expect(report_filter_value(filter_key, filter_value)).to eq(expected)
      end
    end

    it 'organ' do
      organ = create(:executive_organ)

      filter_key = 'organ'
      filter_value = organ.id

      expected = Organ.find(filter_value).title

      expect(report_filter_value(filter_key, filter_value)).to eq(expected)
    end

    context 'sheets' do
      context 'when one sheet is chosen' do
        it 'return translation' do
          filter_key = 'sheets'
          sheet = 'Reports::Tickets::Report::Sic::SummaryService'
          filter_value = [sheet]

          expect(report_filter_value(filter_key, filter_value)).to eq(
            TicketReport.sic_sheet_name(sheet)
          )
        end
      end

      context 'when two sheets are chosen' do
        it 'return translation' do
          filter_key = 'sheets'
          sheet_1 = 'Reports::Tickets::Report::Sic::SummaryService'
          sheet_2 = 'Reports::Tickets::Report::Sic::UsedInputService'
          filter_value = [sheet_1, sheet_2]

          expect(report_filter_value(filter_key, filter_value)).to eq(
            TicketReport.sic_sheet_name(sheet_1) + ', ' +
            TicketReport.sic_sheet_name(sheet_2)
          )
        end
      end
    end

    context 'confirmed_at' do
      filter_key = 'confirmed_at'

      it 'only with start' do
        filter_value = {
          start: I18n.l(Date.yesterday)
        }

        expected = I18n.t("report.filters.range", start: I18n.l(Date.yesterday), end: I18n.l(Date.today))

        expect(report_filter_value(filter_key, filter_value)).to eq(expected)
      end

      it 'only with end' do
        filter_value = {
          end: I18n.l(Date.today)
        }

        expected = I18n.t("report.filters.range", start: I18n.l(Date.new(0)), end: I18n.l(Date.today))

        expect(report_filter_value(filter_key, filter_value)).to eq(expected)
      end

      it 'with start and end' do
        filter_value = {
          start: I18n.l(Date.yesterday),
          end: I18n.l(Date.today)
        }

        expected = I18n.t("report.filters.range", start: I18n.l(Date.yesterday), end: I18n.l(Date.today))

        expect(report_filter_value(filter_key, filter_value)).to eq(expected)
      end
    end

    it 'budget_program' do
      budget_program = create(:budget_program)

      filter_key = 'budget_program'
      filter_value = budget_program.id

      expected = budget_program.title

      expect(report_filter_value(filter_key, filter_value)).to eq(expected)
    end

    it 'topic' do
      topic = create(:topic)

      filter_key = 'topic'
      filter_value = topic.id

      expected = topic.title

      expect(report_filter_value(filter_key, filter_value)).to eq(expected)
    end

    it 'subtopic' do
      subtopic = create(:subtopic)

      filter_key = 'subtopic'
      filter_value = subtopic.id

      expected = subtopic.title

      expect(report_filter_value(filter_key, filter_value)).to eq(expected)
    end

    it 'deadline' do
      filter_key = 'deadline'
      filter_value = :not_expired

      expected = Ticket.human_attribute_name("deadline.#{filter_value}")

      expect(report_filter_value(filter_key, filter_value)).to eq(expected)
    end

    it 'departments_deadline' do
      filter_key = 'departments_deadline'
      filter_value = :not_expired

      expected = Ticket.human_attribute_name("departments_deadline.#{filter_value}")

      expect(report_filter_value(filter_key, filter_value)).to eq(expected)
    end

    it 'priority' do
      filter_key = 'priority'
      filter_value = 1

      expected = I18n.t("boolean.true")

      expect(report_filter_value(filter_key, filter_value)).to eq(expected)
    end

    it 'finalized' do
      filter_key = 'finalized'
      filter_value = 1

      expected = I18n.t("boolean.true")

      expect(report_filter_value(filter_key, filter_value)).to eq(expected)
    end

    it 'internal_status' do
      filter_key = 'internal_status'
      filter_value = :cge_validation

      expected = Ticket.human_attribute_name("internal_status.#{filter_value}")

      expect(report_filter_value(filter_key, filter_value)).to eq(expected)
    end

    it 'search' do
      filter_key = 'search'
      filter_value = 'key-word'

      expected = filter_value

      expect(report_filter_value(filter_key, filter_value)).to eq(expected)
    end

    it 'denunciation' do
      filter_key = 'denunciation'
      filter_value = 1

      expected = I18n.t("boolean.true")

      expect(report_filter_value(filter_key, filter_value)).to eq(expected)
    end

    it 'other_organs' do
      filter_key = 'other_organs'
      filter_value = 1

      expected = I18n.t("boolean.true")

      expect(report_filter_value(filter_key, filter_value)).to eq(expected)
    end

    it 'sou_type' do
      filter_key = 'sou_type'
      filter_value = :suggestion

      expected = Ticket.human_attribute_name("sou_type.#{filter_value}")

      expect(report_filter_value(filter_key, filter_value)).to eq(expected)
    end

    it 'state' do
      state = create(:state)
      filter_key = 'state'
      filter_value = state.id

      expected = state.title

      expect(report_filter_value(filter_key, filter_value)).to eq(expected)
    end

    it 'city' do
      city = create(:city)
      filter_key = 'city'
      filter_value = city.id

      expected = city.title

      expect(report_filter_value(filter_key, filter_value)).to eq(expected)
    end

    it 'used_input' do
      filter_key = 'used_input'
      filter_value = :phone

      expected = Ticket.human_attribute_name("used_input.#{filter_value}")

      expect(report_filter_value(filter_key, filter_value)).to eq(expected)
    end

    it 'subnet' do
      subnet = create(:subnet)

      filter_key = 'subnet'
      filter_value = subnet.id

      expected = subnet.title

      expect(report_filter_value(filter_key, filter_value)).to eq(expected)
    end

    it 'department' do
      department = create(:department)

      filter_key = 'department'
      filter_value = department.id

      expected = department.title

      expect(report_filter_value(filter_key, filter_value)).to eq(expected)
    end

    it 'sub_department' do
      sub_department = create(:sub_department)

      filter_key = 'sub_department'
      filter_value = sub_department.id

      expected = sub_department.title

      expect(report_filter_value(filter_key, filter_value)).to eq(expected)
    end

    it 'service_type' do
      service_type = create(:service_type)

      filter_key = 'service_type'
      filter_value = service_type.id

      expected = service_type.title

      expect(report_filter_value(filter_key, filter_value)).to eq(expected)
    end

    it 'parent_protocol' do
      filter_key = 'parent_protocol'
      filter_value = '123456'

      expected = Ticket.human_attribute_name("parent_protocol.#{filter_value}")

      expect(report_filter_value(filter_key, filter_value)).to eq(expected)
    end

    it 'data_scope' do
      filter_key = 'data_scope'
      filter_value = :sectoral

      expected = I18n.t("report.filters.data_scope.#{filter_value}")

      expect(report_filter_value(filter_key, filter_value)).to eq(expected)
    end
  end
end
