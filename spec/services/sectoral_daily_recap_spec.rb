require 'rails_helper'

describe SectoralDailyRecap do

  let(:service) { SectoralDailyRecap.new }

  let(:ends_at) { Date.yesterday.end_of_day }
  let(:starts_at) { ends_at.year == 2018 ? '18/07/2018'.to_datetime : ends_at.beginning_of_year }

  describe 'self.call' do
    it 'initialize and invoke call method' do
      service = double
      allow(SectoralDailyRecap).to receive(:new) { service }
      allow(service).to receive(:call)
      SectoralDailyRecap.call

      expect(SectoralDailyRecap).to have_received(:new)
      expect(service).to have_received(:call)
    end
  end

  describe 'call' do

    let(:organ) { create(:executive_organ) }
    let(:chief) { create(:user, :operator_chief, organ: organ) }
    let(:operator_sou_sectoral) { create(:user, :operator_sou_sectoral, organ: organ) }
    let(:operator_sic_sectoral) { create(:user, :operator_sic_sectoral, organ: organ) }

    let(:chief_other_organ) { create(:user, :operator_chief) }
    let(:disabled_user) { create(:user, :operator_chief, disabled_at: Date.today) }

    let(:expected_for_user) do
      {
        range: {
          starts_at: I18n.l(starts_at, format: :date),
          ends_at: I18n.l(ends_at, format: :date)
        },
        organ: organ.title,
        sou: {
          total: 7,
          replied: 2,
          confirmed: {
            not_expired: 1,
            expired_can_extend: 2,
            not_expired_extended: 1,
            expired: 1
          },
          solvability: 40.0,
          answer_time_average: 2.5,
          answer_satisfaction_rate: 4.0
        },
        sic: {
          total: 9,
          replied: 2,
          confirmed: {
            not_expired: 3,
            expired_can_extend: 1,
            not_expired_extended: 2,
            expired: 1
          },
          solvability: 50.0,
          answer_time_average: 3.0,
          answer_satisfaction_rate: 2.5
        }
      }
    end

    let(:expected_other_organ) do
      {
        range: {
          starts_at: I18n.l(starts_at, format: :date),
          ends_at: I18n.l(ends_at, format: :date)
        },
        organ: chief_other_organ.organ.title,
        sou: {
          total: 0,
          replied: 0,
          confirmed: {
            not_expired: 0,
            expired_can_extend: 0,
            not_expired_extended: 0,
            expired: 0
          },
          solvability: 0.0,
          answer_time_average: message_without_answers,
          answer_satisfaction_rate: message_without_evaluations
        },
        sic: {
          total: 0,
          replied: 0,
          confirmed: {
            not_expired: 0,
            expired_can_extend: 0,
            not_expired_extended: 0,
            expired: 0
          },
          solvability: 0.0,
          answer_time_average: message_without_answers,
          answer_satisfaction_rate: message_without_evaluations
        }
      }
    end

    let(:message_without_evaluations) { I18n.t('services.sectoral_daily_recap.evaluations.empty') }
    let(:message_without_answers) { I18n.t('services.sectoral_daily_recap.answers.empty') }

    before do
      disabled_user

      # SOU

      ## Não deve considerar inválidos
      create(:ticket, :with_parent, :invalidated, organ: organ, confirmed_at: 2.days.ago.to_date)

      ## total = replied + confirmed - (not_expired + not_expired_extended) = 2 + 5 - (1 + 1) = 5

      ## replied: 2
      ticket_sou_1 = create(:ticket, :with_parent, :replied, organ: organ, confirmed_at: 2.days.ago.to_date, responded_at: 1.day.ago)
      ticket_sou_2 = create(:ticket, :with_parent, :replied, organ: organ, confirmed_at: 4.days.ago.to_date, responded_at: Date.today)

      ## confirmed: 5
      ### not_expired: 1
      create(:ticket, :with_parent, :confirmed, organ: organ, confirmed_at: Date.yesterday)
      ### expired_can_extend: 2
      create(:ticket, :with_parent, :confirmed, :expired_can_extend, organ: organ, confirmed_at: Date.yesterday)
      create(:ticket, :with_parent, :confirmed, :expired_can_extend, organ: organ, confirmed_at: Date.yesterday)
      ### not_expired_extended: 1
      create(:ticket, :with_parent, :confirmed, extended: true, organ: organ, confirmed_at: Date.yesterday)
      ### expired: 1
      create(:ticket, :with_parent, :confirmed, confirmed_at: 2.months.ago, organ: organ, deadline: -60)

      ## solvability = replied / total = 2 / 5 =  0.4

      ## answer_time_average = [ticket_1, ticket_2].sum { |t| t.responded_at - t.confirmed_at } / 2 =  (1 + 4) / 2 = 2.5 dias

      ## answer_satisfaction_rate: (3 + 5) / 2 = 4.0
      answer_sou_1 = ticket_sou_1.answers[0]
      answer_sou_2 = ticket_sou_2.answers[0]
      create(:evaluation, answer: answer_sou_1, evaluation_type: :sou).update_column(:average, 3)
      create(:evaluation, answer: answer_sou_2, evaluation_type: :sou).update_column(:average, 5)


      # SIC

      ## Não deve considerar inválidos
      create(:ticket, :sic, :with_parent_sic, :invalidated, organ: organ, confirmed_at: 2.days.ago.to_date)

      ## total = replied + confirmed - (not_expired + not_expired_extended) = 2 + 7 - (3 + 2) = 4

      ## replied: 2
      ticket_sic_1 = create(:ticket, :sic, :with_parent_sic, :replied, organ: organ, confirmed_at: 4.days.ago, responded_at: 1.day.ago)
      ticket_sic_2 = create(:ticket, :sic, :with_parent_sic, :replied, organ: organ, confirmed_at: 4.days.ago, responded_at: 1.day.ago, internal_status: :partial_answer)

      ## confirmed: 7
      ### not_expired: 3
      create(:ticket, :sic, :with_parent_sic, organ: organ, confirmed_at: Date.yesterday)
      create(:ticket, :sic, :with_parent_sic, organ: organ, confirmed_at: Date.yesterday)
      create(:ticket, :sic, :with_parent_sic, organ: organ, confirmed_at: Date.yesterday)
      ### expired_can_extend: 1
      create(:ticket, :sic, :with_parent_sic, :expired_can_extend, organ: organ, confirmed_at: Date.yesterday)
      ### not_expired_extended: 2
      create(:ticket, :sic, :with_parent_sic, extended: true, organ: organ, confirmed_at: Date.yesterday)
      create(:ticket, :sic, :with_parent_sic, extended: true, organ: organ, confirmed_at: Date.yesterday)
      ### expired: 1
      create(:ticket, :sic, :with_parent_sic, confirmed_at: 2.months.ago, organ: organ, deadline: -60)

      ## solvability =  replied / total = 2 / 4 = 0.5

      ## answer_time_average = ticket.responded_at - ticket.confirmed_at / 1 =  3 / 1 = 3.0 dias

      ## answer_satisfaction_rate: 2 + 3 / 2 = 2.5
      answer_sic_1 = ticket_sic_1.answers[0]
      answer_sic_2 = ticket_sic_2.answers[0]

      create(:evaluation, answer: answer_sic_1, evaluation_type: :sic).update_column(:average, 2)
      create(:evaluation, answer: answer_sic_2, evaluation_type: :sic).update_column(:average, 3)
    end

    it 'calls TicketMailer sectoral_daily_recap to organ users' do
      chief
      operator_sou_sectoral
      operator_sic_sectoral

      service = double

      allow(TicketMailer).to receive(:sectoral_daily_recap) { service }
      allow(service).to receive(:deliver)

      SectoralDailyRecap.call

      expect(TicketMailer).to have_received(:sectoral_daily_recap).with(match_array([chief, operator_sou_sectoral, operator_sic_sectoral]), expected_for_user)
      expect(TicketMailer).not_to have_received(:sectoral_daily_recap).with([disabled_user], anything)
    end

    it 'calls TicketMailer sectoral_daily_recap to chief_other_organ' do
      chief_other_organ
      service = double

      allow(TicketMailer).to receive(:sectoral_daily_recap) { service }
      allow(service).to receive(:deliver)

      SectoralDailyRecap.call

      expect(TicketMailer).to have_received(:sectoral_daily_recap).with([chief_other_organ], expected_other_organ)
      expect(TicketMailer).not_to have_received(:sectoral_daily_recap).with([disabled_user], anything)
    end
  end
end
