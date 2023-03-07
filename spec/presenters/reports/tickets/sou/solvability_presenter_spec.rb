require 'rails_helper'

describe Reports::Tickets::Sou::SolvabilityPresenter do
  include ActionView::Helpers::NumberHelper

  let(:date) { Date.today }
  let(:ticket_report) { create(:ticket_report, filters: { ticket_type: :sou, confirmed_at: { start: date.beginning_of_month, end: date.end_of_month}, finalized: true }) }
  let(:scope) { ticket_report.filtered_scope }

  subject(:presenter) { Reports::Tickets::Sou::SolvabilityPresenter.new(scope, ticket_report) }

  describe 'self.call' do
    it 'initialize' do
      allow(Reports::Tickets::Sou::SolvabilityPresenter).to receive(:new)

      presenter

      expect(Reports::Tickets::Sou::SolvabilityPresenter).to have_received(:new).with(scope, ticket_report)
    end
  end

  describe 'helpers' do
    # Finalizado e no prazo
    # Finalizado e no prazo
    let!(:final_answers_in_deadline) do
      ticket = create(:ticket, :with_reopen_and_log, deadline: 30)
      create(:answer, :partial, ticket: ticket, version: 1)
      ticket.final_answer!
      ticket
    end

    # Finalizado e atrasado
    let!(:final_answers_out_deadline) do
      ticket = create(:ticket, :with_parent, :replied)
      ticket.answers.update_all(sectoral_deadline: -1)
    end

    # Finalizado e no prazo
    # Aberto e no prazo
    let!(:reopened_in_deadline) { create(:ticket, :with_reopen_and_log, deadline: 30) }

    # Finalizado e atrasado
    # Aberto e atrasado
    let!(:reopened_out_deadline) do
      ticket = create(:ticket, :with_reopen_and_log, deadline: -1)
      ticket.answers.update_all(sectoral_deadline: -1)
      ticket
    end

    # Aberto e no prazo
    let!(:attendance_in_deadline) { create(:ticket, :with_parent, deadline: 0) }

    # Aberto e atrasado
    let!(:attendance_out_deadline) { create(:ticket, :with_parent, deadline: -1) }

    # Finalizado e no prazo
    let!(:partial_answers_in_deadline) do
      ticket = create(:ticket, :with_parent, :partial_answer)
      ticket.answers.update_all(sectoral_deadline: 30)
      ticket
    end

    # Finalizado e atrasado
    let!(:partial_answers_out_deadline) do
      ticket = create(:ticket, :with_parent, :partial_answer)
      ticket.answers.update_all(sectoral_deadline: -1)
      ticket
    end

    # total
    let(:scope_count) { 11 }

    # deve considerar :partial_answer
    #
    # final_answers_in_deadline
    # reopened_in_deadline
    # partial_answers_in_deadline
    let(:expected_final_answers_in_deadline) { 4 }

    # deve considerar :partial_answer
    #
    # final_answers_out_deadline
    # reopened_out_deadline
    # partial_answers_out_deadline
    let(:expected_final_answers_out_deadline) { 3 }

    # attendance_in_deadline
    # reopened_in_deadline
    let(:expected_attendance_in_deadline) { 2 }

    # attendance_out_deadline
    # reopened_out_deadline
    let(:expected_attendance_out_deadline) { 2 }

    describe 'question_average' do

      it { expect(presenter.solvability_count(:final_answers_in_deadline)).to eq(expected_final_answers_in_deadline) }
      it { expect(presenter.solvability_count(:final_answers_out_deadline)).to eq(expected_final_answers_out_deadline) }
      it { expect(presenter.solvability_count(:attendance_in_deadline)).to eq(expected_attendance_in_deadline) }
      it { expect(presenter.solvability_count(:attendance_out_deadline)).to eq(expected_attendance_out_deadline) }
      it { expect(presenter.solvability_count(:total)).to eq(scope_count) }
    end

    describe 'solvability percentage' do
      let(:expected) { number_to_percentage(solvability, precision: 2) }
      let(:solvability) { (solvability_count * 100.0 / scope_count).round 2 }
      let(:solvability_count) { presenter.solvability_count(solvability_type) }
      let(:solvability_type) {}

      context 'final_answers_in_deadline' do
        let(:solvability_type) { :final_answers_in_deadline }

        it { expect(presenter.solvability_percentage(solvability_count)).to eq(expected) }
      end

      context 'final_answers_out_deadline' do
        let(:solvability_type) { :final_answers_out_deadline }

        it { expect(presenter.solvability_percentage(solvability_count)).to eq(expected) }
      end

      context 'attendance_in_deadline' do
        let(:solvability_type) { :attendance_in_deadline }

        it { expect(presenter.solvability_percentage(solvability_count)).to eq(expected) }
      end

      context 'attendance_out_deadline' do
        let(:solvability_type) { :attendance_out_deadline }

        it { expect(presenter.solvability_percentage(solvability_count)).to eq(expected) }
      end

      context 'total' do
        let(:solvability_type) { :total }

        it { expect(presenter.solvability_percentage(solvability_count)).to eq(expected) }
      end
    end

    describe 'solvability_name' do
      solubilities = [
        :final_answers_in_deadline,
        :final_answers_out_deadline,
        :attendance_in_deadline,
        :attendance_out_deadline,
        :total
      ]

      solubilities.each do |solvability|
        it { expect(presenter.solvability_name(solvability)).to eq(I18n.t("services.reports.tickets.sou.solvability.rows.#{solvability}")) }
      end
    end
  end
end
