require 'rails_helper'

describe Reports::Tickets::Sic::MostWantedTopicsPresenter do
  let(:date) { Date.today }
  let(:ticket_report) { create(:ticket_report, filters: { ticket_type: :sic, confirmed_at: { start: date.beginning_of_month, end: date.end_of_month}, finalized: 1 }) }
  let(:scope) { ticket_report.filtered_scope.without_other_organs }

  subject(:presenter) { Reports::Tickets::Sic::MostWantedTopicsPresenter.new(scope, ticket_report) }

  describe 'self.call' do
    it 'initialize' do
      allow(Reports::Tickets::Sic::MostWantedTopicsPresenter).to receive(:new)

      presenter

      expect(Reports::Tickets::Sic::MostWantedTopicsPresenter).to have_received(:new).with(scope, ticket_report)
    end
  end

  describe 'helpers' do
    let(:organ) { create(:executive_organ) }
    let(:other_organ) { create(:executive_organ) }
    let(:topic) { create(:topic) }
    let(:other_topic) { create(:topic) }
    let(:other_topic_classification) { create(:topic) }

    before do
      Ticket.destroy_all
      classification_sectoral_attendance = create(:classification, topic: topic)
      ticket_sectoral_attendance = create(:ticket, :sic, :in_sectoral_attendance, :with_classification, :with_parent, classification: classification_sectoral_attendance, description: 'ticket_sectoral_attendance',)
      ticket_sectoral_attendance.parent.sic!
      create(:attendance, ticket: ticket_sectoral_attendance.parent)

      classification_finalized = create(:classification, topic: topic)
      ticket_finalized = create(:ticket, :sic, :replied, :with_classification, :with_parent, classification: classification_finalized, description: 'ticket_finalized')
      ticket_finalized.parent.sic!
      create(:attendance, ticket: ticket_finalized.parent)

      classification_sectoral = create(:classification, topic: other_topic)
      ticket_sectoral = create(:ticket, :sic, :in_sectoral_attendance, :with_classification, :with_parent, classification: classification_sectoral, description: 'ticket_sectoral')
      ticket_sectoral.parent.sic!
      create(:attendance, ticket: ticket_sectoral.parent)

      classification_sectoral_other = create(:classification, topic: other_topic_classification)
      ticket_sectoral_other = create(:ticket, :sic, :in_sectoral_attendance, :with_classification, :with_parent, classification: classification_sectoral_other, description: 'ticket_sectoral')
      ticket_sectoral_other.parent.sic!
      create(:attendance, ticket: ticket_sectoral_other.parent)

      classification_without_attendance = create(:classification, topic: other_topic_classification)
      ticket_without_attendance = create(:ticket, :sic, :in_sectoral_attendance, :with_classification, :with_parent, classification: classification_without_attendance, description: 'ticket_without_attendance', organ: organ)
      ticket_without_attendance.parent.sic!

      classification_without_attendance_2 = create(:classification, topic: other_topic_classification)
      ticket_without_attendance_2 = create(:ticket, :sic, :in_sectoral_attendance, :with_classification, :with_parent, classification: classification_without_attendance_2, description: 'ticket_without_attendance', organ: organ)
      ticket_without_attendance_2.parent.sic!

      classification_without_attendance_3 = create(:classification, topic: topic)
      classification_without_attendance_3 = create(:ticket, :sic, :in_sectoral_attendance, :with_classification, :with_parent, classification: classification_without_attendance_3, description: 'ticket_without_attendance', organ: organ)
      classification_without_attendance_3.parent.sic!

      classification_without_attendance_4 = create(:classification, topic: other_topic)
      ticket_without_attendance_4 = create(:ticket, :sic, :in_sectoral_attendance, :with_classification, :with_parent, classification: classification_without_attendance_4, description: 'ticket_without_attendance', organ: other_organ)
      ticket_without_attendance_4.parent.sic!
    end

    it 'call center topic demand by organ' do

      expected = {
        topic.name => 2,
        other_topic.name => 1,
        other_topic_classification.name => 1
      }

      expect(presenter.call_center_topic_demand_count).to eq(expected)
    end

    it 'topic by organs demand count' do

      expected = [
        { organ_acronym: organ.acronym , organ_demand: 3, topics: "#{other_topic_classification.name}: 2\x0D\x0A#{topic.name}: 1"},
        { organ_acronym: other_organ.acronym , organ_demand: 1, topics: "#{other_topic.name}: 1"}
      ]

      expect(presenter.topics_by_organs_demand_count).to eq(expected)
    end
  end
end
