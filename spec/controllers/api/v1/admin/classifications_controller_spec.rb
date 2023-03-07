require 'rails_helper'

describe Api::V1::Admin::ClassificationsController do

  let(:user) { create(:user, :admin) }
  let(:empty_option) { { "#{I18n.t('messages.form.select')}": '' } }

  before { sign_in(user) }

  describe 'subtopics' do
    let(:subtopic) { create(:subtopic) }
    let(:topic) { subtopic.topic }
    let(:other) { create(:subtopic) }

    before { other }

    context 'with topic' do

      before { get(:subtopics, xhr: true, params: { topic: topic.id }) }

      let(:data) { response.body }
      let(:expected) do
        expected = {
          "#{subtopic.title}": subtopic.id
        }
        empty_option.merge(expected.sort.to_h).to_json
      end

      it { expect(response.body).to eq(expected) }
    end

    context 'without topic' do
      before { get(:subtopics, xhr: true) }
      let(:data) { response.body }
      let(:expected) { empty_option.to_json }

      it { expect(data).to eq(expected) }
    end
  end
end
