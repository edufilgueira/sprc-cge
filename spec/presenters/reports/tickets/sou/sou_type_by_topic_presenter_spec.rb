require 'rails_helper'

describe Reports::Tickets::Sou::SouTypeByTopicPresenter do
  include ActionView::Helpers::NumberHelper

  let(:date) { Date.today }
  let(:ticket_report) { create(:ticket_report, filters: { ticket_type: :sou, confirmed_at: { start: date.beginning_of_month, end: date.end_of_month}, finalized: 1 }) }
  let(:scope) { ticket_report.filtered_scope }

  subject(:presenter) { Reports::Tickets::Sou::SouTypeByTopicPresenter.new(scope, ticket_report) }

  describe 'self.call' do
    it 'initialize' do
      allow(Reports::Tickets::Sou::SouTypeByTopicPresenter).to receive(:new)

      presenter

      expect(Reports::Tickets::Sou::SouTypeByTopicPresenter).to have_received(:new).with(scope, ticket_report)
    end
  end

  describe 'helpers' do
    context 'rows' do
      let(:organ_1) { create(:executive_organ) }
      let(:organ_2) { create(:executive_organ) }

      let(:topic) { create(:topic) }
      let(:subtopic) { create(:subtopic, topic: topic) }

      let(:ticket_1) do
        ticket = create(:ticket, :with_reopen_and_log, reopened_count: 2, organ: organ_1)
        create(:classification, ticket: ticket, topic: topic, subtopic: subtopic)
        ticket
      end

      let(:ticket_2) do
        create(:ticket, :with_parent, organ: organ_2)
      end

      let(:row_1) do
        [
          ticket_1.sou_type_str,
          topic.name,
          subtopic.name,
          organ_1.acronym,
          3,
          number_to_percentage(75, precision: 2)
        ]
      end

      let(:row_2) do
        [
          ticket_2.sou_type_str,
          nil,
          nil,
          organ_2.acronym,
          1,
          number_to_percentage(25, precision: 2)
        ]
      end

      let(:expected) { [row_1, row_2] }

      before do
        ticket_1
        ticket_2
      end

      it { expect(presenter.rows).to match_array(expected) }
    end
  end
end
