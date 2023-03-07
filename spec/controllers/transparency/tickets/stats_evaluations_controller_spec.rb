require 'rails_helper'

describe Transparency::Tickets::StatsEvaluationsController do

  let(:last_month) { Date.today.last_month }
  let(:current_month) { current_date.month }
  let(:current_year) { current_date.year }

  describe 'index' do

    context 'template' do
      before { get(:index) }
      render_views

      it { is_expected.to respond_with(:success) }
      it { is_expected.to render_template(:index) }
    end

    describe 'helper_methods' do

      context 'stats_evaluations' do
        it 'default last month' do
          stats_evaluation = create(:stats_evaluation, year: last_month.year, month: last_month.month)

          get(:index)

          expect(controller.stats_evaluations).to eq([stats_evaluation])
        end

        it 'by date' do
          filter_date = Date.new(2018, 1)

          stats_evaluation_current_month = create(:stats_evaluation)
          stats_evaluation_date = create(:stats_evaluation, month: filter_date.month, year: filter_date.year)

          get(:index, params: { month_year: "#{filter_date.month}/#{filter_date.year}" } )

          expect(controller.stats_evaluations).to eq([stats_evaluation_date])
        end

        it 'by evaluation_type' do
          stats_evaluation = create(:stats_evaluation)
          stats_evaluation_call_center = create(:stats_evaluation, evaluation_type: :call_center, year: last_month.year, month: last_month.month)

          get(:index, params: { evaluation_type: 'call_center' })

          expect(controller.stats_evaluations).to eq([stats_evaluation_call_center])
        end
      end
    end
  end

  describe 'create' do
    it 'call service' do
      filter_date = Date.new(2018, 1)

      service = double
      allow(UpdateStatsEvaluation).to receive(:delay) { service }
      allow(service).to receive(:call)

      post(:create, params: { month_year: "#{filter_date.month}/#{filter_date.year}", evaluation_type: 'call_center'})

      expect(service).to have_received(:call).with(filter_date.year.to_s, filter_date.month.to_s, 'call_center')
    end

    it 'redirect to the same index' do
      filter_date = Date.new(2018, 1)

      params = { month_year: "#{filter_date.month}/#{filter_date.year}", evaluation_type: 'call_center'}
      expected_flash = I18n.t('transparency.tickets.stats_evaluations.create.done')

      post(:create, params: params)

      is_expected.to set_flash.to(expected_flash)
      is_expected.to redirect_to(transparency_tickets_stats_evaluations_path(params))
    end
  end
end
