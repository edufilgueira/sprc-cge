require 'rails_helper'

describe Reports::Tickets::Sou::DenunciationTypePresenter do
  include ActionView::Helpers::NumberHelper

  let(:date) { Date.today }
  let(:ticket_report) { create(:ticket_report, filters: { ticket_type: :sou, confirmed_at: { start: date.beginning_of_month, end: date.end_of_month}, finalized: true }) }
  let(:scope) { ticket_report.filtered_scope }

  subject(:presenter) { Reports::Tickets::Sou::DenunciationTypePresenter.new(scope, ticket_report) }

  describe 'self.call' do
    it 'initialize' do
      allow(Reports::Tickets::Sou::DenunciationTypePresenter).to receive(:new)

      presenter

      expect(Reports::Tickets::Sou::DenunciationTypePresenter).to have_received(:new).with(scope, ticket_report)
    end
  end

  describe 'helpers' do
    let!(:in_favor_of_the_state) do
      create(:ticket, :denunciation, denunciation_type: :in_favor_of_the_state)
    end

    let!(:against_the_state) do
      create(:ticket, :denunciation, denunciation_type: :against_the_state)
    end

    let!(:without_type) do
      create(:ticket, :denunciation, denunciation_type: nil)
    end

    # total
    let(:scope_count) { 3 }

    let(:expected_in_favor_of_the_state) { 1 }
    let(:expected_against_the_state) { 1 }
    let(:expected_without_type) { 1 }

    describe 'question_average' do

      it { expect(presenter.denunciation_type_count(:in_favor_of_the_state)).to eq(expected_in_favor_of_the_state) }
      it { expect(presenter.denunciation_type_count(:against_the_state)).to eq(expected_against_the_state) }
      it { expect(presenter.denunciation_type_count(:without_type)).to eq(expected_without_type) }
      it { expect(presenter.denunciation_type_count(:total)).to eq(scope_count) }
    end

    describe 'denunciation_type percentage' do
      let(:expected) { number_to_percentage((denunciation_type_count * 100.0 / scope_count).round(2), precision: 2) }
      let(:denunciation_type_count) { presenter.denunciation_type_count(denunciation_type) }
      let(:denunciation_type) {}

      context 'in_favor_of_the_state' do
        let(:denunciation_type) { :in_favor_of_the_state }

        it { expect(presenter.denunciation_type_percentage(denunciation_type_count)).to eq(expected) }
      end

      context 'against_the_state' do
        let(:denunciation_type) { :against_the_state }

        it { expect(presenter.denunciation_type_percentage(denunciation_type_count)).to eq(expected) }
      end

      context 'without_type' do
        let(:denunciation_type) { :without_type }

        it { expect(presenter.denunciation_type_percentage(denunciation_type_count)).to eq(expected) }
      end

      context 'total' do
        let(:denunciation_type) { :total }

        it { expect(presenter.denunciation_type_percentage(denunciation_type_count)).to eq(expected) }
      end
    end

    describe 'denunciation_type_name' do
      denunciation_types = [
        :in_favor_of_the_state,
        :against_the_state,
        :without_type
      ]

      denunciation_types.each do |denunciation_type|
        it { expect(presenter.denunciation_type_name(denunciation_type)).to eq(I18n.t("services.reports.tickets.sou.denunciation_type.rows.#{denunciation_type}")) }
      end
    end
  end
end
