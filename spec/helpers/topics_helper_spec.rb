require 'rails_helper'

describe TopicsHelper do
  let(:topic) { create(:topic) }

  describe 'transfer_targets' do
    it 'topics_transfer_targets_for_select' do
      topic = create(:topic)
      target_1 = create(:topic)
      target_2 = create(:topic)

      expected = [target_1, target_2].map do |target|
        [ target.title, target.id ]
      end

      expect(topics_transfer_targets_for_select(topic)).to eq(expected)
    end
  end

  context 'topic_by_id_for_select' do
    it 'when filter is selected' do
      expected = [
        [topic.title, topic.id]
      ].sort.to_h

      expect(topic_by_id_for_select(topic.id)).to eq(expected)
    end

    it 'when filter is not selected' do
      expected = []

      expect(topic_by_id_for_select(nil)).to eq(expected)
    end
  end
end
