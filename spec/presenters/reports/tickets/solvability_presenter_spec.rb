require 'rails_helper'

describe Reports::Tickets::SolvabilityPresenter do

  let(:date) { Date.today }

  let(:solvability_report) { create(:solvability_report, filters: { ticket_type: :sic , confirmed_at: { start: date.beginning_of_month, end: date.end_of_month }}) }
  let(:solvability_report_without_confirmed_at) { create(:solvability_report, filters: { ticket_type: :sic , confirmed_at: { start: nil, end: nil }}) }
  let(:solvability_report_organ_disabled) { create(:solvability_report, filters: { ticket_type: :sic , organ: :organ_disabled ,confirmed_at: { start: date.beginning_of_month, end: date.end_of_month }}) }

  let(:scope) { solvability_report.filtered_scope }

  subject(:presenter) { Reports::Tickets::SolvabilityPresenter.new(scope, solvability_report) }
  subject(:presenter_without_confirmed_at) { Reports::Tickets::SolvabilityPresenter.new(scope, solvability_report_without_confirmed_at) }
  subject(:presenter_organ_disabled) { Reports::Tickets::SolvabilityPresenter.new(scope, solvability_report_organ_disabled) }


  describe 'self.call' do
    it 'initialize' do
      allow(Reports::Tickets::SolvabilityPresenter).to receive(:new)

      presenter

      expect(Reports::Tickets::SolvabilityPresenter).to have_received(:new).with(scope, solvability_report)
    end
end

  describe 'helpers' do
    context 'rows' do
      context 'organ' do
        context 'enabled' do 
          let(:organ) { create(:executive_organ) }

          let(:row) do
            [
              organ.acronym,
              replied_on_time_count,
              replied_out_of_time_count,
              open_on_time_count,
              open_out_of_time_count,
              solvability
            ]
          end

          let(:replied_on_time_count) { 2 }
          let(:replied_out_of_time_count) { 1 }
          let(:open_on_time_count) { 3 }
          let(:open_out_of_time_count) { 2 }
          let(:solvability) { Ticket::Solvability::SectoralService.call(scope, organ).round 2 }

          before do
            # respondidas no prazo: 2
            create(:ticket, :with_parent_sic, :replied, organ: organ,confirmed_at: Date.new(1900, 1, 17))
            create(:ticket, :with_parent_sic, :replied, organ: organ)
            ticket = create(:ticket, :with_parent_sic, :replied, organ: organ, appeals: 1, appeals_at: 2.months.ago)

            ## Recurso SIC deve ser desconsiderado dos relatórios e do cálculo de resolubilidade
            ## Respostas de recurso SIC ficam SEMPRE no ticket pai
            create(:answer, :final, ticket: ticket.parent, sectoral_deadline: -1, version: 1)

            # respondidas fora do prazo: 1
            ticket = create(:ticket, :with_parent_sic, :replied, organ: organ)
            ticket.answers.update_all(sectoral_deadline: -1)


            # em atendimento no prazo: 3
            create(:ticket, :with_parent_sic, organ: organ)
            create(:ticket, :with_parent_sic, organ: organ)
            create(:ticket, :with_parent_sic, organ: organ)

            # em atendimento fora do prazo: 2
            create(:ticket, :with_parent_sic, organ: organ, deadline: -3)
            create(:ticket, :with_parent_sic, organ: organ, deadline: -2)
          end

          it { expect(presenter.rows).to eq([row]) }
          context 'presenter without confirmed_at ' do
            it { expect(presenter_without_confirmed_at.rows).to eq([row]) }
          end
          
        end

        context 'disabled' do
          let(:organ_disabled) {create(:executive_organ, disabled_at: DateTime.now)}

          let(:row) do
            [
              organ_disabled.acronym,
              replied_on_time_count,
              replied_out_of_time_count,
              open_on_time_count,
              open_out_of_time_count,
              solvability
            ]
          end

          let(:replied_on_time_count) { 2 }
          let(:replied_out_of_time_count) { 1 }
          let(:open_on_time_count) { 3 }
          let(:open_out_of_time_count) { 2 }
          let(:solvability) { Ticket::Solvability::SectoralService.call(scope, organ_disabled).round 2 }

          before do
            # respondidas no prazo: 2
            create(:ticket, :with_parent_sic, :replied, organ: organ_disabled,confirmed_at: Date.new(1900, 1, 17))
            create(:ticket, :with_parent_sic, :replied, organ: organ_disabled)
            ticket = create(:ticket, :with_parent_sic, :replied, organ: organ_disabled, appeals: 1, appeals_at: 2.months.ago)

            ## Recurso SIC deve ser desconsiderado dos relatórios e do cálculo de resolubilidade
            ## Respostas de recurso SIC ficam SEMPRE no ticket pai
            create(:answer, :final, ticket: ticket.parent, sectoral_deadline: -1, version: 1)

            # respondidas fora do prazo: 1
            ticket = create(:ticket, :with_parent_sic, :replied, organ: organ_disabled)
            ticket.answers.update_all(sectoral_deadline: -1)


            # em atendimento no prazo: 3
            create(:ticket, :with_parent_sic, organ: organ_disabled)
            create(:ticket, :with_parent_sic, organ: organ_disabled)
            create(:ticket, :with_parent_sic, organ: organ_disabled)

            # em atendimento fora do prazo: 2
            create(:ticket, :with_parent_sic, organ: organ_disabled, deadline: -3)
            create(:ticket, :with_parent_sic, organ: organ_disabled, deadline: -2)
          end

          context 'presenter organ_disabled ' do
            it { expect(presenter_organ_disabled.rows).to eq([row]) }
          end
        end
      end
    end
  end
end
