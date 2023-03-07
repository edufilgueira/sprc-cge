require 'rails_helper'

# Casos de teste do arquivo base devem estar implementados no SicPresenter e SouPresenter
describe Reports::Tickets::GrossExport::BasePresenter do

  let(:date) { Date.today }
  let(:gross_export_sou) { create(:gross_export, :all_columns, filters: { ticket_type: :sou, confirmed_at: { start: date.beginning_of_month, end: date.end_of_month} }) }
  let(:scope) { gross_export_sou.filtered_scope }

  subject(:presenter) { Reports::Tickets::GrossExport::BasePresenter.new(scope, gross_export_sou.id) }

  describe 'self.call' do
    it 'initialize' do
      allow(Reports::Tickets::GrossExport::BasePresenter).to receive(:new)

      presenter

      expect(Reports::Tickets::GrossExport::BasePresenter).to have_received(:new).with(scope, gross_export_sou.id)
    end
  end
end