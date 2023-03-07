require 'rails_helper'

describe Reports::Tickets::TopicPresenter do
  include ActionView::Helpers::NumberHelper

  let(:date) { Date.today }

  let(:ticket_report) { create(:ticket_report, filters: { ticket_type: :sou, confirmed_at: { start: date.beginning_of_month, end: date.end_of_month}, finalized: true }) }
  let(:scope) { ticket_report.filtered_scope }

  subject(:presenter) { Reports::Tickets::TopicPresenter.new(scope, ticket_report) }

  describe 'self.call' do
    it 'initialize' do
      allow(Reports::Tickets::TopicPresenter).to receive(:new)

      presenter

      expect(Reports::Tickets::TopicPresenter).to have_received(:new).with(scope, ticket_report)
    end
  end

  describe 'helpers' do
    describe 'rows ordered' do
      let(:topic_1) { create(:topic) }
      let(:topic_1_subtopic_1) { create(:subtopic, topic: topic_1) }

      let(:topic_2) { create(:topic) }
      let(:topic_2_subtopic_1) { create(:subtopic, topic: topic_2) }
      let(:topic_2_subtopic_2) { create(:subtopic, topic: topic_2) }

      let(:row_1) do
        [
          topic_2.name,
          topic_2.organ_acronym,
          2,
          number_to_percentage(66.67, precision: 2)
        ]
      end

      let(:row_2) do
        [
          topic_1.name,
          topic_1.organ_acronym,
          1,
          number_to_percentage(33.33, precision: 2)
        ]
      end

      let(:expected) { [row_1, row_2] }


      context 'when cge operator' do
        before do
          create(:classification, topic: topic_1, subtopic: topic_1_subtopic_1)
          create(:classification, topic: topic_2, subtopic: topic_2_subtopic_1)
          create(:classification, topic: topic_2, subtopic: topic_2_subtopic_2)
        end
        it { expect(presenter.rows).to eq(expected) }
      end

      context 'when cge sectoral' do
        let(:ticket_report) { create(:ticket_report, :sectoral) }
        let(:organ) { ticket_report.user.organ }
        let(:row_1) do
          [
            topic_1.name,
            4,
            number_to_percentage(100, precision: 2)
          ]
        end

        let(:expected) { [row_1] }

        before do
          ticket = create(:ticket, :with_parent, organ: organ)
          create(:classification, topic: topic_1, subtopic: topic_1_subtopic_1, ticket: ticket)

          reopened = create(:ticket, :with_parent, :with_reopen_and_log, reopened_count: 2, organ: organ)
          create(:classification, ticket: reopened, topic: topic_1, subtopic: topic_1_subtopic_1)

        end


        it { expect(presenter.rows).to eq(expected) }
      end

    end
  end
end
