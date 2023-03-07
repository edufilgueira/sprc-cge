require 'rails_helper'

describe Reports::Tickets::SubDepartmentPresenter do
  include ActionView::Helpers::NumberHelper

  let(:date) { Date.today }
  let(:ticket_report) { create(:ticket_report, filters: { ticket_type: :sou, confirmed_at: { start: date.beginning_of_month, end: date.end_of_month}, finalized: 1 }) }
  let(:default_scope) { ticket_report.filtered_scope }

  let(:report_scope) do
    scope = default_scope.left_joins(parent: :attendance)
    scope.where(attendances: { id: nil }).or(
      scope.where(attendances: { service_type: :sic_forward }))
  end

  subject(:presenter) { Reports::Tickets::SubDepartmentPresenter.new(report_scope, ticket_report) }

  describe 'self.call' do
    it 'initialize' do
      allow(Reports::Tickets::SubDepartmentPresenter).to receive(:new)

      presenter

      expect(Reports::Tickets::SubDepartmentPresenter).to have_received(:new).with(report_scope, ticket_report)
    end
  end

  describe 'helpers' do
    context 'rows' do
      let(:organ_a) { create(:executive_organ, acronym: 'A') }
      let(:organ_b) { create(:executive_organ, acronym: 'B') }

      let(:department_1) { create(:department) }
      let(:department_2) { create(:department) }

      let(:sub_department_1) { create(:sub_department, department: department_1) }
      let(:sub_department_2) { create(:sub_department, department: department_2) }


      let(:row_1) do
        [
          organ_a.acronym,
          department_1.name,
          sub_department_1.name,
          1,
          number_to_percentage(20, precision: 2)
        ]
      end

      let(:row_2) do
        [
          organ_a.acronym,
          department_2.name,
          sub_department_2.name,
          1,
          number_to_percentage(20, precision: 2)
        ]
      end

      let(:row_3) do
        [
          organ_b.acronym,
          department_2.name,
          sub_department_2.name,
          2,
          number_to_percentage(40, precision: 2)
        ]
      end

      let(:row_4) do
        [
          organ_b.acronym,
          nil,
          nil,
          1,
          number_to_percentage(20, precision: 2)
        ]
      end

      let(:expected) { [row_1, row_2, row_3, row_4] }

      before do
        ticket = create(:ticket, :with_parent, organ: organ_a)
        create(:classification, ticket: ticket, department: department_1, sub_department: sub_department_1)

        ticket = create(:ticket, :with_parent, organ: organ_a)
        create(:classification, ticket: ticket, department: department_2, sub_department: sub_department_2)

        ticket = create(:ticket, :with_parent, :with_reopen_and_log, organ: organ_b)
        create(:classification, ticket: ticket, department: department_2, sub_department: sub_department_2)

        create(:ticket, :with_parent, organ: organ_b)
      end

      it { expect(presenter.rows).to match_array(expected) }
    end
  end
end
