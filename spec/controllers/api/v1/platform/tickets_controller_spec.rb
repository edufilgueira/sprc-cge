require 'rails_helper'

describe Api::V1::Platform::TicketsController do
  include ResponseSpecHelper

  let(:user) { create(:user, :user) }

  let(:ticket) { create(:ticket, :confirmed, created_by: user) }
  let(:ticket_sic) { create(:ticket, :confirmed, created_by: user, ticket_type: :sic) }
  let(:confirmed_ticket) { create(:ticket, :confirmed, created_by: user)}
  let(:in_progress_ticket) { create(:ticket, :in_progress, created_by: user)}

  let(:permitted_params) do
    [
      :name,
      :email,
      :description,
      :sou_type,
      :organ_id,
      :unknown_organ,
      :status,

      :answer_type,
      :answer_phone,
      :answer_cell_phone,

      :city_id,
      :answer_address_street,
      :answer_address_number,
      :answer_address_zipcode,
      :answer_address_complement,

      attachments_attributes: [
        :id, :document, :_destroy
      ]
    ]
  end

  describe '#index' do
    context 'unauthorized' do
      before { get(:index) }

      it { is_expected.to respond_with(:unauthorized) }
    end

    context 'authorized' do
      before { sign_in(user) && get(:index, params: { ticket_type: :sou }) }

      it { is_expected.to respond_with(:success) } # http status 200

      context 'when ticket_type is not defined or invalid' do

        before do
          ticket
          ticket_sic
        end

        it 'defaults ticket_type param to :sou when empty' do
          get(:index)

          expect(json.size).to eq 1
          expect(controller.ticket.ticket_type).to eq 'sou'
        end

        it 'defaults ticket_type param to :sou when invalid' do
          get(:index, params: { ticket_type: :nao_existe })

          expect(json.size).to eq 1
          expect(controller.ticket.ticket_type).to eq 'sou'
        end
      end

      describe 'helpers' do
        describe 'tickets' do
          describe 'filters for current user' do
            # apenas tickets do usuário corrente.

            let(:another_user) { create(:user) }
            let(:another_user_ticket) { create(:ticket, created_by: another_user) }

            before do
              ticket
              another_user_ticket
              get(:index)
            end

            it { expect(json.size).to eq 1 }
            it { expect(json[0]['created_by']).not_to eq another_user }

          end

          describe 'ticket_type' do

            before do
              ticket
              ticket_sic
            end

            context 'sou ticket_type' do
              before { get(:index, params: { ticket_type: :sou }) }

              it { expect(json.first['ticket_type']).to eq 'sou' }
            end

            context 'sic ticket_type' do
              before { get(:index, params: { ticket_type: :sic }) }

              it { expect(json.first['ticket_type']).to eq 'sic' }
            end

          end

          describe 'organ' do

            let(:organ) { create(:executive_organ) }
            let(:ticket_with_organ) { create(:ticket, :with_parent, organ: organ)}
            let(:ticket_parent) do
              parent = ticket_with_organ.parent
              parent.created_by = user
              parent.save!
              parent
            end

            before do
              ticket_parent
              confirmed_ticket
              get(:index, params: { organ: organ })
            end

            it { expect(json.size).to eq 1 }

          end

          it 'sorted' do
            expect(Ticket).to receive(:sorted).and_call_original

            get(:index)

            # para poder chamar o sorted que estamos testando
            controller.tickets
          end

        end

      end

      describe 'pagination' do
        it 'calls kaminari methods' do
          allow(Ticket).to receive(:page).and_call_original
          expect(Ticket).to receive(:page).and_call_original

          get(:index)

          # para poder chamar o page que estamos testando
          controller.tickets
        end
      end


      describe 'search' do
        describe 'parent_protocol' do

          before do
            ticket.reload
            another_ticket = create(:ticket)

            get(:index, params: { search: ticket.parent_protocol })
          end

          it { expect(json.size).to eq 1 }
        end

        # os testes de search do model devem ser feitos direto em seu 'search'
        # -> spec/models/ticket/search_spec.rb
      end
    end
  end

  describe '#create'  do

    let(:valid_ticket) { build(:ticket).attributes }
    let(:invalid_ticket) { build(:ticket, :invalid).attributes }

    let(:created_ticket) { Ticket.last }

    context 'unauthorized' do
      before { post(:create, params: { ticket: valid_ticket }) }

      it { is_expected.to respond_with(:unauthorized) }
    end

    context 'authorized' do

      before { sign_in(user) }

      it 'permits ticket params' do
        # XXX: params: params: pois o shoulda_matchers está usando partes
        # deprecated!
        is_expected.to permit(*permitted_params).
          for(:create, params: { params: valid_ticket } )
      end

      context 'valid' do
        it 'saves unknown_organ' do
          ticket = build(:ticket, ticket_type: :sou)
          expect do
            post(:create, params: ticket.attributes)

            is_expected.to respond_with(:created)

            # deve mostrar numero protocolo no json de retorno
            expect(json['parent_protocol'].to_s).not_to be_empty
            expect(json['status'].to_s).to eq('confirmed')
            expect(json['internal_status'].to_s).to eq('waiting_referral')
            expect(Ticket.find(json['id']).child?).to be_falsey
            expect(controller.ticket.deadline).not_to be_nil
            expect(controller.ticket.confirmed_at).not_to be_nil

          end.to change(Ticket, :count).by(1)
        end

        it 'saves with organ' do
          ticket = build(:ticket, :with_organ)
          expect do
            post(:create, params: ticket.attributes)

            is_expected.to respond_with(:created)

            expect(Ticket.find(json['id']).child?).to be_falsey
            expect(json['internal_status'].to_s).to eq('sectoral_attendance')

          # deve criar pai e filho quando existe órgão
          end.to change(Ticket, :count).by(2)
        end

        it 'saves current_user.name in ticket.name' do
          ticket = build(:ticket).attributes
          post(:create, params: ticket)

          created = controller.ticket

          expect(created.name).to eq(user.name)
          expect(created.email).to eq(user.email)
        end

        context 'saves with attachment' do
          let(:tempfile) do
            file = Tempfile.new("test.png", Rails.root + "spec/fixtures")
            file.write('1')
            file.close
            file.open
            file
          end

          let(:attachment) { Rack::Test::UploadedFile.new(tempfile, "image/png") }

          let(:ticket_with_attachment) do
            valid_ticket[:attachments_attributes] = {
              "1": {
                "document": attachment
              }
            }
            valid_ticket
          end

          before { post(:create, params: ticket_with_attachment) }

          it { expect(controller.ticket.attachments.count).to eq(1) }
        end
      end

      context 'invalid' do

        it 'does not save' do
          expect do
            post(:create, params: { ticket_type: :sou, ticket: invalid_ticket })

          end.to change(Ticket, :count).by(0)
        end

        context 'preserves ticket_type after validation errors' do
          it 'sou ticket_type' do

            post(:create, params: { ticket_type: :sou, ticket: invalid_ticket })

            expect(controller.ticket).to be_sou
          end

          it 'sic ticket_type' do
            post(:create, params: { ticket_type: :sic, ticket: invalid_ticket })

            expect(controller.ticket).to be_sic
          end
        end
      end

      describe 'helpers' do
        it 'ticket' do
          expect(controller.ticket).to be_new_record
        end
      end

      describe 'register_ticket_log' do
        it 'is called on confirmation' do
          allow(RegisterTicketLog).to receive(:call)

          post(:create, params: ticket.attributes)
          ticket = controller.ticket
          expect(RegisterTicketLog).to have_received(:call).with(ticket, user, :confirm, {})
        end
      end

      describe 'notify' do
        it 'is called on confirmation' do
          service = double
          allow(Notifier::NewTicket).to receive(:delay) { service }
          allow(service).to receive(:call)

          post(:create, params: ticket.attributes)
          ticket = controller.ticket
          expect(service).to have_received(:call).with(ticket.id)
        end
      end
    end
  end

  describe '#show' do
    context 'unauthenticated' do
      before { get(:show, params: { id: ticket }) }

      it { is_expected.to respond_with(:unauthorized) }
    end

    context 'authenticated' do
      before { sign_in(user) }

      describe 'response' do

        context 'confirmed' do
          before { get(:show, params: { id: confirmed_ticket }) }

          it { is_expected.to respond_with(:success) }

        end

        context 'unconfirmed' do
          before { get(:show, params: { id: in_progress_ticket }) }

          it { is_expected.to respond_with(:success) }
        end
      end

      describe 'not found' do
        before { get(:show, params: { id: 'not_found' }) }

        it { is_expected.to respond_with(:not_found) }
      end

      describe 'helpers' do
        it 'ticket' do
          get(:show, params: { id: ticket })

          expect(controller.ticket).to eq(ticket)
        end

        it 'new_comment' do
          get(:show, params: { id: ticket })

          expect(controller.new_comment).to be_present
          expect(controller.new_comment.commentable).to eq(ticket)
        end
      end
    end

    context 'authenticated with another user' do
      let(:another_user) { create(:user, :user) }

      it 'access denied' do
        sign_in(another_user)

        expect{ get :show, params: { id: ticket} }.to raise_error(CanCan::AccessDenied)
      end
    end
  end

  describe '#update' do
    let(:valid_ticket) { ticket }
    let(:valid_ticket_attributes) { valid_ticket.attributes }

    context 'unauthorized' do
      before { patch(:update, params: valid_ticket_attributes) }

      it { is_expected.to respond_with(:unauthorized) }
    end

    context 'authorized' do
      before { sign_in(user) }

      context 'valid' do
        it 'AccessDenied' do
          expect { patch(:update, params: valid_ticket_attributes) }.to raise_error(CanCan::AccessDenied)
        end
      end
    end
  end

end
