require 'rails_helper'

describe Stats::Ticket do
  subject(:stats_ticket) { create(:stats_ticket) }

  describe 'factories' do
    it { is_expected.to be_valid }
  end

  describe 'db' do
    describe 'columns' do
      it { is_expected.to have_db_column(:ticket_type).of_type(:integer) }
      it { is_expected.to have_db_column(:month_start).of_type(:integer) }
      it { is_expected.to have_db_column(:month_end).of_type(:integer) }
      it { is_expected.to have_db_column(:year).of_type(:integer) }
      it { is_expected.to have_db_column(:organ_id).of_type(:integer) }
      it { is_expected.to have_db_column(:subnet_id).of_type(:integer) }
      it { is_expected.to have_db_column(:data).of_type(:text) }
      it { is_expected.to have_db_column(:status).of_type(:integer) }

      it { is_expected.to have_db_column(:created_at).of_type(:datetime) }
      it { is_expected.to have_db_column(:updated_at).of_type(:datetime) }
    end
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:ticket_type) }
    it { is_expected.to validate_presence_of(:month_start) }
    it { is_expected.to validate_presence_of(:month_end) }
    it { is_expected.to validate_presence_of(:year) }

    it { is_expected.to validate_uniqueness_of(:ticket_type).scoped_to([:month_start, :month_end, :year, :organ_id, :subnet_id]).ignoring_case_sensitivity }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:organ) }
    it { is_expected.to belong_to(:subnet) }
  end

  describe 'enums' do
    it 'ticket_type' do
      ticket_type = [:sic, :sou]

      is_expected.to define_enum_for(:ticket_type).with_values(ticket_type)
    end

    it 'status' do
      statuses = [:ready, :started, :created, :error]

      is_expected.to define_enum_for(:status).with_values(statuses)
    end
  end

  describe 'serializations' do
    # https://github.com/thoughtbot/shoulda-matchers/issues/913
    # it { is_expected.to serialize(:filters) }
    #
    it { expect(stats_ticket.data).to be_a Hash }
  end

  describe 'methods' do
    describe 'current' do
      before do
        allow(Stats::Ticket).to receive(:find_by)

        Stats::Ticket.current(stats_ticket.ticket_type)
      end

      let(:expected_arguments) do
        {
          ticket_type: stats_ticket.ticket_type,
          month_start: 1,
          month_end: Date.current.month,
          year: Date.current.year,
          organ_id: nil,
          subnet_id: nil
        }
      end

      it { expect(Stats::Ticket).to have_received(:find_by).with(expected_arguments) }
    end

    describe 'current_by_scope!' do
      let(:organ) { create(:executive_organ) }
      let(:subnet) { create(:subnet) }

      let(:current_scope) do
        {
          ticket_type: :sou,
          month_start: 8,
          month_end: 8,
          year: 1991,
          organ_id: organ.id,
          subnet_id: subnet.id
        }
      end

      let(:stats_ticket) { Stats::Ticket.current_by_scope!(current_scope) }

      before { allow(UpdateStatsTicketWorker).to receive(:perform_async) }

      context 'when already created' do
        let(:expected) { create(:stats_ticket, ticket_type: current_scope[:ticket_type], month_start: current_scope[:month_start], month_end: current_scope[:month_end], year: current_scope[:year], organ_id: current_scope[:organ_id], subnet_id: current_scope[:subnet_id]) }

        before { expected }

        it { expect(stats_ticket).to eq(expected) }
        it { expect(UpdateStatsTicketWorker).not_to have_received(:perform_async) }
      end

      context 'when not created' do
        it { expect(stats_ticket.ticket_type.to_sym).to eq(current_scope[:ticket_type]) }
        it { expect(stats_ticket.month_start).to eq(current_scope[:month_start]) }
        it { expect(stats_ticket.month_end).to eq(current_scope[:month_end]) }
        it { expect(stats_ticket.year).to eq(current_scope[:year]) }
        it { expect(stats_ticket.organ_id).to eq(current_scope[:organ_id]) }
        it { expect(stats_ticket.subnet_id).to eq(current_scope[:subnet_id]) }

        it { expect(UpdateStatsTicketWorker).to have_received(:perform_async).with(stats_ticket.ticket_type, stats_ticket.year, stats_ticket.month_start, stats_ticket.month_end, stats_ticket.organ_id, stats_ticket.subnet_id) }
      end
    end

    describe 'date' do
      it 'format' do
        expected = "#{I18n.t('date.month_names')[stats_ticket.month_start]} - #{I18n.l(Date.new(stats_ticket.year, stats_ticket.month_end), format: :month_year_long)}"

        expect(stats_ticket.formated_date).to eq expected
      end
    end
  end
end
