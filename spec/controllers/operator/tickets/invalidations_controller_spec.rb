require 'rails_helper'

describe Operator::Tickets::InvalidationsController do

  let(:ticket) { create(:ticket, :with_parent) }
  let(:user) { create(:user, :operator_sectoral, organ: ticket.organ) }
  let(:ticket_parent) { ticket.parent }

  let(:justification) { 'invalidate justification' }

  describe "#new" do
    context 'unauthorized' do
      before { get(:new, params: { ticket_id: ticket }) }

      it { is_expected.to redirect_to(new_user_session_path) }
    end

    context 'authorized' do
      before { sign_in(user) && get(:new, params: { ticket_id: ticket }) }

      context 'template' do
        render_views

        it { is_expected.to respond_with(:success) }
        it { is_expected.to render_template(:new) }
      end
    end
  end

  describe '#create' do
    context 'unauthorized' do
      before do
        post(:create, params: { ticket_id: ticket, justification: justification })
      end

      it { is_expected.to redirect_to(new_user_session_path) }
    end

    context 'authorized' do
      before { sign_in(user) }

      render_views

      context 'valid with operator coordination' do
        let(:user_coordination) { create(:user, :operator_coordination) }

        before do
          sign_in(user_coordination)
        end

        it 'saves' do
          post(:create, params: { ticket_id: ticket_parent, justification: justification })

          expect(controller).to redirect_to(operator_ticket_path(ticket_parent))
          expect(controller).to set_flash.to(I18n.t('operator.tickets.invalidations.create.done'))
          expect(ticket_parent.reload.invalidated?).to be_truthy
          expect(ticket.reload.invalidated?).to be_truthy
        end

        it 'ticket_log' do
          allow(RegisterTicketLog).to receive(:call)

          post(:create, params: { ticket_id: ticket_parent, justification: justification })

          data = { status: :approved, target_ticket_id: ticket_parent.id }
          expect(RegisterTicketLog).to have_received(:call).with(ticket_parent, user_coordination, :invalidate, { description: justification, data: data })
        end

        context 'when parent has more than one child' do
          before do
            other_ticket = create(:ticket, :with_organ, parent_id: ticket_parent)
            ticket_parent.tickets << other_ticket

            allow(RegisterTicketLog).to receive(:call)

            post(:create, params: { ticket_id: ticket_parent, justification: justification })

            ticket_parent.reload
            ticket.reload
          end

          it 'invalidate all related ticket_parent' do
            all_children_invalidated = ticket_parent.tickets.all?(&:invalidated?)

            expect(ticket_parent).to be_invalidated
            expect(all_children_invalidated).to be_truthy
          end

          it 'ticket log after approve' do
            ticket_child1 = ticket_parent.tickets.first
            ticket_child2 = ticket_parent.tickets.last

            data = { status: :approved, target_ticket_id: ticket_parent.id }
            data_child1 = { status: :approved, target_ticket_id: ticket_child1.id }
            data_child2 = { status: :approved, target_ticket_id: ticket_child2.id }

            expect(RegisterTicketLog).to have_received(:call).with(ticket_parent, user_coordination, :invalidate, { description: justification, data: data })

            expect(RegisterTicketLog).to have_received(:call).with(ticket_parent, user_coordination, :invalidate, { description: justification, data: data_child1 })
            expect(RegisterTicketLog).to have_received(:call).with(ticket_child1, user_coordination, :invalidate, { description: justification, data: data_child1 })

            expect(RegisterTicketLog).to have_received(:call).with(ticket_parent, user_coordination, :invalidate, { description: justification, data: data_child2 })
            expect(RegisterTicketLog).to have_received(:call).with(ticket_child2, user_coordination, :invalidate, { description: justification, data: data_child2 })
          end
        end
      end

      context 'valid with operator cge' do
        let(:user_cge) { create(:user, :operator_cge) }

        before do
          sign_in(user_cge)
        end

        it 'saves' do
          post(:create, params: { ticket_id: ticket_parent, justification: justification })

          expect(controller).to redirect_to(operator_ticket_path(ticket_parent))
          expect(controller).to set_flash.to(I18n.t('operator.tickets.invalidations.create.done'))
          expect(ticket_parent.reload.invalidated?).to be_truthy
          expect(ticket.reload.invalidated?).to be_truthy
        end

        it 'ticket_log' do
          allow(RegisterTicketLog).to receive(:call)

          post(:create, params: { ticket_id: ticket_parent, justification: justification })

          data = { status: :approved, target_ticket_id: ticket_parent.id }
          expect(RegisterTicketLog).to have_received(:call).with(ticket_parent, user_cge, :invalidate, { description: justification, data: data })
        end

        context 'when parent has more than one child' do
          before do
            other_ticket = create(:ticket, :with_organ, parent_id: ticket_parent)
            ticket_parent.tickets << other_ticket

            allow(RegisterTicketLog).to receive(:call)
            post(:create, params: { ticket_id: ticket_parent, justification: justification })

            ticket_parent.reload
            ticket.reload
          end

          it 'invalidate all related ticket_parent' do
            all_children_invalidated = ticket_parent.tickets.all?(&:invalidated?)

            expect(ticket_parent).to be_invalidated
            expect(all_children_invalidated).to be_truthy
          end

          it 'ticket log after approve' do
            ticket_child1 = ticket_parent.tickets.first
            ticket_child2 = ticket_parent.tickets.last

            data = { status: :approved, target_ticket_id: ticket_parent.id }
            data_child1 = { status: :approved, target_ticket_id: ticket_child1.id }
            data_child2 = { status: :approved, target_ticket_id: ticket_child2.id }

            expect(RegisterTicketLog).to have_received(:call).with(ticket_parent, user_cge, :invalidate, { description: justification, data: data })

            expect(RegisterTicketLog).to have_received(:call).with(ticket_parent, user_cge, :invalidate, { description: justification, data: data_child1 })
            expect(RegisterTicketLog).to have_received(:call).with(ticket_child1, user_cge, :invalidate, { description: justification, data: data_child1 })

            expect(RegisterTicketLog).to have_received(:call).with(ticket_parent, user_cge, :invalidate, { description: justification, data: data_child2 })
            expect(RegisterTicketLog).to have_received(:call).with(ticket_child2, user_cge, :invalidate, { description: justification, data: data_child2 })
          end
        end
      end

      context 'valid with operator sectoral' do
        let(:user_sectoral) { create(:user, :operator_sectoral) }
        let(:ticket_sectoral) { create(:ticket, :with_parent, organ: user_sectoral.organ, internal_status: :sectoral_attendance) }

        before do
          sign_in(user_sectoral)
        end

        it 'saves' do
          post(:create, params: { ticket_id: ticket_sectoral, justification: justification })

          expect(controller).to redirect_to(operator_ticket_path(ticket_sectoral))
          expect(controller).to set_flash.to(I18n.t('operator.tickets.invalidations.create.request_done'))
          expect(ticket_sectoral.reload.awaiting_invalidation?).to be_truthy
        end

        it 'ticket_log' do
          allow(RegisterTicketLog).to receive(:call)

          post(:create, params: { ticket_id: ticket_sectoral, justification: justification })

          data = { status: :waiting , target_ticket_id: ticket_sectoral.id }
          expect(RegisterTicketLog).to have_received(:call).with(ticket_sectoral.parent, user_sectoral, :invalidate, { description: justification, data: data })
        end
      end

      context 'invalid' do
        it 'does not saves' do
          post(:create, params: { ticket_id: ticket, ticket: { justification: '' } })

          expect(controller).to render_template(:new)
          expect(controller).to set_flash.now.to(I18n.t('operator.tickets.invalidations.create.fail'))
          expect(ticket.reload.invalidated?).to be_falsey
        end
      end

      context 'notify' do
        let(:service) { double }

        before do
          allow(Notifier::Invalidate).to receive(:delay) { service }
          allow(service).to receive(:call)

          post(:create, params: { ticket_id: ticket, justification: justification })
        end

        it { expect(service).to have_received(:call).with(ticket.id, user.id) }
      end
    end
  end

  context 'operator cge evaluate invalidations' do
    let(:organ) { create(:executive_organ) }
    let(:sectoral_operator) { create(:user, :operator_sectoral, organ: organ) }
    let(:operator_cge) { create(:user, :operator_cge) }

    let(:ticket) { create(:ticket, :with_parent, organ: organ, internal_status: :awaiting_invalidation) }
    let(:ticket_parent) { ticket.parent }

    let!(:ticket_log) { create(:ticket_log, ticket: ticket_parent, responsible: sectoral_operator, action: :invalidate, description: 'bla')}
    let(:ticket_log_child) { create(:ticket_log, ticket: ticket, responsible: sectoral_operator, action: :invalidate, description: 'bla')}

    describe '#approve' do
      let(:valid_params) do
        {
          ticket_id: ticket,
          id: ticket_log_child
        }
      end

      context 'unauthorized' do
        before { patch(:approve, params: valid_params) }

        it { is_expected.to redirect_to(new_user_session_path) }
      end

      context 'authorized' do
        before { sign_in(operator_cge) }

        render_views

        it 'saves' do
          post(:approve, params: valid_params)

          ticket.reload
          ticket_parent.reload

          expect(ticket).to be_invalidated
          expect(ticket_parent).to be_invalidated
          expect(controller).to redirect_to(operator_ticket_path(ticket_parent))
        end

        context 'when parent has more than one child' do
          before do
            other_ticket = create(:ticket, :with_organ, parent_id: ticket_parent)
            ticket_parent.tickets << other_ticket

            allow(RegisterTicketLog).to receive(:call)

            post(:approve, params: valid_params)

            ticket.reload
          end

          it 'invalidate only ticket' do
            expect(ticket).to be_invalidated
            expect(ticket_parent).not_to be_invalidated
          end

          it 'ticket log after approve' do
            data = { status: :approved, target_ticket_id: ticket.id }
            expect(RegisterTicketLog).to have_received(:call).with(ticket.parent, operator_cge, :invalidate, { description: nil, data: data })
            expect(RegisterTicketLog).to have_received(:call).with(ticket, operator_cge, :invalidate, { description: nil, data: data })
          end
        end

        context 'when parent has one child' do
          before do
            allow(RegisterTicketLog).to receive(:call)

            post(:approve, params: valid_params)

            ticket.reload
            ticket_parent.reload
          end

          it 'invalidate child and parent' do
            expect(ticket).to be_invalidated
            expect(ticket_parent).to be_invalidated
          end

          it 'ticket log after approve' do
            data = { status: :approved, target_ticket_id: ticket.id }
            expect(RegisterTicketLog).to have_received(:call).with(ticket_parent, operator_cge, :invalidate, { description: nil, data: data })
            expect(RegisterTicketLog).to have_received(:call).with(ticket, operator_cge, :invalidate, { description: nil, data: data })

            data_parent = { status: :approved, target_ticket_id: ticket_parent.id }
            expect(RegisterTicketLog).to have_received(:call).with(ticket_parent, operator_cge, :invalidate, { description: nil, data: data_parent })
          end
        end
      end
    end

    describe '#reject' do

      let(:valid_params) do
        {
          ticket_id: ticket_parent,
          id: ticket_log,
          comment: {
            description: 'updated description',
          }
        }
      end

      let(:invalid_params) do
        {
          ticket_id: ticket_parent,
          id: ticket_log,
          comment: {
            description: '',
          }
        }
      end

      context 'unauthorized' do
        before { patch(:reject, params: valid_params) }

        it { is_expected.to redirect_to(new_user_session_path) }
      end

      context 'authorized' do
        before { sign_in(operator_cge) }

        render_views

        it 'invalid' do
          patch(:reject, params: invalid_params)

          expected_flash = I18n.t('operator.tickets.invalidations.reject.fail')

          is_expected.to redirect_to(operator_ticket_path(ticket_parent))
          is_expected.to set_flash.to(expected_flash)
        end

        context 'valid' do
          it 'reject' do
            patch(:reject, params: valid_params)

            is_expected.to redirect_to(operator_ticket_path(ticket_parent))
            expect(controller.ticket.internal_status).to eq('sectoral_attendance')
          end

          it 'comment' do
            patch(:reject, params: valid_params)

            last_comment = Comment.last

            expect(last_comment.description).to eq(valid_params[:comment][:description])
            expect(last_comment).to be_internal
            expect(last_comment.author).to eq(controller.current_user)
            expect(last_comment.commentable_id).to eq(ticket_parent.id)
            expect(last_comment.commentable_type).to eq('Ticket')
          end

          it 'ticket log after reject' do
            allow(RegisterTicketLog).to receive(:call)

            post(:reject, params: valid_params)

            justification = valid_params[:comment][:description]
            data = { status: :rejected, target_ticket_id: ticket_parent.id }
            expect(RegisterTicketLog).to have_received(:call).with(ticket_parent, operator_cge, :invalidate, { description: justification, data: data})
          end
        end
      end
    end
  end
end
