require 'rails_helper'

describe UpdateStatsTicket do

  describe 'self.call' do
    let(:service) { UpdateStatsTicket.new }

    it 'initialize and invoke call method with param' do
      service = double
      allow(UpdateStatsTicket).to receive(:new) { service }
      allow(service).to receive(:call)
      UpdateStatsTicket.call(1)

      expect(UpdateStatsTicket).to have_received(:new).with(1)
      expect(service).to have_received(:call)
    end
  end

  describe 'call' do
    let(:ticket_type) { :sou }
    let(:organ) { subnet.organ }
    let(:subnet) { create(:subnet) }

    let(:stats_ticket) { create(:stats_ticket, ticket_type: ticket_type, month_start: 1, month_end: Date.today.month, year: Date.today.year, organ: organ, subnet: subnet) }
    let(:last_stats_ticket) { stats_ticket.reload }

    let(:service) { UpdateStatsTicket.new(stats_ticket.id) }

    before { stats_ticket }

    context 'status created' do
      before { service.call }

      it { expect(last_stats_ticket).to be_created }
    end

    context 'summary' do
      let(:summary) { last_stats_ticket.data[:summary] }

      context 'other_organs' do
        let(:other_organs) { summary[:other_organs] }

        let(:expected) do
          {
            count: 2,
            percentage: (2.0 * 100 / 4).round(2)
          }
        end


        before do
          create(:ticket, :with_parent, organ: organ, subnet: subnet)

          create(:ticket, :with_parent)
          create(:ticket, :with_parent, organ: organ, subnet: create(:subnet, organ: organ))
          create(:ticket, :with_parent, :with_classification_other_organs, organ: organ, subnet: subnet)
          create(:ticket, :with_parent, :with_classification_other_organs, organ: organ, subnet: subnet)
          create(:ticket, :with_parent, :invalidated, :with_classification_other_organs, organ: organ, subnet: subnet)

          service.call
        end

        it { expect(other_organs).to eq(expected) }
      end

      context 'completed' do
        let(:completed) { summary[:completed] }

        let(:expected) do
          {
            count: 3,
            percentage: (3.0 * 100 / 5).round(2)
          }
        end


        before do
          create(:ticket, :with_parent, :replied, organ: organ, subnet: subnet)
          ticket = create(:ticket, :with_parent, :replied, organ: organ, subnet: subnet)
          create(:ticket_log, :reopened, ticket: ticket)


          create(:ticket, :with_parent, :replied)
          create(:ticket, :with_parent, :replied, internal_status: :partial_answer, organ: organ, subnet: subnet)
          create(:ticket, :with_parent, :with_classification_other_organs, organ: organ, subnet: subnet)


          service.call
        end

        it { expect(completed).to eq(expected) }
      end

      context 'partially_completed' do
        let(:partially_completed) { summary[:partially_completed] }

        let(:expected) do
          {
            count: 2,
            percentage: (2.0 * 100 / 4).round(2)
          }
        end


        before do
          create(:ticket, :with_parent, :replied, internal_status: :partial_answer, organ: organ, subnet: subnet)
          create(:ticket, :with_parent, :replied, internal_status: :partial_answer, organ: organ, subnet: subnet)


          create(:ticket, :with_parent, :replied, internal_status: :partial_answer)
          create(:ticket, :with_parent, :replied, organ: organ, subnet: subnet)
          create(:ticket, :with_parent, :with_classification_other_organs, organ: organ, subnet: subnet)

          service.call
        end

        it { expect(partially_completed).to eq(expected) }
      end

      context 'pending' do
        let(:pending) { summary[:pending] }

        let(:expected) do
          {
            count: 2,
            percentage: (2.0 * 100 / 6).round(2)
          }
        end


        before do
          create(:ticket, :with_parent, organ: organ, subnet: subnet)
          create(:ticket, :with_parent, :in_internal_attendance, organ: organ, subnet: subnet)


          create(:ticket, :with_parent, :in_internal_attendance)

          create(:ticket, :with_parent, :replied, internal_status: :partial_answer, organ: organ, subnet: subnet)
          create(:ticket, :with_parent, :replied, organ: organ, subnet: subnet)

          create(:ticket, :with_parent, :invalidated, organ: organ, subnet: subnet)
          create(:ticket, :with_parent, :with_classification_other_organs, organ: organ, subnet: subnet)

          service.call
        end

        it { expect(pending).to eq(expected) }
      end

      context 'average_time_answer' do
        let(:average_time_answer) { summary[:average_time_answer] }

        let(:ticket_1) { create(:ticket, :with_parent, :replied, confirmed_at: 2.days.ago.to_date, responded_at: 1.day.ago.to_date, organ: organ, subnet: subnet) }
        let(:ticket_2) { create(:ticket, :with_parent, :replied, confirmed_at: 4.days.ago.to_date, responded_at: Date.today, organ: organ, subnet: subnet) }

        let(:expected) do
          [ticket_1, ticket_2].sum { |t| (t.responded_at.to_date - t.confirmed_at.to_date).to_i }.to_i / 2
        end

        before do
          ticket_1
          ticket_2

          create(:ticket, :with_parent, :replied, confirmed_at: 4.days.ago.to_date, responded_at: Date.today)

          service.call
        end

        it { expect(average_time_answer).to eq(expected) }
      end

      # razão de tickets atendidos no prazo por total de tickets atendidos
      context 'resolubility' do
        let(:organ) { nil }
        let(:subnet) { nil }
        let(:resolubility) { summary[:resolubility] }
        let(:final_answers_in_deadline) { 3 }
        let(:attendance_in_deadline) { 2 }
        let(:total) { 10 }

        let(:expected) do
          count = total - attendance_in_deadline
          (final_answers_in_deadline * 100.0 / count).round(2)
        end

        before do
          ticket = create(:ticket, :with_reopen_and_log, deadline: 30)
          ticket.final_answer!
          create(:answer, :final, version: 1, ticket: ticket)

          ticket = create(:ticket, :with_reopen_and_log, deadline: -1)
          ticket.final_answer!
          create(:answer, :final, version: 1, ticket: ticket, sectoral_deadline: -1)

          create(:ticket, :with_reopen_and_log, deadline: 30)

          create(:ticket, :with_reopen_and_log, deadline: -1)

          create(:ticket, :with_parent, deadline: 1)
          create(:ticket, :with_parent, deadline: -1)


          service.call
        end

        it { expect(resolubility).to eq(expected) }
      end

    end

    context 'summary_csai' do
      let(:summary_csai) { last_stats_ticket.data[:summary_csai] }

      let(:attendance_sic_completed) do
        ticket_immediate_answer = create(:ticket, :with_parent, :immediate_answer, organ: organ, subnet: subnet)
        create(:attendance, :sic_completed, ticket: ticket_immediate_answer.parent)
      end

      context 'other_organs' do
        let(:other_organs) { summary_csai[:other_organs] }

        let(:expected) do
          {
            count: 2,
            percentage: (2.0 * 100 / 4).round(2)
          }
        end


        before do
          create(:ticket, :with_parent, organ: organ, subnet: subnet)

          attendance_sic_completed

          create(:ticket, :with_parent)
          create(:ticket, :with_parent, organ: organ, subnet: create(:subnet, organ: organ))
          create(:ticket, :with_parent, :with_classification_other_organs, organ: organ, subnet: subnet)
          create(:ticket, :with_parent, :with_classification_other_organs, organ: organ, subnet: subnet)
          create(:ticket, :with_parent, :invalidated, :with_classification_other_organs, organ: organ, subnet: subnet)

          service.call
        end

        it { expect(other_organs).to eq(expected) }
      end

      context 'completed' do
        let(:completed) { summary_csai[:completed] }

        let(:expected) do
          {
            count: 3,
            percentage: (3.0 * 100 / 5).round(2)
          }
        end


        before do
          create(:ticket, :with_parent, :replied, organ: organ, subnet: subnet)
          ticket = create(:ticket, :with_parent, :replied, organ: organ, subnet: subnet)
          create(:ticket_log, :reopened, ticket: ticket)

          attendance_sic_completed


          create(:ticket, :with_parent, :replied)
          create(:ticket, :with_parent, :replied, internal_status: :partial_answer, organ: organ, subnet: subnet)
          create(:ticket, :with_parent, :with_classification_other_organs, organ: organ, subnet: subnet)


          service.call
        end

        it { expect(completed).to eq(expected) }
      end

      context 'partially_completed' do
        let(:partially_completed) { summary_csai[:partially_completed] }

        let(:expected) do
          {
            count: 2,
            percentage: (2.0 * 100 / 4).round(2)
          }
        end


        before do
          create(:ticket, :with_parent, :replied, internal_status: :partial_answer, organ: organ, subnet: subnet)
          create(:ticket, :with_parent, :replied, internal_status: :partial_answer, organ: organ, subnet: subnet)

          attendance_sic_completed

          create(:ticket, :with_parent, :replied, internal_status: :partial_answer)
          create(:ticket, :with_parent, :replied, organ: organ, subnet: subnet)
          create(:ticket, :with_parent, :with_classification_other_organs, organ: organ, subnet: subnet)

          service.call
        end

        it { expect(partially_completed).to eq(expected) }
      end

      context 'pending' do
        let(:pending) { summary_csai[:pending] }

        let(:expected) do
          {
            count: 2,
            percentage: (2.0 * 100 / 6).round(2)
          }
        end


        before do
          create(:ticket, :with_parent, organ: organ, subnet: subnet)
          create(:ticket, :with_parent, :in_internal_attendance, organ: organ, subnet: subnet)

          attendance_sic_completed

          create(:ticket, :with_parent, :in_internal_attendance)

          create(:ticket, :with_parent, :replied, internal_status: :partial_answer, organ: organ, subnet: subnet)
          create(:ticket, :with_parent, :replied, organ: organ, subnet: subnet)

          create(:ticket, :with_parent, :invalidated, organ: organ, subnet: subnet)
          create(:ticket, :with_parent, :with_classification_other_organs, organ: organ, subnet: subnet)

          service.call
        end

        it { expect(pending).to eq(expected) }
      end

      context 'average_time_answer' do
        let(:average_time_answer) { summary_csai[:average_time_answer] }

        let(:ticket_1) { create(:ticket, :with_parent, :replied, confirmed_at: 2.days.ago.to_date, responded_at: 1.day.ago.to_date, organ: organ, subnet: subnet) }
        let(:ticket_2) { create(:ticket, :with_parent, :replied, confirmed_at: 4.days.ago.to_date, responded_at: Date.today, organ: organ, subnet: subnet) }

        # (1 + 4) / 2 = 2.5 dias
        let(:expected) do
          expected = [ticket_1, ticket_2].sum { |t| (t.responded_at.to_date - t.confirmed_at.to_date).to_i } / 2
          expected.round(2)
        end

        before do
          ticket_1
          ticket_2

          attendance_sic_completed.ticket.tickets.update_all(confirmed_at: 2.days.ago.to_date, responded_at: 1.day.ago.to_date)

          create(:ticket, :with_parent, :replied, confirmed_at: 4.days.ago.to_date, responded_at: Date.today)

          service.call
        end

        it { expect(average_time_answer).to eq(expected) }
      end

      # razão de tickets atendidos no prazo por total de tickets atendidos
      context 'resolubility' do
        let(:organ) { nil }
        let(:subnet) { nil }
        let(:resolubility) { summary_csai[:resolubility] }
        let(:final_answers_in_deadline) { 3 }
        let(:attendance_in_deadline) { 3 }
        let(:total) { 11 }


        let(:attendance_sic_completed) do
          ticket_immediate_answer = create(:ticket, :with_parent, :immediate_answer, :with_reopen_and_log, deadline: 30)
          create(:attendance, :sic_completed, ticket: ticket_immediate_answer.parent)
        end

        let(:expected) do
          count = total - attendance_in_deadline
          (final_answers_in_deadline * 100.0 / count).round(2)
        end

        before do
          ticket = create(:ticket, :with_reopen_and_log, deadline: 30)
          ticket.final_answer!
          create(:answer, :final, ticket: ticket, version: 1)

          ticket = create(:ticket, :with_reopen_and_log, deadline: -1)
          ticket.final_answer!
          create(:answer, :final, ticket: ticket, sectoral_deadline: -1, version: 1)

          create(:ticket, :with_reopen_and_log, deadline: 30)

          create(:ticket, :with_reopen_and_log, deadline: -1)

          attendance_sic_completed

          create(:ticket, :with_parent, deadline: 1)
          create(:ticket, :with_parent, deadline: -1)


          service.call
        end

        it { expect(resolubility).to eq(expected) }
      end

    end

    context 'organs' do
      let(:organs) { last_stats_ticket.data[:organs] }
      let(:organ) { nil }
      let(:subnet) { nil }


      context 'sorted' do
        let(:subnet_1) { create(:subnet) }
        let(:subnet_2) { create(:subnet) }

        let(:organ_1) { subnet_1.organ }
        let(:organ_2) { subnet_2.organ }

        let(:topic_1_1) { create(:topic, organ: organ_1) }
        let(:topic_1_2) { create(:topic, organ: organ_1) }
        let(:topic_1_3) { create(:topic, organ: organ_1) }
        let(:topic_1_4) { create(:topic, organ: organ_1) }
        let(:topic_2) { create(:topic, organ: organ_2) }

        let(:ticket_1_1) { create(:ticket, :with_parent, confirmed_at: Date.today, organ: organ_1, subnet: subnet_1) }
        let(:ticket_1_2) { create(:ticket, :with_parent, confirmed_at: Date.today, organ: organ_1, subnet: subnet_1) }
        let(:ticket_1_3) { create(:ticket, :with_parent, confirmed_at: Date.today, organ: organ_1, subnet: subnet_1) }
        let(:ticket_1_4) { create(:ticket, :with_parent, confirmed_at: Date.today, organ: organ_1, subnet: subnet_1) }
        let(:ticket_1_5) { create(:ticket, :with_parent, confirmed_at: Date.today, organ: organ_1, subnet: subnet_1) }
        let(:ticket_1_6) { create(:ticket, :with_parent, confirmed_at: Date.today, organ: organ_1, subnet: subnet_1) }
        let(:ticket_1_7) { create(:ticket, :with_parent, confirmed_at: Date.today, organ: organ_1, subnet: subnet_1) }
        let(:ticket_1_8) { create(:ticket, :with_parent, confirmed_at: Date.today, organ: organ_1, subnet: subnet_1) }
        let(:ticket_2) { create(:ticket, :with_parent, confirmed_at: Date.today, organ: organ_2, subnet: subnet_2) }

        let(:classification_1_1) { create(:classification, ticket: ticket_1_1, topic: topic_1_1) }
        let(:classification_1_2) { create(:classification, ticket: ticket_1_2, topic: topic_1_1) }
        let(:classification_1_3) { create(:classification, ticket: ticket_1_3, topic: topic_1_2) }
        let(:classification_1_4) { create(:classification, ticket: ticket_1_4, topic: topic_1_2) }
        let(:classification_1_5) { create(:classification, ticket: ticket_1_5, topic: topic_1_3) }
        let(:classification_1_6) { create(:classification, ticket: ticket_1_6, topic: topic_1_3) }
        let(:classification_1_7) { create(:classification, ticket: ticket_1_7, topic: topic_1_3) }
        let(:classification_1_8) { create(:classification, ticket: ticket_1_8, topic: topic_1_4) }
        let(:classification_2) { create(:classification, ticket: ticket_2, topic: topic_2) }

        let(:expected) do
          {
            organ_1.id => {
              count: 8,
              percentage: (8.0 * 100 / 9).round(2),
              topics_count: 8,
              topics: {
                topic_1_3.id => 3,
                topic_1_1.id => 2,
                topic_1_2.id => 2,
                topic_1_4.id => 1
              }
            },
            organ_2.id => {
              count: 1,
              percentage: (1.0 * 100 / 9).round(2),
              topics_count: 1,
              topics: {
                topic_2.id => 1
              }
            }
          }
        end

        before do
          classification_1_1
          classification_1_2
          classification_1_3
          classification_1_4
          classification_1_5
          classification_1_6
          classification_1_7
          classification_1_8
          classification_2

          service.call
        end

        it { expect(organs).to eq(expected) }
      end
    end

    context 'used_inputs' do
      let(:organ) { nil }
      let(:subnet) { nil }

      before do
        create(:ticket, :confirmed, confirmed_at: Date.today, used_input: :presential)
        create(:ticket, :confirmed, confirmed_at: Date.today, used_input: :facebook)
        create(:ticket, :confirmed, confirmed_at: Date.today, used_input: :system)
        create(:ticket, :confirmed, confirmed_at: Date.today, used_input: :system)

        service.call
      end

      it 'sorted' do
        used_inputs = last_stats_ticket.data[:used_inputs]

        expected = {
          system: {
            count: 2,
            percentage: 50.0
          },
          presential: {
            count: 1,
            percentage: 25.0
          },
          facebook: {
            count: 1,
            percentage: 25.0
          },
        }

        expect(used_inputs.symbolize_keys).to eq(expected)
      end
    end

    context 'sou_types' do
      let(:organ) { nil }
      let(:subnet) { nil }

      before do
        create(:ticket, :confirmed, confirmed_at: Date.today, sou_type: :request)
        create(:ticket, :confirmed, confirmed_at: Date.today, sou_type: :complaint)
        create(:ticket, :confirmed, confirmed_at: Date.today, sou_type: :complaint)
        create(:ticket, :confirmed, confirmed_at: Date.today, sou_type: :complaint)

        service.call
      end

      it 'sorted' do
        sou_types = last_stats_ticket.data[:sou_types]

        expected = {
          complaint: {
            count: 3,
            percentage: 75.0
          },
          request: {
            count: 1,
            percentage: 25.0
          }
        }

        expect(sou_types.symbolize_keys).to eq(expected)
      end
    end

    context 'topics' do
      let(:organ) { nil }
      let(:subnet) { nil }
      let(:topics) { last_stats_ticket.data[:topics] }

      context 'sorted' do
        let(:topic_1) { create(:topic) }
        let(:topic_2) { create(:topic) }
        let(:topic_3) { create(:topic) }

        let(:expected) do
          {
            topic_2.id => {
              count: 5,
              percentage: 50.0
            },
              topic_3.id => {
              count: 3,
              percentage: 30.0
            },
              topic_1.id => {
              count: 2,
              percentage: 20.0
            }
          }
        end

        before do
          4.times { create(:ticket, :confirmed, confirmed_at: Date.today) }

          2.times do
            ticket = create(:ticket, :confirmed, confirmed_at: Date.today)
            create(:classification, ticket: ticket, topic: topic_1)
          end

          5.times do
            ticket = create(:ticket, :confirmed, confirmed_at: Date.today)
            create(:classification, ticket: ticket, topic: topic_2)
          end

          3.times do
            ticket = create(:ticket, :confirmed, confirmed_at: Date.today)
            create(:classification, ticket: ticket, topic: topic_3)
          end

          create(:topic)

          service.call
        end

        it { expect(topics).to eq(expected) }
      end
    end

    context 'departments' do
      let(:organ) { nil }
      let(:subnet) { nil }
      let(:departments) { last_stats_ticket.data[:departments] }

      context 'sorted' do
        let(:department_1) { create(:department) }
        let(:department_2) { create(:department) }
        let(:department_3) { create(:department) }

        let(:expected) do
          {
            department_2.id => {
              count: 5,
              percentage: 50.0
            },
              department_3.id => {
              count: 3,
              percentage: 30.0
            },
              department_1.id => {
              count: 2,
              percentage: 20.0
            }
          }
        end

        before do
          4.times { create(:ticket, :confirmed, confirmed_at: Date.today) }

          2.times do
            ticket = create(:ticket, :confirmed, confirmed_at: Date.today)
            create(:classification, ticket: ticket, department: department_1)
          end

          5.times do
            ticket = create(:ticket, :confirmed, confirmed_at: Date.today)
            create(:classification, ticket: ticket, department: department_2)
          end

          3.times do
            ticket = create(:ticket, :confirmed, confirmed_at: Date.today)
            create(:classification, ticket: ticket, department: department_3)
          end

          create(:department)

          service.call
        end

        it { expect(departments).to eq(expected) }
      end
    end

    context 'years' do
      let(:current_year) { Date.current.year }
      let(:last_year) { current_year - 1 }
      let(:expected) do
        {
          current_year => [2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2],
          last_year => [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
        }
      end

      before do
        ## valid
        create(:ticket, :confirmed, confirmed_at: Date.today.beginning_of_year)
        create(:ticket, :with_parent, confirmed_at: Date.today.beginning_of_year)
        ticket = create(:ticket, :replied, confirmed_at: Date.today.end_of_year)
        create(:ticket_log, :reopened, ticket: ticket, created_at: Date.today.end_of_year)


        ## invalid
        create(:ticket, :invalidated)

        organ_dpge = create(:executive_organ, :dpge)
        create(:ticket, :with_parent, organ: organ_dpge)

        other_organs = create(:ticket, :confirmed)
        create(:classification, :other_organs, ticket: other_organs)

        service.call
      end

      it { expect(last_stats_ticket.data[:years]).to eq(expected) }
    end
  end
end
