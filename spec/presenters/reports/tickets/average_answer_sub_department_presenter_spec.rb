require 'rails_helper'

describe Reports::Tickets::AverageAnswerSubDepartmentPresenter do
  let(:date) { Date.today }
  let(:ticket_report) { create(:ticket_report, filters: { ticket_type: :sic, confirmed_at: { start: date.beginning_of_month, end: date.end_of_month}, finalized: 1 }) }
  let(:scope) { ticket_report.filtered_scope }

  subject(:presenter) { Reports::Tickets::AverageAnswerSubDepartmentPresenter.new(scope) }

  describe 'self.call' do
    it 'initialize' do
      allow(Reports::Tickets::AverageAnswerSubDepartmentPresenter).to receive(:new)

      presenter

      expect(Reports::Tickets::AverageAnswerSubDepartmentPresenter).to have_received(:new).with(scope)
    end
  end

  describe 'helpers' do
    let(:ticket) { create(:ticket, :sic, :confirmed) }
    let(:ticket2) { create(:ticket, :sic, :confirmed) }

    let!(:ticket_department) { create(:ticket_department, answer: :answered, ticket: ticket)}
    let(:department) { ticket_department.department}
    let!(:sub_department) { create(:sub_department, department: department)}
    let!(:ticket_department_sub_department) { create(:ticket_department_sub_department, ticket_department: ticket_department, sub_department: sub_department, created_at: Date.today)}
    let(:answer_department) { create(:answer, :positioning, ticket: ticket)}
    let!(:ticket_log) do
      data = { responsible_department_id: department.id}
      create(:ticket_log, action: :answer, ticket: ticket, resource: answer_department, data: data, created_at: Date.today+4.day )
    end

    let!(:ticket_department2) { create(:ticket_department, answer: :answered, ticket: ticket2, department: department)}
    let!(:ticket_department_sub_department2) { create(:ticket_department_sub_department, ticket_department: ticket_department2, sub_department: sub_department, created_at: Date.today)}
    let(:answer_department2) { create(:answer, :positioning, ticket: ticket2)}
    let!(:ticket_log2) do
      data = { responsible_department_id: department.id}
      create(:ticket_log, action: :answer, ticket: ticket2, resource: answer_department2, data: data, created_at: Date.today+2.day )
    end

    it 'average_time' do

      expect(presenter.average_time(sub_department)).to eq(3)
    end

    it 'amount_count' do
      expect(presenter.amount_count(sub_department)).to eq(2)
    end
  end
end
