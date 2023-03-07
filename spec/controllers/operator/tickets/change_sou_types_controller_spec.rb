require 'rails_helper'

describe Operator::Tickets::ChangeSouTypesController do

  let(:user) { create(:user, :operator_cge_denunciation_tracking) }
  let(:ticket) { create(:ticket, :with_parent) }
  let(:ticket_parent) { ticket.parent }
  let(:denunciation_ticket) { create(:ticket, :with_parent, :denunciation, parent: ticket_parent) }
  let(:other_ticket) { create(:ticket, :with_parent, parent: ticket_parent) }

  let(:permitted_params) do
    [
      :sou_type,
      :denunciation_organ_id,
      :denunciation_description,
      :denunciation_date,
      :denunciation_place,
      :denunciation_witness,
      :denunciation_evidence,
      :denunciation_assurance
    ]
  end

  describe "#new" do
    context 'unauthorized' do
      before { get(:new, params: { ticket_id: 1 }) }

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
        post(:create, params: { ticket_id: 1 })
      end

      it { is_expected.to redirect_to(new_user_session_path) }
    end

    context 'authorized' do
      before { sign_in(user) }

      it 'permits ticket params' do
        should permit(*permitted_params).for(:create, params: { ticket_id: ticket.id, ticket: ticket.attributes })
      end

      context 'saves' do
        context 'parent' do
          it 'and change children' do
            new_sou_type = 'suggestion'

            valid_ticket_params = { ticket_id: ticket_parent, ticket: ticket_parent.attributes }

            valid_ticket_params[:ticket][:sou_type] = new_sou_type
            valid_ticket_params[:justification] = 'justification'

            post(:create, params: valid_ticket_params)

            expected_flash = I18n.t("operator.tickets.change_sou_types.create.done")

            ticket_parent.reload
            ticket.reload

            expect(ticket_parent.sou_type).to eq("suggestion")
            expect(ticket.sou_type).to eq("suggestion")
            expect(response).to redirect_to(operator_ticket_path(ticket_parent))
            expect(controller).to set_flash.to(expected_flash)
          end
        end

        context 'children' do
          it 'change parent if not denunciation' do
            new_sou_type = 'suggestion'

            valid_ticket_params = { ticket_id: denunciation_ticket, ticket: denunciation_ticket.attributes }

            valid_ticket_params[:ticket][:sou_type] = new_sou_type
            valid_ticket_params[:justification] = 'justification'

            post(:create, params: valid_ticket_params)

            expected_flash = I18n.t("operator.tickets.change_sou_types.create.done")

            ticket_parent.reload
            denunciation_ticket.reload

            expect(ticket_parent.sou_type).to eq("suggestion")
            expect(denunciation_ticket.sou_type).to eq("suggestion")
            expect(ticket.sou_type).to eq("complaint")
            expect(response).to redirect_to(operator_ticket_path(denunciation_ticket))
            expect(controller).to set_flash.to(expected_flash)
          end

          it 'change parent if not denunciation' do
            new_sou_type = 'denunciation'

            valid_ticket_params = { ticket_id: other_ticket, ticket: other_ticket.attributes }

            valid_ticket_params[:ticket][:sou_type] = new_sou_type
            valid_ticket_params[:justification] = 'justification'
            valid_ticket_params[:ticket][:denunciation_date] = 'denunciation_date'
            valid_ticket_params[:ticket][:denunciation_place] = 'denunciation_place'
            valid_ticket_params[:ticket][:denunciation_assurance] = :assured
            valid_ticket_params[:ticket][:denunciation_witness] = 'denunciation_witness'
            valid_ticket_params[:ticket][:denunciation_evidence] = 'denunciation_evidence'

            post(:create, params: valid_ticket_params)

            expected_flash = I18n.t("operator.tickets.change_sou_types.create.done")

            ticket_parent.reload
            other_ticket.reload

            expect(ticket_parent.sou_type).to eq("denunciation")
            expect(other_ticket.sou_type).to eq("denunciation")
            expect(ticket.sou_type).to eq("complaint")
            expect(response).to redirect_to(operator_ticket_path(other_ticket))
            expect(controller).to set_flash.to(expected_flash)
          end

          it 'does not change parent if any denunciation' do
            denunciation_ticket
            new_sou_type = 'suggestion'

            valid_ticket_params = { ticket_id: ticket, ticket: ticket.attributes }

            valid_ticket_params[:ticket][:sou_type] = new_sou_type
            valid_ticket_params[:justification] = 'justification'

            post(:create, params: valid_ticket_params)

            expected_flash = I18n.t("operator.tickets.change_sou_types.create.done")

            ticket_parent.reload
            ticket.reload

            expect(ticket_parent.sou_type).to eq("complaint")
            expect(ticket.sou_type).to eq("suggestion")
            expect(denunciation_ticket.sou_type).to eq("denunciation")
            expect(response).to redirect_to(operator_ticket_path(ticket))
            expect(controller).to set_flash.to(expected_flash)
          end

        end
      end

      it 'invalid' do
        new_sou_type = 'suggestion'

        valid_ticket_params = { ticket_id: ticket, ticket: ticket.attributes }

        valid_ticket_params[:ticket][:sou_type] = new_sou_type
        valid_ticket_params[:justification] = ''

        expect do
          post(:create, params: valid_ticket_params)

          expected_flash = I18n.t("operator.tickets.change_sou_types.create.fail")

          ticket.reload

          expect(response).to render_template('operator/tickets/change_sou_types/new')
          expect(controller).to set_flash.now.to(expected_flash)
        end.to change(TicketLog, :count).by(0)
      end

      it 'when not modified sou_type' do
        allow(RegisterTicketLog).to receive(:call)

        new_sou_type = ticket.sou_type

        valid_ticket_params = { ticket_id: ticket, ticket: ticket.attributes }

        valid_ticket_params[:ticket][:sou_type] = new_sou_type
        valid_ticket_params[:justification] = 'justification'

        post(:create, params: valid_ticket_params)

        expect(RegisterTicketLog).to receive(:call).exactly(0).times
      end

      it 'creates ticket_log with justification' do
        # A partial que renderiza os históricos pega sempre o parent do ticket.
        # Talvez isso seja feito para ter o log de criação da manifestação.
        #
        # Por isso, vamos registrar o log no parent e usar um data[:target_ticket_id]
        # para fazer referência ao ticket original (child) que pode teve seu
        # sou_type alterado.

        ticket = create(:ticket, :with_parent, created_by: user)
        parent_ticket = ticket.parent

        old_sou_type = 'complaint'
        new_sou_type = 'suggestion'

        valid_ticket_params = { ticket_id: ticket, ticket: ticket.attributes }

        valid_ticket_params[:ticket][:name] = 'new name'
        valid_ticket_params[:ticket][:sou_type] = new_sou_type
        valid_ticket_params[:justification] = 'justification'

        expect do
          post(:create, params: valid_ticket_params)

          last_log = TicketLog.last

          expect(last_log.action).to eq('change_sou_type')
          expect(last_log.responsible).to eq(user)
          expect(last_log.ticket).to eq(parent_ticket)
          expect(last_log.description).to eq('justification')

          expect(last_log.data).to eq({
            from: old_sou_type,
            to: new_sou_type,
            target_ticket_id: ticket.id
           })

        end.to change(TicketLog, :count).by(1)
      end
    end
  end
end
