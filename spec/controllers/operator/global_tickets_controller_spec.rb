require 'rails_helper'

describe Operator::GlobalTicketsController do

  let(:ticket_parent) { create(:ticket, :with_parent) }
  let(:user_sectoral) { create(:user, :operator_sectoral) }

  describe '#index' do
    context 'unauthorized' do
      before { get(:index) }

      it { is_expected.to redirect_to(new_user_session_path) }
    end

    context 'ability' do
      it 'operator_cge' do
        operator_cge = create(:user, :operator_cge)
        sign_in(operator_cge) && get(:index)

        is_expected.to respond_with(:success)
      end

      it 'operator_internal' do
        operator_internal = create(:user, :operator_internal)
        sign_in(operator_internal) && get(:index)

        is_expected.to respond_with(:forbidden)
      end

      it 'call_center_attendance' do
        operator_call_center = create(:user, :operator_call_center)
        sign_in(operator_call_center) && get(:index)

        is_expected.to respond_with(:success)
      end
    end

    context 'authorized' do
      before { sign_in(user_sectoral) && ticket_parent && get(:index) }

      describe 'template' do
        render_views

        it { is_expected.to respond_with(:success) }
        it { is_expected.to render_template('operator/global_tickets/index') }
        it { is_expected.to render_template('operator/global_tickets/_index') }
        it { is_expected.to render_template('operator/global_tickets/_ticket') }
        it { is_expected.to render_template('operator/global_tickets/_filters') }
      end

      describe 'pagination' do
        it 'calls kaminari methods' do
          allow(Ticket).to receive(:page).and_call_original
          expect(Ticket).to receive(:page).and_call_original

          controller.tickets
        end
      end

      describe 'search' do
        it 'by parent_protocol' do
          ticket_parent
          ticket_searched = create(:ticket)
          part_protocol = ticket_searched.parent_protocol

          get(:index, params: { parent_protocol: part_protocol })

          expect(controller.tickets).to eq([ticket_searched])
        end
      end

      describe 'filters' do
        it 'by internal_status' do
          ticket_parent
          ticket_filtered = create(:ticket, internal_status: :internal_attendance)

          get(:index, params: { internal_status: :internal_attendance })

          expect(controller.tickets).to eq([ticket_filtered])
        end

        it 'by used_input' do
          ticket_parent
          ticket_filtered = create(:ticket, used_input: :consumer_gov)

          get(:index, params: { used_input: :consumer_gov })

          expect(controller.tickets).to eq([ticket_filtered])
        end

        it 'by organ' do
          ticket_child = create(:ticket, :with_parent)
          ticket_filtered = ticket_child.parent
          organ = ticket_child.organ
          ticket_parent

          get(:index, params: { organ: organ })

          expect(controller.tickets).to eq([ticket_filtered])
        end

        context 'created_at' do

          before do
            create(:ticket, created_at: Time.zone.parse('2001-2-3 1:00'))
            create(:ticket, created_at: Time.zone.parse('2002-2-3 1:00'))
            create(:ticket, created_at: Time.zone.parse('2005-2-3 1:00'))
          end

          it 'after date' do
            created_at = {
              start: '01/01/2016',
              end: ''
            }

            get(:index, params: { created_at: created_at })

            expect(controller.tickets.size).to eq(1)
          end

          it 'in date' do
            created_at = {
              start: '01/01/2000',
              end: '01/01/2004'
            }

            get(:index, params: { created_at: created_at })

            expect(controller.tickets.size).to eq(2)
          end

          it 'before date' do
            created_at = {
              start: '',
              end: '01/01/2000'
            }

            get(:index, params: { created_at: created_at })

            expect(controller.tickets.size).to eq(0)
          end

          it 'same day' do
            created_at = {
              start: '03/02/2001',
              end: '03/02/2001'
            }

            get(:index, params: { created_at: created_at })

            expect(controller.tickets.size).to eq(1)
          end
        end
      end

      describe '#sort' do
        it 'sou sort_columns helper' do
          expected = [
            'tickets.parent_protocol',
            'tickets.created_at',
            'tickets.ticket_type',
            'tickets.internal_status',
            'tickets.used_input'
          ]

          expect(controller.sort_columns).to eq(expected)
        end

        it 'sort_column for default scope' do
          sorted = Ticket.parent_tickets.sorted('tickets.parent_protocol', :desc)
          paginated = sorted.page(controller.params[:page]).per(controller.class::PER_PAGE)
          expected = paginated.to_sql

          result = controller.tickets.to_sql

          expect(result).to eq(expected)
        end
      end
    end
  end
end
