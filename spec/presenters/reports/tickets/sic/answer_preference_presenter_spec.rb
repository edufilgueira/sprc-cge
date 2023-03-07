require 'rails_helper'

describe Reports::Tickets::Sic::AnswerPreferencePresenter do
  let(:date) { Date.today }
  let(:ticket_report) { create(:ticket_report, filters: { ticket_type: :sic, confirmed_at: { start: date.beginning_of_month, end: date.end_of_month} }) }
  let(:scope) { ticket_report.filtered_scope }

  subject(:presenter) { Reports::Tickets::Sic::AnswerPreferencePresenter.new(scope, ticket_report) }

  describe 'self.call' do
    it 'initialize' do
      allow(Reports::Tickets::Sic::AnswerPreferencePresenter).to receive(:new)

      presenter

      expect(Reports::Tickets::Sic::AnswerPreferencePresenter).to have_received(:new).with(scope, ticket_report)
    end
  end

  describe 'helpers' do
    before do
      # esse ticket eh sou por isso nao aparece
      create(:ticket, :confirmed, answer_type: :phone)

      create(:ticket, :sic, :confirmed, :in_sectoral_attendance, answer_type: :phone)
      create(:ticket, :sic, :confirmed, :in_sectoral_attendance, answer_type: :phone)
      create(:ticket, :sic, :replied, answer_type: :email)
    end

    context 'answer_type_count' do
      it { expect(presenter.answer_type_count(:phone)).to eq(2) }
    end

    context 'answer_type_percentage' do
      it { expect(presenter.answer_type_percentage(:phone)).to eq('66,67%') }
    end

    context 'answer_type_str' do
      it { expect(presenter.answer_type_str(:phone)).to eq(I18n.t("ticket.answer_types.phone")) }
    end

    context 'total_count' do
      it { expect(presenter.total_count).to eq(3) }
    end
  end
end
