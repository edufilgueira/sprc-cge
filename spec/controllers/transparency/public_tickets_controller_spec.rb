require 'rails_helper'

describe Transparency::PublicTicketsController do

  let(:user) { create(:user, :user) }

  let(:ticket) { create(:ticket, :public_ticket) }

  let(:resources) do
    ticket

    create_list(:ticket, 1, :public_ticket) + [ticket]
  end

  it_behaves_like 'controllers/transparency/public_tickets/index' do

    it_behaves_like 'controllers/transparency/public_tickets/index/xhr'
    it_behaves_like 'controllers/base/index/paginated'
    it_behaves_like 'controllers/base/index/search'


    it_behaves_like 'controllers/base/index/sorted' do
      let(:sort_columns) do
        {
          updated_at: 'tickets.updated_at',
          parent_protocol: 'tickets.parent_protocol',
          sou_type: 'tickets.sou_type',
          internal_status: 'tickets.internal_status',
          deadline: 'tickets.deadline'
        }
      end

      let(:first_unsorted) do
        create(:ticket, :public_ticket, updated_at: 1.day.ago)
      end

      let(:last_unsorted) do
        create(:ticket, :public_ticket, updated_at: Date.today)
      end
    end

    context 'helpers' do
      before { sign_in(user) }

      context 'readonly?' do
        it { expect(controller.readonly?).to be_truthy }
      end
    end

    context 'scope' do
      let(:public_ticket) { create(:ticket, :sic, :confirmed, public_ticket: true) }
      let(:public_child) { create(:ticket, :sic, :confirmed, :with_parent, :public_ticket, parent: public_ticket) }

      let(:not_public_ticket) { create(:ticket, :sic, :confirmed, public_ticket: false) }
      let(:not_public_child) { create(:ticket, :sic, :confirmed, :with_parent, parent: not_public_ticket) }

      before do
        not_public_child
        public_child
      end

      it { expect(controller.tickets).to eq([public_ticket]) }
    end

    context 'search' do
      it 'description' do
        filtered = create(:ticket, :public_ticket, description: 'filtered')
        ticket

        get(:index, params: { search: 'filTer' })

        expect(controller.tickets).to eq([filtered])
      end
    end

    context 'ticket_type' do
      let(:sic) { create(:ticket, :public_ticket, :sic) }

      before do
        sic
      end

      context 'sic' do
        before { get(:index, params: { ticket_type: :sic }) }

        it { expect(controller.tickets).to eq([sic]) }
      end

      context 'default' do
        before { get(:index, params: { ticket_type: nil }) }

        it { expect(controller.tickets).to eq([sic]) }
      end
    end

    context 'filter' do
      context 'organ' do
        let(:organ) { create(:executive_organ) }
        let(:ticket_parent) { create(:ticket, :public_ticket) }
        let(:ticket_with_organ) { create(:ticket, :sic, :with_parent, organ: organ, parent: ticket_parent)}

        let(:other_ticket_parent) { create(:ticket, :public_ticket) }
        let(:other_ticket_with_organ) { create(:ticket, :sic, :with_parent, parent: other_ticket_parent)}

        before do
          other_ticket_with_organ
          ticket_with_organ

          get(:index, params: { organ: organ })
        end

        it { expect(controller.tickets).to eq([ticket_parent]) }
      end

      context 'topic' do
        let(:ticket) { create(:ticket, :public_ticket) }
        let(:child) { create(:ticket, :sic, :with_parent, parent: ticket)}
        let(:topic) { create(:topic) }

        before do
          create(:ticket, :public_ticket)
          create(:classification, topic: topic, ticket: child)

          get(:index, params: { topic: topic })
        end

        it { expect(controller.tickets).to eq([ticket]) }
      end

      it 'theme' do
        other_parent = create(:ticket, :public_ticket)
        parent = create(:ticket, :public_ticket)
        child = create(:ticket, :sic, :with_parent, parent: parent)
        theme = create(:theme)
        budget_program = create(:budget_program, theme: theme)
        classification = create(:classification, budget_program: budget_program, ticket: child)

        get(:index, params: { theme: theme })

        expect(controller.tickets).to eq([parent])
      end

      #
      # Escondendo sou público
      #
      # context 'sou_type' do
      #   let(:ticket_complaint) { create(:ticket, :public_ticket, sou_type: :complaint) }
      #   let(:ticket_request) { create(:ticket, :public_ticket, sou_type: :request) }

      #   before do
      #     ticket_request

      #     get(:index, params: { sou_type: :complaint })
      #   end

      #   it { expect(controller.tickets).to eq([ticket_complaint]) }
      # end
    end
  end

  describe '#show' do

    context 'unauthorized' do
      it_behaves_like 'controllers/base/show'

      it 'do not render like form' do
        get(:show, params: { id: ticket.id })

        is_expected.not_to render_template('transparency/public_tickets/likes/_form')
      end

      it 'ticket is not public' do
        not_public_ticket = create(:ticket, :sic, :confirmed, public_ticket: false)

        get(:show, params: { id: not_public_ticket.id })
        is_expected.to respond_with :forbidden

      end

      it 'ticket is public' do
        get(:show, params: { id: ticket.id })
        is_expected.to respond_with :success
      end

      it 'ticket is public and denunciation' do
        ticket.update_attribute(:sou_type, :denunciation)

        get(:show, params: { id: ticket.id })
        is_expected.to respond_with :forbidden
      end
    end

    context 'authorized' do
      before { sign_in(user) }

      # AO ENTRAR LOGADO O SISTEMA BUGA E FAZ TICKET.ALL
      # ADICIONADO TESTE OBRIGANDO A DESLOGAR USUÁRIO.
      # ESTA É UMA SOLUÇÃO DE CONTORNO PARA O BUG

      render_views

      it 'logout registered users' do

        get(:show, params: { id: ticket.id })

        is_expected.to respond_with(:success)
        expect(controller.user_signed_in?).to eq(false)

      end




      # it 'render like form' do
      #   get(:show, params: { id: ticket.id })

      #   is_expected.to render_template('transparency/public_tickets/likes/_form')
      # end

      # context 'helper methods' do

      #   context 'ticket_like' do
      #     it 'new record' do
      #       get(:show, params: { id: ticket.id })

      #       expect(controller.ticket_like).to be_new_record
      #       expect(controller.ticket_like.ticket).to eq(ticket)
      #       expect(controller.ticket_like.user).to eq(user)
      #     end

      #     it 'existent' do
      #       ticket_like = create(:ticket_like, ticket: ticket, user: user)

      #       get(:show, params: { id: ticket.id })

      #       expect(controller.ticket_like).to eq(ticket_like)
      #     end
      #   end

      #   context 'ticket_subscription' do
      #     it 'new record' do
      #       get(:show, params: { id: ticket.id })

      #       expect(controller.ticket_subscription).to be_new_record
      #       expect(controller.ticket_subscription.ticket).to eq(ticket)
      #       expect(controller.ticket_subscription.user).to eq(user)
      #     end

      #     it 'existent' do
      #       ticket_subscription = create(:ticket_subscription, ticket: ticket, user: user)

      #       get(:show, params: { id: ticket.id })

      #       expect(controller.ticket_subscription).to eq(ticket_subscription)
      #     end
      #   end
      # end
    end



  end
end
