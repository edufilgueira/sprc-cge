require 'rails_helper'

describe StatsTicketsHelper do

  context 'summary' do
    let(:summary) do
      {
        other_organs: {
          count: 1,
          percentage: 10.0
        },
        completed: {
          count: 2,
          percentage: 20.0
        },
        partially_completed: {
          count: 3,
          percentage: 30.0
        },
        pending: {
          count: 4,
          percentage: 40.0
        },
        average_time_answer: 1.58,
        resolubility: 100.0
      }
    end

    let(:summary_scope) { summary.slice :other_organs, :completed, :partially_completed, :pending }

    context 'stats_summary_serie_keys' do
      let(:ticket_type) { :sou }
      let(:expected) { summary_scope.keys.map { |key| [ I18n.t("shared.reports.stats_tickets.summary.#{key}.#{ticket_type}.title") ] } }

      it { expect(stats_summary_serie_keys(summary, ticket_type)).to eq(expected) }
    end

    context 'stats_summary_serie_values' do
      let(:expected) { summary_scope.values.map { |data| data[:count] } }

      it { expect(stats_summary_serie_values(summary)).to eq(expected) }
    end

    context 'stats_summary_serie_percentages' do
      let(:expected) { summary_scope.values.map { |data| data[:percentage] } }

      it { expect(stats_summary_serie_percentages(summary)).to eq(expected) }
    end
  end

  context 'organs' do
    let(:organ) { create(:executive_organ) }

    let(:topic_1) { create(:topic, organ: organ) }
    let(:topic_2) { create(:topic, organ: organ) }

    let(:organs) do
      organs = {
        organ.id => {
          count: 3,
          percentage: 75.0,
          topics_count: 2,
          topics: {
            topic_1.id => topic_1.title,
            topic_2.id => topic_2.title
          }
        }
      }

      create_list(:organ, 15).each do |organ|
        organs.merge!({
           organ.id => {
            count: 1,
            percentage: 25.0,
            topics_count: 0,
            topics: {}
          }
        })
      end

      organs
    end

    context 'index' do
      let(:organs_scope) { organs.first(10).to_h }
      let(:others_scope) { organs.drop(10).to_h }

      context 'stats_organ_index_serie_keys' do
        let(:others_key) { I18n.t('messages.others') }
        let(:expected) { organs_scope.keys.map { |key| [ Organ.find(key).acronym ] } + [others_key] }

        it { expect(stats_organ_index_serie_keys(organs)).to eq(expected) }
      end

      context 'stats_organ_index_serie_values' do
        let(:others_value) { others_scope.values.map { |o| o[:count] }.sum }
        let(:expected) { organs_scope.values.map { |data| data[:count] } + [others_value] }

        it { expect(stats_organ_index_serie_values(organs)).to eq(expected) }
      end

      context 'stats_organ_index_serie_percentages' do
        let(:others_percentage) { others_scope.values.map { |o| o[:percentage] }.sum }
        let(:expected) { organs_scope.values.map { |data| data[:percentage] } + [others_percentage] }

        it { expect(stats_organ_index_serie_percentages(organs)).to eq(expected) }
      end

      context 'stats_organ_topics_index_serie_data' do
        let(:topic_1) { create(:topic) }
        let(:topic_2) { create(:topic) }
        let(:topic_3) { create(:topic) }
        let(:topic_4) { create(:topic) }
        let(:topic_5) { create(:topic) }

        let(:organ) do
          {
            count: 4,
            percentage: 75.0,
            topics_count: 4,
            topics: {
              topic_1.id => 1,
              topic_2.id => 1,
              topic_3.id => 1,
              topic_4.id => 1,
              topic_5.id => 1
            }
          }
        end

        let(:organ_topics_scope) { organ[:topics].first(5).to_h }

        let(:expected) do
          [
            {
              count: organ[:topics][topic_1.id],
              title: topic_1.title,
              percentage: (organ[:topics][topic_1.id].to_f * 100 / organ[:topics_count]).round(2)
            },
            {
              count: organ[:topics][topic_2.id],
              title: topic_2.title,
              percentage: (organ[:topics][topic_2.id].to_f * 100 / organ[:topics_count]).round(2)
            },
            {
              count: organ[:topics][topic_3.id],
              title: topic_3.title,
              percentage: (organ[:topics][topic_3.id].to_f * 100 / organ[:topics_count]).round(2)
            },
            {
              count: organ[:topics][topic_4.id],
              title: topic_4.title,
              percentage: (organ[:topics][topic_4.id].to_f * 100 / organ[:topics_count]).round(2)
            },
            {
              count: organ[:topics][topic_5.id],
              title: topic_5.title,
              percentage: (organ[:topics][topic_5.id].to_f * 100 / organ[:topics_count]).round(2)
            },
            {
              count: organ[:topics_count] - organ_topics_scope.values.sum,
              title: I18n.t("shared.reports.stats_tickets.index.title_others_topics"),
              percentage: ((organ[:topics_count] - organ_topics_scope.values.sum).to_f * 100 / organ[:topics_count]).round(2)
            }
          ]
        end

        it { expect(stats_organ_topics_index_serie_data(nil)).to eq({}) }
        it { expect(stats_organ_topics_index_serie_data(organ)).to eq(expected) }
      end
    end

    context 'show' do
      context 'stats_organ_show_serie_keys' do
        let(:expected) { organs.keys.map { |key| [ Organ.find(key).acronym ] } }

        it { expect(stats_organ_show_serie_keys(organs)).to eq(expected) }
      end

      context 'stats_organ_show_serie_values' do
        let(:expected) { organs.values.map { |data| data[:count] } }

        it { expect(stats_organ_show_serie_values(organs)).to eq(expected) }
      end

      context 'stats_organ_show_serie_percentages' do
        let(:expected) { organs.values.map { |data| data[:percentage] } }

        it { expect(stats_organ_show_serie_percentages(organs)).to eq(expected) }
      end

      context 'stats_organ_topics_show_serie_keys' do

        let(:topic_1) { create(:topic) }
        let(:topic_2) { create(:topic) }
        let(:topic_3) { create(:topic) }

        let(:topics) do
          {
            topic_1.id => 1,
            topic_2.id => 1
          }
        end

        let(:expected) { [ topic_1.name, topic_2.name ] }

        it { expect(stats_organ_topics_show_serie_keys(topics)).to eq(expected) }
      end

      context 'stats_organ_topics_show_serie_values' do

        let(:topics) do
          {
            1 => 1,
            2 => 1,
            3 => 1
          }
        end

        let(:expected) { topics.values }

        it { expect(stats_organ_topics_show_serie_values(topics)).to eq(expected) }
      end
    end
  end

  describe 'format date' do
    it 'updated_at' do
      time_now = Time.now
      stats_ticket = create(:stats_ticket, updated_at: time_now)

      expect_string = time_now.strftime('%d/%m/%Y %H:%M')

      expect(last_update(stats_ticket)).to eq(expect_string)
    end

    it 'when updated_at is nil' do
      time_now = Time.now
      stats_ticket = create(:stats_ticket, updated_at: nil, created_at: time_now)

      expect_string = time_now.strftime('%d/%m/%Y %H:%M')

      expect(last_update(stats_ticket)).to eq(expect_string)
    end
  end

  describe 'used_inputs' do
    let(:used_inputs) do
      used_inputs = {
        system: {
          count: 1,
          percentage: 20.0
        },
        presential: {
          count: 1,
          percentage: 20.0
        }
      }

      10.times do
        used_inputs.merge!({
          facebook: {
            count: 3,
            percentage: 60.0
          }
        })
      end

      used_inputs
    end

    context 'index' do
      let(:used_inputs_scope) { used_inputs.first(10).to_h }

      context 'stats_used_input_index_serie_keys' do
        let(:expected) { used_inputs_scope.map { |key, _| [I18n.t("ticket.used_inputs.#{key}")] } }

        it { expect(stats_used_input_index_serie_keys(used_inputs)).to eq(expected) }
      end

      context 'stats_used_input_index_serie_values' do
        let(:expected) { used_inputs_scope.values.map { |data| data[:count] } }

        it { expect(stats_used_input_index_serie_values(used_inputs)).to eq(expected) }
      end

      context 'stats_used_input_index_serie_percentages' do
        let(:expected) { used_inputs_scope.values.map { |data| data[:percentage] } }

        it { expect(stats_used_input_index_serie_percentages(used_inputs)).to eq(expected) }
      end
    end

    context 'show' do
      context 'stats_used_input_show_serie_keys' do
        let(:expected) { used_inputs.map { |key, _| [I18n.t("ticket.used_inputs.#{key}")] } }

        it { expect(stats_used_input_show_serie_keys(used_inputs)).to eq(expected) }
      end

      context 'stats_used_input_show_serie_values' do
        let(:expected) { used_inputs.values.map { |data| data[:count] } }

        it { expect(stats_used_input_show_serie_values(used_inputs)).to eq(expected) }
      end

      context 'stats_used_input_show_serie_percentages' do
        let(:expected) { used_inputs.values.map { |data| data[:percentage] } }

        it { expect(stats_used_input_show_serie_percentages(used_inputs)).to eq(expected) }
      end
    end
  end

  describe 'sou_types' do
    let(:sou_types) do
      {
        complaint: {
          count: 2,
          percentage: 50.0
        },
        denunciation: {
          count: 1,
          percentage: 25.0
        },
        suggestion: {
          count: 1,
          percentage: 25.0
        }
      }
    end

    context 'stats_sou_type_serie_keys' do
      let(:expected) { Ticket.sou_types.map { |key, _| [I18n.t("ticket.sou_types.#{key}")] } }

      it { expect(stats_sou_type_serie_keys).to eq(expected) }
    end

    context 'stats_sou_type_serie_values' do
      let(:expected) do
        Ticket.sou_types.keys.map do |key|
          sou_type = sou_types[key.to_sym]
          sou_type.present? ? sou_type[:count] : 0
        end
      end

      it { expect(stats_sou_type_serie_values(sou_types)).to eq(expected) }
    end

    context 'stats_sou_type_serie_percentages' do
      let(:expected) do
        Ticket.sou_types.keys.map do |key|
          sou_type = sou_types[key.to_sym]
          sou_type.present? ? sou_type[:percentage] : 0
        end
      end

      it { expect(stats_sou_type_serie_percentages(sou_types)).to eq(expected) }
    end
  end

  describe 'topics' do
    let(:topics) do
      topics = {}

      create_list(:topic, 10).each do |topic|
        topics.merge!({
          topic.id => {
            count: 1,
            percentage: 25.0
          }
        })
      end

      topics
    end

    context 'index' do
      let(:topics_scope) { topics.first(10).to_h }
      let(:others_scope) { topics.drop(10).to_h }

      context 'stats_topic_index_serie_keys' do
        let(:others_key) { I18n.t('messages.others') }
        let(:expected) { topics_scope.keys.map { |key| [Topic.find(key).title] } + [others_key] }

        it { expect(stats_topic_index_serie_keys(topics)).to eq(expected) }
      end

      context 'stats_topic_index_serie_values' do
        let(:others_value) { others_scope.values.map { |o| o[:count] }.sum }
        let(:expected) { topics_scope.values.map { |data| data[:count] } + [others_value] }

        it { expect(stats_topic_index_serie_values(topics)).to eq(expected) }
      end

      context 'stats_topic_index_serie_percentages' do
        let(:others_percentage) { others_scope.values.map { |o| o[:percentage] }.sum }
        let(:expected) { topics_scope.values.map { |data| data[:percentage] } + [others_percentage] }

        it { expect(stats_topic_index_serie_percentages(topics)).to eq(expected) }
      end
    end

    context 'show' do
      context 'stats_topic_show_serie_keys' do
        let(:expected) { topics.keys.map { |key| [Topic.find(key).title] } }

        it { expect(stats_topic_show_serie_keys(topics)).to eq(expected) }
      end

      context 'stats_topic_show_serie_values' do
        let(:expected) { topics.values.map { |data| data[:count] } }

        it { expect(stats_topic_show_serie_values(topics)).to eq(expected) }
      end

      context 'stats_topic_show_serie_percentages' do
        let(:expected) { topics.values.map { |data| data[:percentage] } }

        it { expect(stats_topic_show_serie_percentages(topics)).to eq(expected) }
      end
    end
  end

  describe 'departments' do
    let(:department_1) { create(:department) }
    let(:department_2) { create(:department) }

    let(:departments) do
      departments = {
        nil => {
          count: 1,
          percentage: 25.0
        }
      }

      create_list(:department, 11).each do |department|
        departments.merge!({
          department.id => {
            count: 1,
            percentage: 25.0
          }
        })
      end

      departments
    end

    context 'index' do
      let(:departments_scope) { departments.first(10).to_h }

      context 'stats_department_index_serie_keys' do
        let(:expected) { departments_scope.keys.compact.map { |key| [Department.find(key).title] } }

        it { expect(stats_department_index_serie_keys(departments)).to eq(expected) }
      end

      context 'stats_department_index_serie_values' do
        let(:expected) { departments_scope.values.map { |data| data[:count] } }

        it { expect(stats_department_index_serie_values(departments)).to eq(expected) }
      end

      context 'stats_department_index_serie_percentages' do
        let(:expected) { departments_scope.values.map { |data| data[:percentage] } }

        it { expect(stats_department_index_serie_percentages(departments)).to eq(expected) }
      end
    end

    context 'show' do
      context 'stats_department_show_serie_keys' do
        let(:expected) { departments.keys.compact.map { |key| [Department.find(key).title] } }

        it { expect(stats_department_show_serie_keys(departments)).to eq(expected) }
      end

      context 'stats_department_show_serie_values' do
        let(:expected) { departments.values.map { |data| data[:count] } }

        it { expect(stats_department_show_serie_values(departments)).to eq(expected) }
      end

      context 'stats_department_show_serie_percentages' do
        let(:expected) { departments.values.map { |data| data[:percentage] } }

        it { expect(stats_department_show_serie_percentages(departments)).to eq(expected) }
      end
    end
  end

  it 'years_for_select' do
    current_year = Date.today.year
    years_ago = 10
    expected_data = ((current_year - years_ago)..(current_year)).to_a.reverse

    expect(years_for_select(years_ago)).to eq(expected_data)
  end

  context 'stats_sectoral_organ_scope_for_select' do
    let(:scopes) { [:general, :sectoral] }
    let(:expected) do
      scopes.map { |scope| [I18n.t("shared.reports.stats_tickets.index.filters.sectoral.scopes.#{scope}"), scope] }
    end

    it { expect(stats_sectoral_organ_scope_for_select).to eq(expected) }
  end

  context 'stats_sectoral_subnet_scope_for_select' do
    let(:scopes) { [:general, :sectoral] }
    let(:expected) do
      scopes.map { |scope| [I18n.t("shared.reports.stats_tickets.index.filters.sectoral.scopes.#{scope}"), scope] }
    end

    it { expect(stats_sectoral_subnet_scope_for_select).to eq(expected) }
  end
end
