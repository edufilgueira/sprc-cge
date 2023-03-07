require 'rails_helper'

describe Operator::TopicsController do

  let(:user) { create(:user, :operator) }

  let(:resources) { create_list(:topic, 1) }

  let(:permitted_params) do
    [
      :name,
      :organ_id,
      subtopics_attributes: [
        :id,
        :name,
        :_disable
      ]
    ]
  end

  let(:valid_params) { { topic: attributes_for(:topic) } }

  it_behaves_like 'controllers/base/index/paginated'
  it_behaves_like 'controllers/base/index/search'

  it_behaves_like 'controllers/operator/base/index/xhr' do
    context 'filters' do
      it 'user_type' do
        first_topic = resources.first
        filtered_topic = create(:topic, organ: create(:executive_organ))

        get(:index, params: { organ: filtered_topic.organ_id })

        expect(controller.topics).to eq([filtered_topic])
      end
    end

    it_behaves_like 'controllers/operator/base/index/filter_disabled'
  end

  it_behaves_like 'controllers/base/index/sorted' do
    let(:sort_columns) do
      {
        name: 'topics.name',
        email: 'topics.email',
        organ_name: 'organs.name'
      }
    end

    let(:first_unsorted) do
      create(:topic, name: '456', organ: create(:executive_organ, name: '123'))
    end

    let(:last_unsorted) do
      create(:topic, name: '123', organ: create(:executive_organ, name: '456'))
    end
  end

  it_behaves_like 'controllers/operator/base/new'
  it_behaves_like 'controllers/operator/base/create'
  it_behaves_like 'controllers/operator/base/show'

  it_behaves_like 'controllers/operator/base/edit'
  it_behaves_like 'controllers/operator/base/update'
  # it_behaves_like 'controllers/operator/base/destroy'

  describe 'custom destroy' do
    let(:topic) { resources.first }

    describe '#delete' do
      context 'unauthorized' do
        before { get(:delete, params: { id: topic }) }

        it { is_expected.to redirect_to(new_user_session_path) }
      end

      context 'authorized' do
        before { sign_in(user) && get(:delete, params: { id: topic }) }

        context 'template' do
          render_views

          it { is_expected.to respond_with(:success) }
          it { is_expected.to render_template('operator/topics/delete') }
        end

        context 'helper methods' do
          it 'topic' do
            expect(controller.topic).to eq(topic)
          end
        end
      end
    end

    describe '#destroy' do
      context 'unauthorized' do
        before { delete(:destroy, params: { id: topic }) }

        it { is_expected.to redirect_to(new_user_session_path) }
      end

      context 'authorized' do
        let(:subtopic) { create(:subtopic) }
        let(:topic) { subtopic.topic }
        let(:classification) { create(:classification, topic: topic, subtopic: subtopic) }

        let(:target_subtopic) { create(:subtopic) }
        let(:target_topic) { target_subtopic.topic }

        let(:target_subtopics) do
          {
            "#{subtopic.id}": "#{target_subtopic.id}"
          }
        end

        before { sign_in(user) }

        context 'valid' do
          it 'destroys' do
            classification
            target_topic

            expect do
              delete(:destroy, params: { id: topic, target_topic: target_topic, target_subtopics: target_subtopics })

              expected_flash = I18n.t('operator.topics.destroy.done', title: topic.title)

              classification.reload

              expect(response).to redirect_to(operator_topics_path)
              expect(controller).to set_flash.to(expected_flash)
              expect(classification.topic).to eq(target_topic)
              expect(classification.subtopic).to eq(target_subtopic)
            end.to change(Topic, :count).by(-1)
          end

          it 'invoke service' do
            service = double
            allow(DeleteTopicService).to receive(:new) { service }
            allow(service).to receive(:call)

            expected_target_subtopics = ActionController::Parameters.new(target_subtopics)

            delete(:destroy, params: { id: topic, target_topic: target_topic, target_subtopics: target_subtopics })

            expect(DeleteTopicService).to have_received(:new)
            expect(service).to have_received(:call).with(topic, target_topic.id.to_s, expected_target_subtopics)
          end
        end

        context 'invalid' do
          render_views

          it 'does not save' do
            classification

            expect do
              delete(:destroy, params: { id: topic })

              expected_flash = I18n.t('operator.topics.destroy.error')

              expect(response).to render_template('operator/topics/delete')
              expect(controller).to set_flash.now[:alert].to(expected_flash)
            end.to change(Topic, :count).by(0)
          end
        end

        context 'helper methods' do
          it 'topic' do
            delete(:destroy, params: { id: topic })
            expect(controller.topic).to eq(topic)
          end
        end
      end
    end
  end
end
