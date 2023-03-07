require 'rails_helper'

describe Operator::Tickets::SharingsController do

  let(:organ) { create(:executive_organ) }

  let(:ticket_child) { create(:ticket, :with_parent, organ: organ) }
  let!(:ticket_parent) { ticket_child.parent }

  let(:cge_operator) { create(:user, :operator_cge) }
  let(:sectoral_operator) { create(:user, :operator_sectoral, organ: organ) }

  let(:base_params) { { ticket_id: ticket_child.id } }

  let(:permitted_params) do
    [
      tickets_attributes: [
        :id,
        :rede_ouvir,
        :organ_id,
        :subnet_id,
        :unknown_subnet,
        :description,
        :sou_type,
        :denunciation_organ_id,
        :denunciation_description,
        :denunciation_date,
        :denunciation_place,
        :denunciation_witness,
        :denunciation_evidence,
        :denunciation_assurance,
        :justification,
        protected_attachment_ids: []
      ]
    ]
  end

  describe '#new' do

    context 'unauthorized' do
      before { get(:new, params: base_params) }

      it { is_expected.to redirect_to(new_user_session_path) }
    end

    context 'authorized' do
      before { sign_in(sectoral_operator) }

      context 'template' do
        before { get(:new, params: base_params) }
        render_views

        it { is_expected.to respond_with(:success) }
        it { is_expected.to render_template('operator/tickets/sharings/new') }
        it { is_expected.to render_template('operator/tickets/sharings/_form') }
      end

      context 'helper method' do

        it 'description title for ticket parent' do
          get(:new, params: { ticket_id: ticket_parent.id })

          ticket_parent.reload
          expect(controller.title).to eq(I18n.t("operator.tickets.sharings.new.sou.title.add" , protocol: ticket_parent.parent_protocol))
        end

        it 'description title for ticket child' do
          get(:new, params: { ticket_id: ticket_child.id })

          ticket_child.reload
          expect(controller.title).to eq(I18n.t("operator.tickets.sharings.new.sou.title.share" , protocol: ticket_child.parent_protocol))
        end
      end
    end
  end

  describe '#create' do

    let(:ticket) { build(:ticket, :with_organ) }
    let(:ticket_invalid) { build(:ticket) }

    let(:reject_attributes) { %w[
        id
        protocol
        parent_protocol
        parent_id
        created_by
        created_at
        organ_id
        unknown_organ
        department_id
        description
        denunciation_description
        internal_status
        encrypted_password
        plain_password
        sou_type
        public_ticket
        published
      ]
    }

    let(:tickets_hash) do
      result = {}
      result[0] = ticket.attributes.except!(reject_attributes)
      result
    end

    let(:tickets_invalid_hash) do
      result = {}
      result[0] = ticket_invalid.attributes
      result
    end

    let(:ticket_attributes) { { tickets_attributes:  tickets_hash } }
    let(:ticket_invalid_attributes) { { tickets_attributes:  tickets_invalid_hash } }
    let(:ticket_attributes_log) { { tickets_attributes:  tickets_hash.first } }

    context 'unauthorized' do
      before { post(:create, params: { ticket_id: ticket_parent.id, ticket: ticket_parent }) }

      it { is_expected.to redirect_to(new_user_session_path) }
    end

    context 'authorized as cge operator' do
      before { sign_in(cge_operator) }

      it 'permits ticket params' do
        is_expected.to permit(*permitted_params).
          for(:create, params: { params: { ticket: ticket_attributes, ticket_id: ticket_parent } }).on(:ticket)
      end

      context 'valid' do
        it 'sharing parent ticket' do
          expect do
            post(:create, params: { ticket_id: ticket_parent, ticket: ticket_attributes })

            expected_flash = I18n.t('operator.tickets.sharings.create.done')

            expect(response).to redirect_to(operator_ticket_path(ticket_parent))
            is_expected.to set_flash.to(expected_flash)
          end.to change(Ticket, :count).by(1)
        end

        it 'sharing with rede_ouvir' do
          ticket_attributes[:tickets_attributes][0]['organ_id'] = create(:rede_ouvir_organ)

          expect do
            post(:create, params: { ticket_id: ticket_parent, ticket: ticket_attributes })
          end.to change(Ticket, :count).by(1)
        end

        context 'when have a attachment protection' do
          it 'Adding a ticket attachment protection' do
            expect do
              attachment_1 = create(:attachment, attachmentable: ticket_parent)
              attachment_2 = create(:attachment, attachmentable: ticket_parent)
              ticket_attributes[:tickets_attributes][0][:protected_attachment_ids] = [attachment_1.id, attachment_2.id]
              
              post(:create, params: { ticket_id: ticket_parent, ticket: ticket_attributes })
              
              log_attach = TicketLog.where(action: 'ticket_protect_attachment')
              expect(TicketLog.count).to eq(3) # Pai e dois filhos
              expect(log_attach.count).to eq(2) # dois filhos
              
            end.to change(TicketProtectAttachment, :count).by(2)
          end
        end

        context 'sharing to organ with subnet' do
          let(:organ_with_subnet) { create(:executive_organ, :with_subnet) }
          let(:subnet) { create(:subnet, organ: organ_with_subnet) }
          let(:ticket) { build(:ticket, :with_organ, organ: organ_with_subnet, subnet: subnet) }
          let(:tickets_hash) do
            result = {}
            result[0] = ticket.attributes.except!(reject_attributes)
            result[0][:subnet_id] = subnet.id
            result
          end

          it 'with subnet selected' do
            expect do
              post(:create, params: { ticket_id: ticket_parent, ticket: ticket_attributes })

              expected_flash = I18n.t('operator.tickets.sharings.create.done')

              expect(response).to redirect_to(operator_ticket_path(ticket_parent))
              is_expected.to set_flash.to(expected_flash)
            end.to change(Ticket, :count).by(1)
          end

          it 'with unknown_subnet selected' do
            tickets_hash[0][:unknown_subnet] = true
            tickets_hash[0][:subnet_id] = nil
            expect do
              post(:create, params: { ticket_id: ticket_parent, ticket: ticket_attributes })

              expected_flash = I18n.t('operator.tickets.sharings.create.done')

              expect(response).to redirect_to(operator_ticket_path(ticket_parent))
              is_expected.to set_flash.to(expected_flash)
            end.to change(Ticket, :count).by(1)
          end
        end

        describe 'denunciation' do
          let(:ticket_parent) { create(:ticket, :denunciation, :confirmed) }
          let(:cge_operator) { create(:user, :operator_cge_denunciation_tracking) }

          it 'sharing parent ticket when denunciation' do
            tickets_hash[0]['sou_type'] = :denunciation
            tickets_hash[0]['denunciation_organ_id'] = organ.id
            tickets_hash[0]['denunciation_description'] = 'denunciation description'
            tickets_hash[0]['denunciation_date'] = 'last week'
            tickets_hash[0]['denunciation_place'] = 'street 2'
            tickets_hash[0]['denunciation_witness'] = 'joao'
            tickets_hash[0]['denunciation_evidence'] = 'yes'
            tickets_hash[0]['denunciation_assurance'] = 'rumor'

            expect do
              post(:create, params: { ticket_id: ticket_parent, ticket: ticket_attributes })

              expect(response).to redirect_to(operator_ticket_path(ticket_parent))
              expect(controller).to set_flash
            end.to change(Ticket, :count).by(1)
          end
        end

        it 'accepts empty child ticket' do
          # XXX: O formulário de compartilhamento permite gravar sem adicionar nenhum
          # órgão, e explode com params[:ticket][:ticket_attributes] pois
          # params[:ticket] é nil.
          # Talvez faça mais sentido buildar um ticket filho se o parent_ticket
          # não tiver nenhum ainda.
          post(:create, params: { ticket_id: ticket_parent })

          expect(response).to redirect_to(operator_ticket_path(ticket_parent))
        end

        context 'sou_type' do

          let(:last_ticket) { Ticket.last }

          it 'can modify' do
            expect do
              ticket_attributes[:tickets_attributes][0]["sou_type"] = :request

              post(:create, params: { ticket_id: ticket_parent, ticket: ticket_attributes })

              expect(response).to redirect_to(operator_ticket_path(ticket_parent))
              expect(controller).to set_flash
              expect(last_ticket.request?).to be_truthy

            end.to change(Ticket, :count).by(1)
          end

          it 'change to denunciation_description when denunciation' do
            expect do
              ticket_attributes[:tickets_attributes][0].delete('description')
              ticket_attributes[:tickets_attributes][0]["sou_type"] = :denunciation
              ticket_attributes[:tickets_attributes][0]['denunciation_organ_id'] = organ.id
              ticket_attributes[:tickets_attributes][0]['denunciation_description'] =  'denunciation description'
              ticket_attributes[:tickets_attributes][0]['denunciation_date'] = 'last week'
              ticket_attributes[:tickets_attributes][0]['denunciation_place'] = 'street 2'
              ticket_attributes[:tickets_attributes][0]['denunciation_witness'] = 'joao'
              ticket_attributes[:tickets_attributes][0]['denunciation_evidence'] = 'yes'
              ticket_attributes[:tickets_attributes][0]['denunciation_assurance'] = 'rumor'

              post(:create, params: { ticket_id: ticket_parent, ticket: ticket_attributes })

              expect(response).to redirect_to(operator_ticket_path(ticket_parent))
              expect(controller).to set_flash
              expect(last_ticket.denunciation?).to be_truthy
              expect(last_ticket.description.blank?).to be_truthy

            end.to change(Ticket, :count).by(1)
          end
        end
      end

      context 'invalid' do
        it 'without organ' do
          expect do
            post(:create, params: { ticket_id: ticket_parent, ticket: ticket_invalid_attributes })

            expected_flash = I18n.t('operator.tickets.sharings.create.fail')

            is_expected.to render_template('operator/tickets/sharings/new')
            is_expected.to set_flash.now[:alert].to(expected_flash)

          end.to change(Ticket, :count).by(0)
        end
      end
    end

    context 'authorized as sectoral operator' do

      before { sign_in(sectoral_operator) }

      context 'valid' do

        let(:tickets_hash) do
          result = {}

          # dados do ticket filho existente
          # quando é operador setorial, somente o id do ticket existente vai no POST
          result[0] = {}
          result[0][:id] = ticket_child.id

          # dados do novo ticket
          result[1] = ticket.attributes

          result
        end

        it 'sharing child ticket' do
          expect do
            post(:create, params: { ticket_id: ticket_child, ticket: ticket_attributes })

            expect(response).to redirect_to(operator_ticket_path(ticket_child))
            expect(controller).to set_flash
          end.to change(Ticket, :count).by(1)
        end
      end

    end

  end

  describe '#destroy' do
    let(:ticket) { create(:ticket, :with_parent, :in_sectoral_attendance)}
    let(:ticket_parent) { ticket.parent }

    context 'unauthorized' do
      before { delete(:destroy, params: { ticket_id: ticket.id, id: ticket_parent }) }

      it { is_expected.to redirect_to(new_user_session_path) }
    end

    context 'Operator CGE' do
      let(:user) { create(:user, :operator_cge) }
      before { sign_in(user) }

      let(:service) { Ticket::DeleteSharing.new(ticket.id, user.id) }

      it 'delete' do
        ticket
        service = double
        allow(Ticket::DeleteSharing).to receive(:new).with(ticket.id.to_s, user.id) { service }
        allow(service).to receive(:call).and_return(true)

        delete(:destroy, params: { ticket_id: ticket.id, id: ticket_parent })

        ticket_parent.reload
        expected_flash = I18n.t('operator.tickets.sharings.destroy.done')

        expect(response).to redirect_to(new_operator_ticket_sharing_path(ticket_parent))
        expect(controller).to set_flash.to(expected_flash)
        expect(Ticket::DeleteSharing).to have_received(:new).with(ticket.id.to_s, user.id)
        expect(service).to have_received(:call)
      end

      it 'fail delete' do
        ticket
        service = double
        allow(Ticket::DeleteSharing).to receive(:new).with(ticket.id.to_s, user.id) { service }
        allow(service).to receive(:call).and_return(false)

        delete(:destroy, params: { ticket_id: ticket.id, id: ticket_parent })

        ticket_parent.reload
        expected_flash = I18n.t('operator.tickets.sharings.destroy.fail')

        expect(response).to redirect_to(new_operator_ticket_sharing_path(ticket_parent))
        expect(controller).to set_flash.to(expected_flash)
        expect(Ticket::DeleteSharing).to have_received(:new).with(ticket.id.to_s, user.id)
        expect(service).to have_received(:call)
      end
    end
  end
end
