require 'rails_helper'

describe Operator::Reports::StatsTicketsController do

  let(:stats_ticket) { create(:stats_ticket) }
  let(:user) { create(:user, :operator) }

  describe '#index' do
    context 'unauthorized' do
      before { get(:index) }

      it { is_expected.to redirect_to(new_user_session_path) }
    end

    context 'authorized' do
      before { sign_in(user) }

      context 'template' do
        before { get(:index) }
        render_views

        it { is_expected.to respond_with(:success) }
      end

      context 'helper method' do

        context 'filters' do
          let(:default_filters) do
            {
              month_start: 1,
              month_end: 2,
              year: 2017
            }
          end

          let(:filter_params) { default_filters }

          before { get(:index, params: filter_params) }

          it { expect(controller.filters[:month_start]).to eq(filter_params[:month_start].to_s) }
          it { expect(controller.filters[:month_end]).to eq(filter_params[:month_end].to_s) }
          it { expect(controller.filters[:year]).to eq(filter_params[:year].to_s) }

          context 'default' do
            let(:filter_params) { {} }

            it { expect(controller.filters[:month_start]).to eq(Date.today.beginning_of_year.month) }
            it { expect(controller.filters[:month_end]).to eq(Date.today.month) }
            it { expect(controller.filters[:year]).to eq(Date.today.year) }
            it { expect(controller.filters[:organ]).to eq(nil) }
          end

          context 'organ' do
            let(:filter_params) do
              default_filters.merge(organ: 1)
            end

            it { expect(controller.filters[:organ]).to eq('1') }
          end

          context 'sectoral_organ' do
            let(:user) { create(:user, :operator_sectoral) }
            let(:organ) { user.organ }

            context 'general' do
              let(:filter_params) do
                default_filters.merge(sectoral_organ: :general)
              end

              it { expect(controller.filters[:sectoral_organ]).to eq('general') }
            end

            context 'sectoral' do
              let(:filter_params) do
                default_filters.merge(sectoral_organ: :sectoral)
              end

              it { expect(controller.filters[:sectoral_organ]).to eq('sectoral') }
            end
          end
        end

        it 'title' do
          expect(controller.title).to eq(I18n.t('shared.reports.stats_tickets.index.title'))
        end

        context 'current_stats_ticket' do
          let(:month_start) { Date.today.month }
          let(:month_end) { Date.today.month }
          let(:year) {  Date.today.year }
          let(:organ) {  create(:executive_organ) }

          let!(:stats_ticket_sou) { create(:stats_ticket, ticket_type: :sou, month_start: month_start, month_end: month_end, year: year, organ: organ) }
          let!(:stats_ticket_sic) { create(:stats_ticket, ticket_type: :sic, month_start: month_start, month_end: month_end, year: year, organ: organ) }

          let(:stats_ticket_scope) do
            {
              ticket_type: :sou,
              month_start: "#{month_start}",
              month_end: "#{month_end}",
              year: "#{year}",
              organ_id: "#{organ.id}",
              subnet_id: nil
            }
          end

          let(:filter_params) do
            {
              month_start: month_start,
              month_end: month_end,
              year: year,
              organ: organ.id
            }
          end

          before do
            allow(Stats::Ticket).to receive(:current_by_scope!).and_call_original

            get(:index , params: filter_params)

            controller.current_stats_ticket(:sou)
          end

          it { expect(controller.current_stats_ticket(:sou)).to eq(stats_ticket_sou) }
          it { expect(controller.current_stats_ticket(:sic)).to eq(stats_ticket_sic) }

          context 'when operator cge' do
            let(:user) { create(:user, :operator_cge) }

            it { expect(Stats::Ticket).to have_received(:current_by_scope!).with(stats_ticket_scope) }
          end

          context 'when operator sectoral' do
            let(:user) { create(:user, :operator_sectoral) }

            let(:filter_params) do
              {
                month_start: month_start,
                month_end: month_end,
                year: year,
                sectoral_organ: filter_sectoral_organ
              }
            end

            context 'filter sectoral_organ' do
              context 'general' do
                let(:filter_sectoral_organ) { :general }

                let(:stats_ticket_scope) do
                  {
                    ticket_type: :sou,
                    month_start: "#{month_start}",
                    month_end: "#{month_end}",
                    year: "#{year}",
                    organ_id: nil,
                    subnet_id: nil
                  }
                end

                it { expect(Stats::Ticket).to have_received(:current_by_scope!).with(stats_ticket_scope) }
              end

              context 'sectoral' do
                let(:filter_sectoral_organ) { :sectoral }
                let(:organ) { user.organ }

                let(:stats_ticket_scope) do
                  {
                    ticket_type: :sou,
                    month_start: "#{month_start}",
                    month_end: "#{month_end}",
                    year: "#{year}",
                    organ_id: organ.id,
                    subnet_id: nil
                  }
                end

                it { expect(Stats::Ticket).to have_received(:current_by_scope!).with(stats_ticket_scope) }
              end
            end
          end

          context 'when operator subnet' do
            let(:user) { create(:user, :operator_subnet_sectoral) }
            let(:subnet) { user.subnet }

            let(:filter_params) do
              {
                month_start: month_start,
                month_end: month_end,
                year: year,
                sectoral_subnet: filter_sectoral_subnet
              }
            end

            context 'filter sectoral_subnet' do
              context 'general' do
                let(:filter_sectoral_subnet) { :general }

                let(:stats_ticket_scope) do
                  {
                    ticket_type: :sou,
                    month_start: "#{month_start}",
                    month_end: "#{month_end}",
                    year: "#{year}",
                    organ_id: nil,
                    subnet_id: nil
                  }
                end

                it { expect(Stats::Ticket).to have_received(:current_by_scope!).with(stats_ticket_scope) }
              end

              context 'sectoral' do
                let(:filter_sectoral_subnet) { :sectoral }
                let(:organ) { user.organ }

                let(:stats_ticket_scope) do
                  {
                    ticket_type: :sou,
                    month_start: "#{month_start}",
                    month_end: "#{month_end}",
                    year: "#{year}",
                    organ_id: nil,
                    subnet_id: subnet.id
                  }
                end

                it { expect(Stats::Ticket).to have_received(:current_by_scope!).with(stats_ticket_scope) }
              end
            end
          end
        end

        describe 'stats_tabs' do
          it 'tabs for sic operator' do
            allow_any_instance_of(User).to receive(:sic_operator?).and_return(true)

            expected = [:sic, :sou]

            get(:index)

            expect(controller.stats_tabs).to eq(expected)
          end

          it 'tabs for sou operator' do
            allow_any_instance_of(User).to receive(:sou_operator?).and_return(true)

            expected = [:sou, :sic]

            get(:index)

            expect(controller.stats_tabs).to eq(expected)
          end

          it 'default' do
            allow_any_instance_of(User).to receive(:sic_operator?).and_return(false)
            allow_any_instance_of(User).to receive(:sou_operator?).and_return(false)

            expected = [:sic, :sou]

            get(:index)

            expect(controller.stats_tabs).to eq(expected)
          end
        end
      end
    end
  end

  describe '#show' do

    let(:params) { { id: stats_ticket.id } }

    context 'unauthorized' do
      before { get(:show, params: params) }

      it { is_expected.to redirect_to(new_user_session_path) }
    end

    context 'authorized' do
      render_views
      before { sign_in(user) && get(:show, params: { id: stats_ticket })  }

      context 'render template' do
        it { is_expected.to render_template('operator/reports/stats_tickets/show') }
      end

      describe 'helper methods' do
        it 'stats_ticket' do
          expect(controller.stats_ticket).to eq(stats_ticket)
        end
      end
    end
  end
end
