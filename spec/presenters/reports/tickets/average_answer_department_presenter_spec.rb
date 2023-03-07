require 'rails_helper'

describe Reports::Tickets::AverageAnswerDepartmentPresenter do
  let(:date) { Date.today }
  let(:ticket_report) { create(:ticket_report, filters: { ticket_type: :sic, confirmed_at: { start: date.beginning_of_month, end: date.end_of_month}, finalized: 1 }) }
  let(:scope) { ticket_report.filtered_scope }

  subject(:presenter) { Reports::Tickets::AverageAnswerDepartmentPresenter.new(scope) }

  describe 'self.call' do
    it 'initialize' do
      allow(Reports::Tickets::AverageAnswerDepartmentPresenter).to receive(:new)

      presenter

      expect(Reports::Tickets::AverageAnswerDepartmentPresenter).to have_received(:new).with(scope)
    end
  end

  describe 'helpers' do
    let(:ticket) { create(:ticket, :sic, :confirmed) }
    let(:ticket2) { create(:ticket, :sic, :confirmed) }

    let!(:ticket_department) { create(:ticket_department, answer: :answered, ticket: ticket, created_at: Date.today)}
    let(:department) { ticket_department.department}
    let(:answer_department) { create(:answer, :positioning, ticket: ticket)}
    let!(:ticket_log) do
      data = { responsible_department_id: department.id}
      create(:ticket_log, action: :answer, ticket: ticket, resource: answer_department, data: data, created_at: Date.today+4.day )
    end

    let!(:ticket_department2) { create(:ticket_department, answer: :answered, ticket: ticket2, department: department, created_at: Date.today)}
    let(:answer_department2) { create(:answer, :positioning, ticket: ticket2)}
    let!(:ticket_log2) do
      data = { responsible_department_id: department.id}
      create(:ticket_log, action: :answer, ticket: ticket2, resource: answer_department2, data: data, created_at: Date.today+2.day )
    end

    it 'average_time' do

      expect(presenter.average_time(department)).to eq(3)
    end

    it 'amount_count' do
      expect(presenter.amount_count(department)).to eq(2)
    end
  end
end
