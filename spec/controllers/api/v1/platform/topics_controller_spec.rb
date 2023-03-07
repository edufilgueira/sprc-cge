require 'rails_helper'

describe Api::V1::Platform::TopicsController do

  let(:user) { create(:user, :user) }
  let(:empty_option) { { "#{I18n.t('messages.form.select')}": '' } }

  before { sign_in(user) }

  describe 'topics' do
    let(:organ) { create(:executive_organ) }
    let(:topic) { create(:topic) }
    let(:topic_with_organ) { create(:topic, organ: organ) }
    let(:data) { JSON.parse(response.body) }
    let(:results) { data['results'].to_json }


    before do
      topic
      topic_with_organ
    end

    context 'with organ' do
      before { get(:topics, xhr: true, params: { organ: organ.id }) }
      let(:expected) do
        expected = {
          "#{topic.title}": topic.id,
          "#{topic_with_organ.title}": topic_with_organ.id
        }
        empty_option.merge(expected.sort.to_h).to_json
      end

      it { expect(results).to eq(expected) }
    end

    context 'without organ' do
      before { get(:topics, xhr: true) }

      let(:expected) do
        expected = {
          "#{topic.title}": topic.id
        }
        empty_option.merge(expected.sort.to_h).to_json
      end

      it { expect(results).to eq(expected) }
    end

    context 'with search paginated' do
      let!(:topics) { create_list(:topic, 10) }
      let(:topics_without_organ) { Topic.enabled.where(organ: nil).sorted }

      it "default per_page" do
        get(:topics, xhr: true, params: { page: '1' })

        topics = map_by_title(topics_without_organ.first(25))
        expected = empty_option.merge(topics).to_json

        expect(results).to eq(expected)
      end

      it "without params" do
        get(:topics, xhr: true)

        topics = map_by_title(topics_without_organ.first(25))
        expected = empty_option.merge(topics).to_json

        expect(results).to eq(expected)
      end

      context "params page" do
        it "page 1" do
          get(:topics, xhr: true, params: { page: '1' , per_page: '5'})

          topics = map_by_title(topics_without_organ.first(5))
          expected = empty_option.merge(topics).to_json

          expect(results).to eq(expected)
        end

        it "page 2" do
          get(:topics, xhr: true, params: { page: '2' , per_page: '5'})

          topics = map_by_title(topics_without_organ.limit(10).last(5))
          expected = topics.to_json

          expect(results).to eq(expected)
        end

        it "page default" do
          get(:topics, xhr: true, params: { per_page: '5'})

          topics = map_by_title(topics_without_organ.first(5))
          expected = empty_option.merge(topics).to_json

          expect(results).to eq(expected)
        end

        it "total_filtered" do
          get(:topics, xhr: true, params: { per_page: '5'})

          count = topics_without_organ.count
          topics = map_by_title(topics_without_organ.first(5))
          expected = empty_option.merge(topics).to_json

          expect(data['count_filtered']).to eq(count)
          expect(data['results'].length).not_to eq(count)
          expect(results).to eq(expected)
        end
      end

      context "with search params" do
        it "name" do
          topic = create(:topic, name: "gsn")

          get(:topics, xhr: true, params: { page: '1', term: 'gs' })

          topics = map_by_title([topic])
          expected = empty_option.merge(topics).to_json

          expect(results).to eq(expected)
        end

        it "acronym" do
          organ_acronym = create(:executive_organ, acronym: "gsn")
          topic = create(:topic, organ: organ_acronym)

          get(:topics, xhr: true, params: { page: '1', term: 'gs' , organ: organ_acronym.id})

          topics = map_by_title([topic])

          expected = empty_option.merge(topics).to_json

          expect(results).to eq(expected)
        end
      end
    end
  end

  private

  def map_by_title(objects)
    objects.map { |r| [r.title, r.id ] }.to_h
  end

end
