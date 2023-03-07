require 'rails_helper'

describe Platform::TicketsController do

  let(:user) { create(:user, :user_facebook) }

  let(:ticket) { create(:ticket, :confirmed, created_by: user) }
  let(:confirmed_ticket) { create(:ticket, :confirmed, created_by: user)}
  let(:replied_ticket) { create(:ticket, :replied, created_by: user)}

  # O helper organs é usado e exige aluns orgaos padrões
  let(:cosco) { create(:executive_organ, :cosco) } 
  let(:couvi) { create(:executive_organ, :couvi) } 

  let(:permitted_params) do
    [
      :name,
      :email,
      :social_name,
      :gender,
      :description,
      :sou_type,
      :organ_id,
      :unknown_organ,
      :status,
      :used_input,
      :public_ticket,

      :answer_type,
      :answer_phone,
      :answer_cell_phone,

      :city_id,
      :answer_address_street,
      :answer_address_number,
      :answer_address_zipcode,
      :answer_address_complement,
      :answer_twitter,
      :answer_facebook,
      :answer_instagram,

      :document_type,
      :document,
      :person_type,

      :anonymous,

      :target_address_zipcode,
      :target_city_id,
      :target_address_street,
      :target_address_number,
      :target_address_neighborhood,
      :target_address_complement,

      attachments_attributes: [
        :id, :document, :_destroy
      ]
    ]
  end

  describe '#index' do
    before { 
      cosco
      couvi
    }

    context 'unauthorized' do
      before { get(:index) }

      it { is_expected.to redirect_to(new_user_session_path) }
    end

    context 'authorized' do
      before { sign_in(user) && get(:index, params: { ticket_type: :sou }) }

      context 'template' do
        render_views

        it { is_expected.to respond_with(:success) }
      end

      context 'when ticket_type is not defined or invalid' do
        # como esse controller cuida de dois tipos de tickets (sou e sic) e
        # isso é usado em diversas partes, como definir o título das páginas e
        # dos breadcrumbs por ex., precisamos garantir que o valor desse
        # parâmetro esteja definido.

        it 'defaults ticket_type param to :sou when empty' do
          get(:index)

          expect(controller.ticket_type).to eq('sou')
        end

        it 'defaults ticket_type param to :sou when invalid' do
          get(:index, params: { ticket_type: :nao_existe })

          expect(controller.ticket_type).to eq('sou')
        end
      end

      describe 'helpers' do
        describe 'tickets' do
          it 'filters for current user' do
            # apenas tickets do usuário corrente.

            user_ticket = ticket
            another_user_ticket = create(:ticket, created_by: create(:user))

            expect(controller.tickets).to eq([user_ticket])
          end

          it 'filters ticket_type' do
            sou_ticket = create(:ticket, :confirmed, ticket_type: :sou, created_by: user)
            another_type_ticket = create(:ticket, :confirmed, ticket_type: :sic, created_by: user)

            # apenas tickets do tipo corrente.
            get(:index, params: { ticket_type: :sou })
            expect(controller.tickets).to eq([sou_ticket])
          end

          it 'sorted' do
            expect(Ticket).to receive(:sorted).and_call_original

            get(:index)

            # para poder chamar o sorted que estamos testando
            controller.tickets
          end
        end

        describe 'title' do
          it 'sou ticket_type' do
            get(:index, params: { ticket_type: :sou })

            expect(controller.title).to eq(I18n.t('platform.tickets.index.sou.title'))
          end

          it 'sic ticket_type' do
            get(:index, params: { ticket_type: :sic })

            expect(controller.title).to eq(I18n.t('platform.tickets.index.sic.title'))
          end
        end

        context 'readonly?' do
          it { expect(controller.readonly?).to be_falsey }
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

      describe 'filter' do
        context 'status_for_citizen' do
          let(:ticket_inactive) { create(:ticket, internal_status: :final_answer, created_by: user) }
          let(:ticket_active) { create(:ticket, internal_status: :sectoral_attendance, created_by: user) }

          before do
            ticket_inactive
            ticket_active
          end

          it 'actives' do
            get(:index, params: { status_for_citizen: :active })

            expect(controller.tickets).to eq([ticket_active])
          end

          it 'inactive' do
            get(:index, params: { status_for_citizen: :inactive })

            expect(controller.tickets).to eq([ticket_inactive])
          end

          it 'invalid' do
            get(:index, params: { status_for_citizen: 'term_invalid' })

            expect(controller.tickets).to eq([ticket_active])
          end
        end

        context 'organ' do

          let(:organ) { create(:executive_organ) }
          let(:ticket_with_organ) { create(:ticket, :with_parent, organ: organ)}
          let(:ticket_parent) do
            parent = ticket_with_organ.parent
            parent.created_by = user
            parent.save!
            parent
          end

          before do
            confirmed_ticket
            get(:index, params: { organ: organ })
          end

          it { expect(controller.tickets).to eq([ticket_parent]) }
          it { expect(controller.tickets).not_to eq([ticket_with_organ]) }
        end

        it 'finalized' do
          confirmed_ticket
          replied_ticket

          get(:index)

          expect(controller.tickets).to eq([replied_ticket, confirmed_ticket])
        end

        context 'deadline' do
          it 'not_expired' do
            not_expired_ticket = create(:ticket, :confirmed, deadline: 2, created_by: user)
            expired_ticket = create(:ticket, :confirmed, deadline: -1, created_by: user)

            get(:index, params: { deadline: :not_expired })

            expect(controller.tickets).to eq([not_expired_ticket])
          end

          it 'expired_can_extend' do
            not_expired_ticket = create(:ticket, :confirmed, deadline: 2, created_by: user)

            ticket_days = Ticket::LIMIT_TO_EXTEND_DEADLINE - 1
            in_limit = DateTime.now - ticket_days.days
            expired_can_extend_ticket = create(:ticket, :confirmed, deadline: Ticket::SOU_DEADLINE - ticket_days , confirmed_at: in_limit, created_by: user)

            get(:index, params: { deadline: :expired_can_extend })

            expect(controller.tickets).to eq([expired_can_extend_ticket])
          end

          it 'expired' do
            create(:ticket, :replied, created_by: user)
            create(:ticket, :replied, deadline: Ticket::LIMIT_TO_EXTEND_DEADLINE )

            expired_ticket = create(:ticket, :confirmed, deadline: -1, created_by: user )

            get(:index, params: { deadline: :expired })

            expect(controller.tickets).to match_array([expired_ticket])
          end
        end

        it 'topic' do
          ticket_classification_topic = create(:ticket, :confirmed, created_by: user)
          topic = create(:topic)
          create(:classification, topic: topic, ticket: ticket_classification_topic)

          get(:index, params: { topic: topic })

          expect(controller.tickets).to eq([ticket_classification_topic])
        end
      end

      describe 'search' do
        it 'protocol' do
          ticket.reload
          another_ticket = create(:ticket, :confirmed)

          get(:index, params: { search: ticket.parent_protocol })

          expect(controller.tickets).to eq([ticket])
        end

        # os testes de search do model devem ser feitos direto em seu 'search'
        # -> spec/models/ticket/search_spec.rb
      end

      describe '#sort' do

        it 'sou sort_columns helper' do
          get(:index, params: { ticket_type: :sou })

          expected = [
            'tickets.created_at',
            'tickets.updated_at',
            'tickets.parent_protocol',
            'tickets.sou_type',
            'tickets.internal_status',
            'tickets.deadline'
          ]

          expect(controller.sort_columns).to eq(expected)
        end

        it 'sic sort_columns helper' do
          get(:index, params: { ticket_type: :sic })

          expected = [
            'tickets.created_at',
            'tickets.updated_at',
            'tickets.parent_protocol',
            'tickets.internal_status',
            'tickets.deadline'
          ]

          expect(controller.sort_columns).to eq(expected)
        end

        it 'default' do
          first_unsorted = create(:ticket, :confirmed, created_by: user, updated_at: 1.day.ago)
          last_unsorted = create(:ticket, :confirmed, created_by: user, updated_at: Date.today)

          get(:index)

          expect(controller.tickets).to eq([last_unsorted, first_unsorted])
        end

        it 'sort_column param' do
          get(:index, params: { sort_column: 'tickets.parent_protocol'})

          join = user.tickets.parent_tickets
          sorted = join.sorted('tickets.parent_protocol', :desc)
          filtered = sorted.sou
          paginated = filtered.page(controller.params[:page]).per(controller.class::PER_PAGE)
          expected = paginated.to_sql

          result = controller.tickets.to_sql

          expect(result).to eq(expected)
        end

        it 'sort_direction param' do
          get(:index, params: { sort_column: 'tickets.parent_protocol', sort_direction: :desc })

          join = user.tickets.parent_tickets
          sorted = join.sorted('tickets.parent_protocol', 'desc')
          filtered = sorted.sou
          paginated = filtered.page(controller.params[:page]).per(controller.class::PER_PAGE)
          expected = paginated.to_sql

          result = controller.tickets.to_sql

          expect(result).to eq(expected)
        end
      end

      context 'scope' do
        let(:ticket) { create(:ticket, :confirmed, created_by: user) }
        let(:child) { create(:ticket, :with_parent, created_by: user, parent: ticket) }

        before { child }

        it { expect(controller.tickets).to eq([ticket]) }
      end
    end
  end

  describe '#new' do

     before { 
      cosco
      couvi
    }

    context 'unauthorized' do
      before { get(:new) }

      it { is_expected.to redirect_to(new_user_session_path) }
    end

    context 'authorized' do
      before { sign_in(user) && get(:new, params: { ticket_type: :sou }) }

      context 'template' do
        render_views

        it { is_expected.to respond_with(:success) }
        it { is_expected.to render_template('platform/tickets/new') }
        it { is_expected.to render_template('platform/tickets/_form') }
      end

      describe 'helpers' do
        it 'ticket' do
          expect(controller.ticket).to be_new_record
        end

        it 'ticket default sou_type' do
          expect(controller.ticket.sou_type).to be_nil
        end

        context 'ticket_type based on params' do
          it 'sou ticket_type' do
            get(:new, params: { ticket_type: :sou })
            expect(controller.ticket).to be_sou
          end

          it 'sic ticket_type' do
            get(:new, params: { ticket_type: :sic })
            expect(controller.ticket).to be_sic
          end
        end
      end

      context 'default fields' do
        context 'ticket.email' do
          it { expect(controller.ticket.email).to eq(user.email) }
        end
      end

      context 'default fields' do
        context 'ticket.facebook_profile_link' do
          it { expect(controller.ticket.answer_facebook).to eq(user.facebook_profile_link) }
        end
      end
    end
  end

  describe '#create'  do
    before { 
      cosco
      couvi
    }

    let(:valid_ticket) { build(:ticket).attributes }
    let(:invalid_ticket) { build(:ticket, :invalid).attributes }
    let(:ticket_denunciation) { build(:ticket, :denunciation).attributes }
    let(:created_ticket) { Ticket.last }
    let(:parent_ticket) { created_ticket.parent }
    let(:organ) { create(:executive_organ) }

    context 'unauthorized' do
      before { post(:create, params: { ticket: valid_ticket }) }

      it { is_expected.to redirect_to(new_user_session_path) }
    end

    context 'authorized' do

      before { sign_in(user) }

      it 'permits ticket params' do
        should permit(*permitted_params).for(:create, params: { ticket: valid_ticket })
      end

      context 'valid' do
        it 'saves' do
          ticket = build(:ticket, ticket_type: :sou).attributes
          expect do
            post(:create, params: { ticket: ticket })

            expect(response).to redirect_to(platform_ticket_path(created_ticket))
          end.to change(Ticket, :count).by(1)
        end

        describe 'saves confirmation' do
          # quando o usuário salva o form, precisamos setar o
          # flash 'from_confirmation' para que o show possa exibir
          # a mensagem de sucesso para o usuário.

          let(:confirmed_at) { Date.today }

          context 'unknown organ' do
            before { post(:create, params: { ticket: valid_ticket }) }

            # o flash é usado para exibir a mensagem específica avisando ao usuário
            # que sua manifestação foi recebida!

            it { expect(controller).to set_flash[:from_confirmation].to(true) }
            it { expect(response).to redirect_to(platform_ticket_path(created_ticket)) }

            it { expect(created_ticket).to be_confirmed }
            it { expect(created_ticket).to be_waiting_referral }
            it { expect(created_ticket.confirmed_at.to_date).to eq(confirmed_at) }
            it { expect(created_ticket.parent_unknown_organ).to be_truthy }
          end

          context 'knowledge organ' do

            before do
              allow(RegisterTicketLog).to receive(:call)

              valid_ticket["organ_id"] = organ.id
              valid_ticket["unknown_organ"] = false
              post(:create, params: { ticket: valid_ticket })
            end

            it { expect(parent_ticket).to be_confirmed }
            it { expect(parent_ticket).to be_sectoral_attendance }
            it { expect(parent_ticket.confirmed_at.to_date).to eq(confirmed_at) }
            it { expect(parent_ticket.organ_id).to be_nil }
            it { expect(created_ticket).to be_confirmed }
            it { expect(created_ticket).to be_sectoral_attendance }
            it { expect(created_ticket.confirmed_at.to_date).to eq(confirmed_at) }
            it { expect(created_ticket.parent_id).to eq(parent_ticket.id) }
            it { expect(created_ticket.organ).to eq(organ) }
            it { expect(created_ticket.parent_unknown_organ).to be_falsey }

            it 'register ticket log' do
              expect(RegisterTicketLog).to have_received(:call).with(parent_ticket, user, :share, { resource: created_ticket.organ })
            end
          end

          it 'register ticket log' do
            allow(RegisterTicketLog).to receive(:call)

            post(:create, params: { ticket: valid_ticket })

            expect(RegisterTicketLog).to have_received(:call).with(created_ticket, user, :confirm, {})
          end

          context 'set deadline' do
            let(:deadline) { Holiday.next_weekday(Ticket.response_deadline(:sou)) }
            let(:deadline_ends_at) { Date.today + deadline }
            before { post(:create, params: { ticket: valid_ticket }) }

            it { expect(created_ticket.deadline).to eq(deadline) }
            it { expect(created_ticket.deadline_ends_at).to eq(deadline_ends_at) }
          end
        end

        it 'saves current_user.name in ticket.name' do
          ticket = attributes_for(:ticket).except(:document, :document_type)
          post(:create, params: { ticket: ticket })

          created = controller.ticket

          expect(created.name).to eq(user.name)
          expect(created.social_name).to eq(user.social_name)
          expect(created.email).to eq(user.email)
          expect(created.document).to eq(user.document)
          expect(created.document_type).to eq(user.document_type)
          expect(controller.ticket).not_to be_anonymous
          expect(controller.ticket).not_to be_identified
        end

        it 'saves facebook_link in ticket when user logged with facebook and type_anwers is facebook ' do
          ticket = attributes_for(:ticket, :answer_by_facebook)
          ticket[:answer_facebook] = nil

          link_profile = 'https://profile_link.com'
          user.provider = 'facebook'
          user.facebook_profile_link = link_profile
          user.save

          post(:create, params: { ticket: ticket })

          created = controller.ticket

          expect(created.answer_facebook).to eq(link_profile)
        end

        context 'with attachments' do
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

          it 'saves' do
            post(:create, params: { ticket: ticket_with_attachment })

            expect(controller.ticket.attachments.count).to eq(1)
          end

          it 'register ticket_log for attachments' do
            allow(RegisterTicketLog).to receive(:call).with(anything, user, :confirm, anything)
            allow(RegisterTicketLog).to receive(:call).with(anything, user, :create_attachment, anything)

            post(:create, params: { ticket: ticket_with_attachment })

            created_attachment = created_ticket.attachments.first

            expect(RegisterTicketLog).to have_received(:call).with(created_ticket, user, :create_attachment, { resource: created_attachment })
          end
        end

        it 'ticket type denunciation set unknown_organ true' do
          expect do
            post(:create, params: { ticket: ticket_denunciation })

            expect(created_ticket.unknown_organ).to be_truthy
            expect(created_ticket.organ).to be_nil
          end.to change(Ticket, :count).by(1)
        end

        it 'set_deadline for sou' do
          sou_deadline = 15
          deadline_ends_at = Date.today + Holiday.next_weekday(sou_deadline)

          post(:create, params: { ticket: valid_ticket })

          expect(controller.ticket.deadline_ends_at).to eq(deadline_ends_at)
        end

        it 'set_deadline for sic' do
          sic_deadline = 20
          deadline_ends_at = Date.today + Holiday.next_weekday(sic_deadline)

          post(:create, params: { ticket: valid_ticket, ticket_type: :sic })

          expect(controller.ticket.deadline_ends_at).to eq(deadline_ends_at)
        end
      end

      context 'before_validation' do
        it 'saves cnpj' do
          valid_ticket[:person_type] = :legal
          valid_ticket[:document_type] = :cnpj
          post(:create, params: { ticket: valid_ticket })

          expect(controller.ticket.document_type).to eq('cnpj')
        end

        it 'dont saves cnpj' do
          valid_ticket[:person_type] = :individual
          valid_ticket[:document_type] = :other
          post(:create, params: { ticket: valid_ticket })

          expect(controller.ticket.document_type).to eq('other')
        end
      end

      context 'invalid' do
        render_views

        it 'does not save' do
          expect do
            post(:create, params: { ticket_type: :sou, ticket: invalid_ticket })

            expected_flash = I18n.t("platform.tickets.create.sou.error")

            expect(controller).to set_flash.now.to(expected_flash)
            expect(response).to render_template('platform/tickets/new')
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
    end
  end

  describe '#show' do
    context 'unauthenticated' do
      before { get(:show, params: { id: ticket }) }

      it { is_expected.to redirect_to(new_user_session_path) }
    end

    context 'authenticated' do
      let(:service) { double }
      before do
        sign_in(user)
        allow(Notifier::NewTicket).to receive(:delay) { service }
        allow(service).to receive(:call)
      end

      describe 'template' do
        render_views

        context 'confirmed' do
          before { get(:show, params: { id: confirmed_ticket }) }

          it { is_expected.to render_template('platform/tickets/show') }
          it { is_expected.to render_template('shared/tickets/_confirmed') }
          it { is_expected.not_to render_template('shared/tickets/_unconfirmed') }
          it { is_expected.to render_template('shared/tickets/_show') }

          it 'create ticket password' do
            expect(controller.ticket.password).not_to be_empty
          end

          it 'notify' do
            expect(service).to have_received(:call).with(confirmed_ticket.id)
          end
        end

        context 'with password was created' do
          it 'not notify' do
            ticket_with_password = create(:ticket, :confirmed, password: 'pass')

            get(:show, params: { id: ticket_with_password })

            expect(service).not_to have_received(:call).with(ticket_with_password.id)
          end
        end
      end

      describe 'helpers' do

        let(:ticket_child){ create(:ticket, :with_parent, parent: ticket) }

        it 'ticket' do
          get(:show, params: { id: ticket })

          expect(controller.ticket).to eq(ticket)
        end

        it 'new_comment' do
          # criamos um novo comentário pra ser usado no form.

          get(:show, params: { id: ticket })

          expect(controller.new_comment).to be_present
          expect(controller.new_comment.commentable).to eq(ticket)
        end

        describe 'ticket_children' do

          it 'with parent' do
            get(:show, params: { id: ticket })

            expect(controller.ticket_children).to eq(ticket.sorted_tickets)
          end

          it 'with child' do
            get(:show, params: { id: ticket_child })

            expect(controller.ticket_children).to eq(ticket.sorted_tickets)
          end
        end
      end
    end

    context 'error_pages' do
      it 'page not exists' do
        sign_in(user)
        get(:show, params: { id: 123234 })

        is_expected.to respond_with(:not_found) # 404
        is_expected.to render_with_layout('platform')
        is_expected.to render_template('errors/not_found')
      end

      it 'authenticated with another user' do
        another_user = create(:user, :user)
        sign_in(another_user)
        get(:show, params: { id: ticket })

        is_expected.to respond_with(:forbidden) # 403
        is_expected.to render_with_layout('platform')
        is_expected.to render_template('errors/forbidden')
      end
    end
  end

  describe '#edit' do
    context 'unauthorized' do
      before { get(:edit, params: { id: ticket }) }

      it { is_expected.to redirect_to(new_user_session_path) }
    end

    context 'authorized' do
      before { sign_in(user) && get(:edit, params: { id: ticket }) }

      context 'forbidden' do
        render_views

        it { is_expected.to respond_with(:forbidden) }
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
    let(:valid_ticket_params) { { id: ticket, ticket: valid_ticket_attributes } }
    let(:invalid_ticket_params) do
      { id: invalid_ticket, ticket: invalid_ticket.attributes }
    end

    context 'unauthorized' do
      before { patch(:update, params: valid_ticket_params) }

      it { is_expected.to redirect_to(new_user_session_path) }
    end

    context 'authorized' do
      before { sign_in(user) }

      context 'valid' do
        it 'forbidden' do
          valid_ticket_params[:ticket][:name] = 'new name'
          patch(:update, params: valid_ticket_params)

          is_expected.to respond_with(:forbidden)
        end
      end
    end
  end

  describe '#destroy' do
    let(:another_ticket) { create(:ticket, created_by: user) }

    context 'unauthorized' do
      before { delete(:destroy, params: { id: another_ticket }) }

      it { is_expected.to redirect_to(new_user_session_path) }
    end

    context 'authorized' do
      before { sign_in(user) }

      it 'forbidden' do
        another_ticket

        expect do
          delete(:destroy, params: { id: another_ticket })

          is_expected.to respond_with(:forbidden)
        end.to change(Ticket, :count).by(0)
      end
    end
  end

  describe '#history' do
    context 'unauthorized' do
      before { get(:history, params: { id: ticket }) }

      it { is_expected.to redirect_to(new_user_session_path) }
    end

    context 'authorized' do
      render_views
      before { sign_in(user) && get(:history, params: { id: ticket }) }

      it { is_expected.to render_template('shared/tickets/ticket_logs/_history') }

      it { expect(controller.ticket).to eq(ticket) }
    end

  end

end
