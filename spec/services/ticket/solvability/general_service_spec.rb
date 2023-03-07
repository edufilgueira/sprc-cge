require 'rails_helper'

describe Ticket::Solvability::GeneralService do

  let(:solvability) { Ticket::Solvability::GeneralService.new(scope, organ, start_date, end_date) }

  let(:start_date) { DateTime.now.beginning_of_month }
  let(:end_date) { DateTime.now.end_of_month }

  let(:organ) { create(:executive_organ) }

  # Criado dentro do período e Finalizado atrasado
  # Reaberto dentro do período e Aberto no prazo
  let(:confirmed_reopened) do
    t = create(:ticket, :with_reopen_and_log, organ: organ, reopened_count: 1)
    t.answers.first.update(deadline: -3)
    t
  end

  # Criado fora do período (Desconsiderado da conta)
  # Reaberto dentro do período e Aberto atrasado
  let(:old_reopened) do
    create(:ticket, :with_reopen_and_log, deadline: -3, organ: organ, reopened_count: 1, confirmed_at: Date.today.last_month)
  end

  # Criado dentro do período e Finalizado no prazo
  # Reaberto fora do período (Desconsiderado da conta)
  let(:reopened_out_range) do
    t = create(:ticket, :with_reopen_and_log, organ: organ, reopened_count: 1, reopened_at: Date.today.next_month)
    t.answers.update_all(answer_type: :partial)
    t.answers << create(:answer, :final, ticket: t)
    t.ticket_logs.reopen.first.update(created_at: Date.today.next_month)
    t
  end

  let(:scope) do
    ids = [
      confirmed_reopened.id,
      old_reopened.id,
      reopened_out_range.id
    ]

    Ticket.where(id: ids)
  end

  describe 'self.call' do
    it 'initialize and invoke call method' do
      service = double
      allow(Ticket::Solvability::GeneralService).to receive(:new) { service }
      allow(service).to receive(:call)
      Ticket::Solvability::GeneralService.call(scope, organ, start_date, end_date)

      expect(Ticket::Solvability::GeneralService).to have_received(:new).with(scope, organ, start_date, end_date)
      expect(service).to have_received(:call)
    end
  end

  describe 'call' do

    #
    # @see https://github.com/caiena/sprc/issues/1347#issuecomment-410713456
    #
    # (a) Total de respondidos no prazo: 1 (reabertura)
    # (b) Total = scope.count = 4 (cada reabertura conta + 1)
    # (c) Em aberto no prazo: 1 (reabertura)
    #
    # resolubilidade = (a * 100) / (b - c) = (1 * 100) / (4 - 1) = 100/3
    #
    let(:expected_solvability) { 100.0 / 3 }

    before { scope }

    #  Resolubilidade
    it { expect(solvability.call).to eq(expected_solvability) }

    # Abertos atrasados
    it { expect(solvability.confirmed_and_expired_count).to eq(1) }

    # Abertos no prazo
    it { expect(solvability.confirmed_and_not_expired_count).to eq(1) }

    # Finalizado no prazo
    it { expect(solvability.replied_and_not_expired_count).to eq(1) }

    # Finalizado atrasado
    it { expect(solvability.replied_and_expired_count).to eq(1) }

    # Total
    it { expect(solvability.total_count).to eq(4) }

    context 'when scope.count - cge_validation.count is ZERO' do
      let(:scope) { Ticket.none }

      it { expect(solvability.call).to eq(0.0) }
    end
  end

end
