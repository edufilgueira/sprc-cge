require 'rails_helper'

describe Operator::CallCenterTicketsController do

  let(:user) { create(:user, :operator_call_center_supervisor) }

  let(:ticket) { create(:ticket, :replied, :call_center) }

  let(:permitted_params) { [:call_center_responsible_id] }

  describe '#index' do
    context 'unauthorized' do
      before { get(:index) }

      it { is_expected.to redirect_to(new_user_session_path) }
    end

    context 'authorized' do
      before {
        create(:executive_organ, :cosco)
        create(:executive_organ, :couvi)
        sign_in(user) && get(:index)
      }

      context 'template' do
        render_views

        it { is_expected.to respond_with(:success) }
      end

      context 'helpers' do

        describe 'tickets' do
          describe ' when call_center_supervisor' do

            let(:replied) { create(:ticket, :replied, :call_center, call_center_allocation_at: 3.days.ago) }

            before do
              create(:ticket, :call_center)
              ticket
              replied
             end

            # mostra apenas chamados respondidos

            it { expect(controller.tickets).to eq([replied, ticket]) }
          end

          describe ' when call_center' do
            let(:user) { create(:user, :operator_call_center) }

            let(:other_ticket) do
              create(:ticket, :replied, :with_call_center_responsible, call_center_responsible: user)
            end

            before { ticket }

            # mostra apenas chamados respondidos e com tipo de resposta telefone
            it { expect(controller.tickets).to eq([other_ticket]) }
          end
        end

        context 'readonly?' do
          it { expect(controller.readonly?).to be_falsey }
        end
      end

      context 'pagination' do
        it 'calls kaminari methods' do
          allow(Ticket).to receive(:page).and_call_original
          expect(Ticket).to receive(:page).and_call_original

          get(:index)

          # para poder acionar o método page que estamos testando

          controller.tickets
        end
      end

      context 'filter' do

        context 'default call_center_responsible_id nil' do
          let(:other) { create(:ticket, :replied, :with_call_center_responsible) }

          before do
            other
            ticket
            get(:index)
          end

          it { expect(controller.tickets).to eq([ticket]) }
        end

        context 'organ' do
          let(:parent) { create(:ticket, :replied, :call_center) }

          let(:ticket_with_organ) { create(:ticket, :with_parent, parent: parent)}
          let(:organ) { ticket_with_organ.organ }

          before do
            ticket
            get(:index, params: { organ: organ.id })
          end

          it { expect(controller.tickets).to eq([parent]) }
        end

        context 'parent_protocol' do
          let(:parent) { create(:ticket, :replied, :call_center) }
          let(:ticket_with_organ) { create(:ticket, :with_parent, parent: parent)}

          before do
            ticket
            get(:index, params: { parent_protocol: ticket_with_organ.parent_protocol })
          end

          it { expect(controller.tickets).to eq([parent]) }
        end

        context 'call_center_responsible_id' do
          let(:other) { create(:ticket, :replied, :with_call_center_responsible) }
          let(:responsible) { other.call_center_responsible }

          before do
            ticket
            get(:index, params: { call_center_responsible_id: responsible.id , call_center_status: 'waiting_feedback'})
          end

          it { expect(controller.tickets).to eq([other]) }
        end

        context 'priority' do
          let!(:priority_ticket) { create(:ticket, :replied, :call_center, priority: true) }

          before do
            ticket
            get(:index, params: { priority: '1' })
          end

          it { expect(controller.tickets).to eq([priority_ticket]) }
        end

        context 'call_center_feedback' do
          let!(:ticket_with_feedback) { create(:ticket, :replied, :call_center, :feedback) }

          before do
            ticket
            get(:index, params: { call_center_status: 'with_feedback' })
          end

          it { expect(controller.tickets).to eq([ticket_with_feedback]) }
        end
      end

      describe '#sort' do
        it 'sort_columns helper' do
            get(:index)

            expected = {
              created_at: 'tickets.created_at',
              deadline: 'tickets.deadline',
              call_center_allocation_at: 'tickets.call_center_allocation_at',
              name: 'tickets.name'
            }

            expect(controller.sort_columns).to eq(expected)
          end

        it 'default' do
          middle_unsorted = create(:ticket, :confirmed, :replied, :with_call_center_responsible, call_center_allocation_at: DateTime.now+1.day)
          last_unsorted = create(:ticket, :confirmed, :replied, :with_call_center_responsible, call_center_allocation_at: DateTime.now+2.day)
          first_unsorted = create(:ticket, :confirmed, :replied, :with_call_center_responsible, call_center_allocation_at: DateTime.now)

          last_unsorted
          middle_unsorted
          first_unsorted


          get(:index, params: { call_center_responsible_id: '' , call_center_status: 'waiting_feedback'})

          expect(controller.tickets).to eq([first_unsorted, middle_unsorted, last_unsorted])
        end

        it 'sort_column param' do
          get(:index, params: { sort_column: 'tickets.call_center_allocation_at'})

          join = Ticket.all
          sorted = join.sorted('tickets.call_center_allocation_at')
          scoped = sorted.phone.final_answer.parent_tickets
          filtered = scoped.where(call_center_responsible_id: nil).or(scoped.where(call_center_responsible_id: '__is_null__'))
          filtered = filtered.where(call_center_status: :waiting_allocation)
          paginated = filtered.page(controller.params[:page]).per(controller.class::PER_PAGE)
          expected = paginated.to_sql

          result = controller.tickets.to_sql

          expect(result).to eq(expected)
        end
      end
    end
  end

  describe '#show' do
    context 'unauthorized' do
      before { get(:show, params: { id: ticket }) }

      it { is_expected.to redirect_to(new_user_session_path) }
    end

    context 'authorized' do
      render_views
      before { sign_in(user) }

      context 'renders' do
        before { get(:show, params: { id: ticket }) }

        it { is_expected.to render_template('operator/call_center_tickets/show') }
        it { is_expected.to render_template('shared/tickets/_ticket_logs') }
        it { is_expected.to render_template('shared/tickets/_show') }
      end

      context 'helpers' do

        before { get(:show, params: { id: ticket }) }

        it 'ticket' do
          expect(controller.ticket).to eq(ticket)
        end

        it 'comment' do
          # criamos um novo comentário pra ser usado no form.

          get(:show, params: { id: ticket })

          expect(controller.comment).to be_present
          expect(controller.comment.commentable).to eq(ticket)
        end

        it 'new_evaluation' do
          get(:show, params: { id: ticket })

          expect(controller.new_evaluation).to be_present
          expect(controller.new_evaluation.call_center?).to be_truthy
        end
      end
    end
  end

  describe '#update_checked' do

    let(:ticket_1) { create(:ticket, :replied, :call_center) }
    let(:ticket_2) { create(:ticket, :replied, :call_center) }

    let(:valid_ticket_attributes) do
      { call_center_responsible_id: user.id }
    end

    let(:valid_ticket_params) do
      {
        checked_tickets: [
          ticket_1.id,
          ticket_2.id
        ],
        ticket: valid_ticket_attributes
      }
    end

    let(:invalid_ticket_params) do
      {
        checked_tickets: [""],
        ticket: valid_ticket_attributes
      }
    end

    context 'unauthorized' do
      before { patch(:update_checked, params: valid_ticket_params) }

      it { is_expected.to redirect_to(new_user_session_path) }
    end

    context 'authorized' do
      before { sign_in(user) }

      it 'permits ticket params' do
        should permit(*permitted_params).
          for(:update_checked, verb: :patch, params: valid_ticket_params ).on(:ticket)
      end

      context 'valid' do
        let!(:current_datetime) { DateTime.now }
        let(:service) { double }

        before do
          allow(DateTime).to receive(:now).and_return(current_datetime)

          allow(Notifier::AttendanceAllocation).to receive(:delay) { service }
          allow(service).to receive(:call)

          patch(:update_checked, params: valid_ticket_params)

          ticket_1.reload
          ticket_2.reload
        end

        it 'saves' do
          expect(ticket_1.call_center_responsible).to eq(user)
          expect(ticket_2.call_center_responsible).to eq(user)

          expect(response).to redirect_to(operator_call_center_tickets_path)
        end

        context 'sets call_center_allocation_at' do
          it { expect(ticket_1.call_center_allocation_at.to_datetime.utc.to_i).to eq(current_datetime.utc.to_i) }
          it { expect(ticket_2.call_center_allocation_at.to_datetime.utc.to_i).to eq(current_datetime.utc.to_i) }
        end

        context 'change call_center_status to waiting_feedback' do
          it { expect(ticket_1).to be_waiting_feedback }
          it { expect(ticket_2).to be_waiting_feedback }
        end

        context 'call notify' do
          it { expect(service).to have_received(:call).with(ticket_1.id, user.id) }
          it { expect(service).to have_received(:call).with(ticket_2.id, user.id) }
        end
      end

      context 'invalid' do
        it 'does not save' do
          patch(:update_checked, params: invalid_ticket_params)

          expect(ticket_1.call_center_responsible).to eq(nil)
          expect(ticket_2.call_center_responsible).to eq(nil)

          expect(response).to redirect_to(operator_call_center_tickets_path)
        end
        context 'nil call_center_responsible' do
          let(:service) { double }

          let(:invalid_ticket_params) do
            {
              checked_tickets: [
                ticket_1.id
              ],
              ticket: { call_center_responsible: nil }
            }
          end

          before do
            allow(Notifier::AttendanceAllocation).to receive(:delay) { service }
            allow(service).to receive(:call)

            patch(:update_checked, params: invalid_ticket_params)
          end
          it 'does not notify' do

            expect(service).to_not have_received(:call).with(ticket_1.id, nil)

            expect(response).to redirect_to(operator_call_center_tickets_path)
          end
        end
      end
    end
  end

  describe '#feedback' do
    let(:valid_ticket_params) { { id: ticket } }

    context 'unauthorized' do
      before { patch(:feedback, params: valid_ticket_params) }

      it { is_expected.to redirect_to(new_user_session_path) }
    end

    context 'authorized' do
      before { sign_in(user) }

      context 'valid' do

        it 'saves' do
          now = DateTime.now
          allow(DateTime).to receive(:now) { now }

          patch(:feedback, params: valid_ticket_params)

          ticket.reload

          expect(ticket.call_center_feedback_at.utc.to_s).to eq(now.utc.to_s)
          expect(ticket).to be_with_feedback

          expect(response).to redirect_to(operator_call_center_ticket_path(ticket))
        end

        it 'register ticket_log for feedback' do
          allow(RegisterTicketLog).to receive(:call).with(anything, anything, :attendance_finalized)

          patch(:feedback, params: valid_ticket_params)

          expect(RegisterTicketLog).to have_received(:call).with(ticket, user, :attendance_finalized)
        end
      end
    end
  end
end
