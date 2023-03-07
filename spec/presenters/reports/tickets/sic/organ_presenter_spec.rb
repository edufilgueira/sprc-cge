require 'rails_helper'

describe Reports::Tickets::Sic::OrganPresenter do
  let(:date) { Date.today }
  let(:ticket_report) { create(:ticket_report, filters: { ticket_type: :sic, confirmed_at: { start: date.beginning_of_month, end: date.end_of_month}, finalized: 1 }) }
  let(:scope) { ticket_report.filtered_scope.left_joins(parent: :attendance) }

  subject(:presenter) { Reports::Tickets::Sic::OrganPresenter.new(scope, ticket_report) }

  describe 'self.call' do
    it 'initialize' do
      allow(Reports::Tickets::Sic::OrganPresenter).to receive(:new)

      presenter

      expect(Reports::Tickets::Sic::OrganPresenter).to have_received(:new).with(scope, ticket_report)
    end
  end

  describe 'helpers' do
    let(:organ) { create(:executive_organ) }
    let(:other_organ) { create(:executive_organ) }

    before do
      Ticket.destroy_all

      ticket_sou = create(:ticket, :confirmed, :with_organ, description: 'ticket_sou', organ: organ)
      create(:attendance, ticket: ticket_sou, service_type: :sou_forward)

      ticket_sectoral_attendance = create(:ticket, :confirmed, :sic, :in_sectoral_attendance, :with_parent, description: 'ticket_sectoral_attendance', organ: organ)
      ticket_sectoral_attendance.parent.sic!
      create(:attendance, ticket: ticket_sectoral_attendance.parent)

      ticket_replied = create(:ticket, :sic, :replied, :with_parent, description: 'ticket_replied', organ: organ)
      ticket_replied.parent.sic!
      create(:attendance, ticket: ticket_replied.parent)

      ticket_invalidated = create(:ticket, :sic, :invalidated, :with_parent, description: 'ticket_invalidated', organ: organ)
      ticket_invalidated.parent.sic!
      create(:attendance, ticket: ticket_invalidated.parent)

      ticket_sou_other = create(:ticket, :confirmed, :with_parent, description: 'ticket_sou', organ: other_organ)
      ticket_sou_other.parent.sic!
      create(:attendance, ticket: ticket_sou_other.parent, service_type: :sou_forward)

      ticket_sectoral_attendance_other = create(:ticket, :confirmed, :sic, :in_sectoral_attendance, :with_parent, description: 'ticket_sectoral_attendance', organ: other_organ)
      ticket_sectoral_attendance_other.parent.sic!
      create(:attendance, ticket: ticket_sectoral_attendance_other.parent)

      ticket_attendance_other = create(:ticket, :sic, :replied, :with_parent, description: 'ticket_attendance_other', organ: other_organ, call_center_status: :with_feedback)
      ticket_attendance_other.parent.sic!
      answer_attendance = create(:answer, ticket: ticket_attendance_other)
      create(:attendance, :with_organs, service_type: :sic_completed, ticket: ticket_attendance_other.parent, answer: answer_attendance)

      ticket_sectoral_attendance = create(:ticket, :confirmed, :sic, :in_sectoral_attendance, :with_parent, description: 'ticket_sectoral_attendance', organ: organ)
      ticket_sectoral_attendance.parent.sic!
    end

    describe 'call_center_organ_demand' do
      let(:expected) do
         {
          organ.acronym => 4,
          other_organ.acronym => 2
        }
      end

      it { expect(presenter.call_center_organ_demand_count).to eq(expected)}
      it { expect(presenter.calc_percentage(4, 6)).to eq('66,67%')}
      it { expect(presenter.calc_percentage(2, 6)).to eq('33,33%')}
    end

    describe 'call_center_organ_forwarded' do

     let(:expected) do
        {
          organ.acronym => 3,
          other_organ.acronym => 2
        }
      end

      it { expect(presenter.call_center_organ_forwarded_count).to eq(expected)}
      it { expect(presenter.calc_percentage(3, 5)).to eq('60,00%')}
      it { expect(presenter.calc_percentage(2, 5)).to eq('40,00%')}
    end

    describe 'organs_demand_count' do

      let(:expected) do
        {
          organ.acronym => 1
        }
      end

      it { expect(presenter.organs_demand_count).to eq(expected)}
      it { expect(presenter.calc_percentage(1, 1)).to eq('100,00%')}
    end
  end
end
