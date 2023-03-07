require 'rails_helper'

describe DeleteTopicService do

  let(:subtopic) { create(:subtopic) }
  let(:topic) { subtopic.topic }
  let(:classification) { create(:classification, topic: topic, subtopic: subtopic) }

  let(:target_subtopic) { create(:subtopic) }
  let(:target_topic) { target_subtopic.topic }

  let(:target_topic_param) { target_topic.id.to_s }
  let(:target_subtopics_param) { ActionController::Parameters.new(target_subtopics) }

  let(:target_subtopics) do
    {
      "#{subtopic.id}": "#{target_subtopic.id}"
    }
  end

  describe 'self.call' do
    it 'initialize and invoke call method' do
      service = double
      allow(DeleteTopicService).to receive(:new) { service }
      allow(service).to receive(:call)

      DeleteTopicService.call(topic, target_topic_param, target_subtopics_param)

      expect(DeleteTopicService).to have_received(:new)
      expect(service).to have_received(:call).with(topic, target_topic_param, target_subtopics_param)
    end
  end

  describe 'call' do

    before do
      classification
      target_topic_param
      target_subtopics_param
    end

    it 'without associated classification' do
      topic = create(:topic)

      expect do
        result = DeleteTopicService.call(topic, target_topic_param, target_subtopics_param)

        expect(result).to be_truthy
      end.to change(Topic, :count).by(-1)
    end

    it 'with associated classification' do
      expect do
        result = DeleteTopicService.call(topic.reload, target_topic_param, target_subtopics_param)

        expect(result).to be_truthy
        expect(classification.reload.topic).to eq(target_topic)
      end.to change(Topic, :count).by(-1)
    end

    context 'without subtopics' do
      let(:topic) { create(:topic) }
      let(:classification) { create(:classification, topic: topic, subtopic: nil) }

      it 'delete' do
        expect do
          result = DeleteTopicService.call(topic.reload, target_topic_param, nil)

          expect(result).to be_truthy
          expect(classification.reload.topic).to eq(target_topic)
        end.to change(Topic, :count).by(-1)
      end
    end

    context 'without select target subtopic' do
      let(:target_subtopics) do
        {
          "#{subtopic.id}": nil
        }
      end

      it 'does not delete' do
        topic.reload
        expect do
          result = DeleteTopicService.call(topic, target_topic_param, target_subtopics_param)

          classification.reload

          expect(result).to be_falsey
          expect(classification.topic).to eq(topic)
          expect(classification.subtopic).to eq(subtopic)
        end.to change(Topic, :count).by(0)
      end
    end

    context 'invalid params' do
      it 'target_topic' do
        expect do
          result = DeleteTopicService.call(topic, nil, target_subtopics_param)

          expect(result).to be_falsey
        end.to change(Topic, :count).by(0)
      end

      it 'target_subtopics' do
        topic.reload
        expect do
          result = DeleteTopicService.call(topic, target_topic_param, nil)

          expect(result).to be_falsey
        end.to change(Topic, :count).by(0)
      end
    end
  end

end
