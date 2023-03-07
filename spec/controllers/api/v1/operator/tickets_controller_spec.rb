require 'rails_helper'

describe Api::V1::Operator::TicketsController do
  include ResponseSpecHelper

  let(:organ) { create(:executive_organ) }
  let(:user) { create(:user, :operator_sectoral, organ: organ) }

  let(:ticket) { create(:ticket, :with_organ, organ: organ, created_by: user) }
  let(:ticket_sic) { create(:ticket, :with_organ, organ: organ, created_by: user, ticket_type: :sic) }
  let(:confirmed_ticket) { create(:ticket, :confirmed, :with_organ, organ: organ, created_by: user)}
  let(:in_progress_ticket) { create(:ticket, :in_progress, :with_organ, organ: organ, created_by: user)}

  let(:permitted_params) do
    [
      :name,
      :social_name,
      :gender,
      :email,
      :description,
      :sou_type,
      :organ_id,
      :unknown_organ,
      :department_id,
      :unknown_department,
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
      ],

      ticket_departments_attributes: [
        :id, :ticket_id, :department_id, :_destroy
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
          expect(Ticket.find(json[0]['id']).ticket_type).to eq 'sou'
        end

        it 'defaults ticket_type param to :sou when invalid' do
          get(:index, params: { ticket_type: :nao_existe })

          expect(json.size).to eq 1
          expect(Ticket.find(json[0]['id']).ticket_type).to eq 'sou'
        end
      end

      describe 'helpers' do
        describe 'tickets' do
          describe 'filters for current user' do
            # apenas tickets do usuário corrente.

            let(:another_user) { create(:user, :operator) }
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

              it { expect(Ticket.find(json[0]['id']).ticket_type).to eq 'sou' }
            end

            context 'sic ticket_type' do
              before { get(:index, params: { ticket_type: :sic }) }

              it { expect(Ticket.find(json[0]['id']).ticket_type).to eq 'sic' }
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
              get(:index)
            end

            it { expect(json.size).to eq 1 }
            it { expect(json.first['id']).to eq(ticket_with_organ.id) }

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
        describe 'protocol' do

          before do
            ticket.reload
            another_ticket = create(:ticket)

            get(:index, params: { search: ticket.parent_protocol })
          end

          it { expect(json.size).to eq 1 }
          it { expect(json[0]['id']).to eq ticket.id }
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
        should permit(*permitted_params).
          for(:create,  params: valid_ticket )
      end

      context 'valid' do
        it 'saves' do
          ticket = build(:ticket)
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
            expect(controller.ticket.parent_unknown_organ).to be_truthy

          end.to change(Ticket, :count).by(1)
        end

        it 'saves with organ' do
          ticket = build(:ticket, :with_organ)
          expect do
            post(:create, params: ticket.attributes)

            is_expected.to respond_with(:created)

            expect(Ticket.find(json['id']).child?).to be_truthy
            expect(Ticket.find(json['id']).parent_unknown_organ).to be_falsey
            expect(json['internal_status'].to_s).to eq('sectoral_attendance')

          # deve criar pai e filho quando existe órgão
          end.to change(Ticket, :count).by(2)
        end

        it 'saves with created_by' do
          ticket = build(:ticket)
          expect do
            post(:create, params: ticket.attributes)

            expect(controller.ticket.created_by).to eq(user)

          end.to change(Ticket, :count).by(1)
        end

        it 'not saves current_user.name in ticket.name' do
          ticket = build(:ticket).attributes
          post(:create, params: ticket)

          created = Ticket.find(json['id'])

          expect(created.name).not_to eq(user.name)
          expect(created.name).to eq(ticket["name"])
          expect(created.email).not_to eq(user.email)
          expect(created.email).to eq(ticket["email"])
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

        context 'authorized' do
          before { get(:show, params: { id: ticket }) }

          it { is_expected.to respond_with(:success) }
        end

        context 'unauthorized parent ticket' do
          let(:ticket) { create(:ticket, :with_parent, organ: organ, created_by: user) }

          it { expect{ get(:show, params: { id: ticket.parent }) }.to raise_error(CanCan::AccessDenied) }
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
      let(:another_user) { create(:user, :operator_sectoral) }

      it 'access denied' do
        sign_in(another_user)

        expect{ get :show, params: { id: ticket} }.to raise_error(CanCan::AccessDenied)
      end
    end
  end

  describe '#update' do
    let(:valid_ticket) { ticket }
    let(:invalid_ticket) do
      ticket = create(:ticket, created_by: user)
      ticket.description = nil
      ticket
    end

    let(:valid_ticket_attributes) { valid_ticket.attributes }
    let(:invalid_ticket_attributes) { invalid_ticket.attributes }

    context 'unauthorized' do
      before { patch(:update, params: valid_ticket_attributes) }

      it { is_expected.to respond_with(:unauthorized) }
    end

    context 'authorized' do
      before { sign_in(user) }

      it 'permits ticket params' do
        should permit(*permitted_params).
          for(:update, params: valid_ticket_attributes )
      end

      context 'valid' do
        it 'saves' do
          valid_ticket_attributes[:name] = 'new name'
          patch(:update, params: valid_ticket_attributes)

          is_expected.to respond_with(:success)

          valid_ticket.reload

          expect(Ticket.find(json['id']).name).to eq('new name')
        end

        it 'saves confirmation' do
          valid_ticket_attributes[:status] = :confirmed
          valid_ticket_attributes[:confirmation] = true

          patch(:update, params: valid_ticket_attributes)

          is_expected.to respond_with(:success)

          valid_ticket.reload

          expect(valid_ticket).to be_confirmed
          expect(Ticket.find(json['id']).status).to eq('confirmed')
        end
      end

      context 'invalid' do

        it 'does not save' do
          patch(:update, params: invalid_ticket_attributes)
        end
      end

      describe 'helpers' do
        it 'ticket' do
          patch(:update, params: valid_ticket_attributes)
          expect(controller.ticket).to eq(valid_ticket)
        end
      end
    end
  end

  describe '#search' do
    context 'unauthorized' do
      before { get(:search, xhr: true) }

      it { is_expected.to respond_with(:unauthorized) }
    end

    context 'authorized' do

      let(:operator) { create(:user, :operator_call_center) }

      before { sign_in(operator) }

      context 'response' do
        before { get(:search, xhr: true) }

        it { is_expected.to respond_with(:success) }
      end

      context 'params' do

        let(:permitted_user_params) {
          [
            :name,
            :social_name,
            :gender,
            :document_type,
            :document,
            :email,
            :answer_phone,
            :answer_cell_phone,
            :city_id,
            :answer_whatsapp,
            :answer_address_street,
            :answer_address_number,
            :answer_address_neighborhood,
            :answer_address_complement,
            :answer_address_zipcode,
            :answer_twitter,
            :answer_facebook,
            :answer_instagram
          ]
        }
        let(:ticket_01) { create(:ticket, :confirmed, :with_city, name: 'User 01', document: CPF.generate(true), person_type: :individual) }
        let(:ticket_02) { create(:ticket, :confirmed, :with_city, name: 'User 02', document: CNPJ.generate(true), person_type: :legal) }
        let(:ticket_03) { create(:ticket, :confirmed, :with_city, name: 'Other', document: CNPJ.generate(true), person_type: :legal) }
        let(:ticket_not_confirmed) { create(:ticket, :with_city, name: 'User 04', document: CPF.generate(true), person_type: :individual) }

        before do
          ticket_not_confirmed
          ticket_03
          ticket_02
          ticket_01
        end

        context 'limits to first 10 results' do
          before do
            11.times { create(:ticket, :confirmed, name: 'User 01') }

            get(:search, xhr: true, params: { name: 'User 01' })
          end

          it { expect(json.size).to eq(10) }
        end

        it 'returns data only from parent ticket' do
          create(:ticket, :with_parent, parent: ticket_01, name: 'User 01', document: CPF.generate(true), person_type: :individual)

          get(:search, xhr: true, params: { name: 'User 01' })

          expected = JSON.parse([ticket_01].to_json(methods: :state_id, only: permitted_user_params))

          expect(json).to eq(expected)
        end

        it 'empty' do
          get(:search, xhr: true, params: {})

          expect(json).to eq([])
        end

        it 'name' do
          get(:search, xhr: true, params: { name: 'R 0' })

          expected = JSON.parse([ticket_01, ticket_02].to_json(methods: :state_id, only: permitted_user_params))

          expect(json).to eq(expected)
        end

        context 'document' do
          it 'return only data from the last ticket' do
            document = CNPJ.generate(true)
            ticket_02_last = create(:ticket, :confirmed, name: 'User 02 last', document: document, person_type: :legal)

            get(:search, xhr: true, params: { document: document })

            expected = JSON.parse(ticket_02_last.to_json(methods: :state_id, only: permitted_user_params))

            expect(json).to eq(expected)
          end
        end

        it 'person_type' do
          get(:search, xhr: true, params: { person_type: 'individual' })

          expected = JSON.parse([ticket_01].to_json(methods: :state_id, only: permitted_user_params))

          expect(json).to eq(expected)
        end
      end
    end
  end
end
