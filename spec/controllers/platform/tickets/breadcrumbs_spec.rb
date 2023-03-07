require 'rails_helper'

describe Platform::TicketsController do

  let(:user) { create(:user, :user) }
  let(:ticket) { create(:ticket, created_by: user) }

  describe 'index' do
    context 'sou tickets' do
      before { get(:index, params: { ticket_type: :sou }) }

      it 'breadcrumbs' do
        expected = [
          { title: I18n.t('platform.home.index.title'), url: platform_root_path },
          { title: I18n.t('platform.tickets.index.sou.breadcrumb_title'), url: '' }
        ]

        expect(controller.breadcrumbs).to eq(expected)
      end
    end

    context 'sic tickets' do
      before { get(:index, params: { ticket_type: :sic }) }

      it 'breadcrumbs' do
        expected = [
          { title: I18n.t('platform.home.index.title'), url: platform_root_path },
          { title: I18n.t('platform.tickets.index.sic.breadcrumb_title'), url: '' }
        ]

        expect(controller.breadcrumbs).to eq(expected)
      end
    end
  end

  describe 'new' do
    context 'sou tickets' do
      before { get(:new, params: { ticket_type: :sou }) }

      it 'breadcrumbs' do
        expected = [
          { title: I18n.t('platform.home.index.title'), url: platform_root_path },
          { title: I18n.t('platform.tickets.index.sou.breadcrumb_title'), url: platform_tickets_path(ticket_type: :sou) },
          { title: I18n.t('platform.tickets.new.sou.title'), url: '' }
        ]

        expect(controller.breadcrumbs).to eq(expected)
      end
    end

    context 'sic tickets' do
      before { get(:new, params: { ticket_type: :sic }) }

      it 'breadcrumbs' do
        expected = [
          { title: I18n.t('platform.home.index.title'), url: platform_root_path },
          { title: I18n.t('platform.tickets.index.sic.breadcrumb_title'), url: platform_tickets_path(ticket_type: :sic) },
          { title: I18n.t('platform.tickets.new.sic.title'), url: '' }
        ]

        expect(controller.breadcrumbs).to eq(expected)
      end
    end
  end

  describe 'create' do
    context 'sou tickets' do
      before do
        post(:create, params: { ticket_type: :sou, ticket: { description: '' }})
      end

      it 'breadcrumbs' do
        expected = [
          { title: I18n.t('platform.home.index.title'), url: platform_root_path },
          { title: I18n.t('platform.tickets.index.sou.breadcrumb_title'), url: platform_tickets_path(ticket_type: :sou) },
          { title: I18n.t('platform.tickets.new.sou.title'), url: '' }
        ]

        expect(controller.breadcrumbs).to eq(expected)
      end
    end

    context 'sic tickets' do
      before do
        post(:create, params: { ticket_type: :sic, ticket: { description: '' }})
      end

      it 'breadcrumbs' do
        expected = [
          { title: I18n.t('platform.home.index.title'), url: platform_root_path },
          { title: I18n.t('platform.tickets.index.sic.breadcrumb_title'), url: platform_tickets_path(ticket_type: :sic) },
          { title: I18n.t('platform.tickets.new.sic.title'), url: '' }
        ]

        expect(controller.breadcrumbs).to eq(expected)
      end
    end
  end

  context 'show' do
    let(:confirmed_ticket) { create(:ticket, :confirmed) }

    before { sign_in(user) }

    it 'breadcrumbs' do

      confirmed_ticket.reload
      get(:show, params: { id: confirmed_ticket })

      expected = [
        { title: I18n.t('platform.home.index.title'), url: platform_root_path },
        { title: I18n.t("platform.tickets.index.#{ticket.ticket_type}.breadcrumb_title"), url: platform_tickets_path(ticket_type: confirmed_ticket.ticket_type) },
        { title: confirmed_ticket.title, url: '' }
      ]

      expect(controller.breadcrumbs).to eq(expected)
    end

    context 'unconfirmed breadcrumbs' do
      let(:in_progress_sic_ticket) { create(:ticket, :in_progress, ticket_type: :sic)}
      let(:in_progress_sou_ticket) { create(:ticket, :in_progress, ticket_type: :sou)}

      before { in_progress_sic_ticket.reload }

      it 'sic ticket' do
        get(:show, params: { id: in_progress_sic_ticket })

        expected_ticket_title = I18n.t("platform.tickets.show.in_progress.sic.title")

        expected = [
          { title: I18n.t('platform.home.index.title'), url: platform_root_path },
          { title: I18n.t("platform.tickets.index.#{in_progress_sic_ticket.ticket_type}.breadcrumb_title"), url: platform_tickets_path(ticket_type: in_progress_sic_ticket.ticket_type) },
          { title: expected_ticket_title, url: '' }
        ]

        expect(controller.breadcrumbs).to eq(expected)
      end

      it 'sou ticket' do
        get(:show, params: { id: in_progress_sou_ticket })

        expected_ticket_title = I18n.t("platform.tickets.show.in_progress.sou.title")

        expected = [
          { title: I18n.t('platform.home.index.title'), url: platform_root_path },
          { title: I18n.t("platform.tickets.index.#{in_progress_sou_ticket.ticket_type}.breadcrumb_title"), url: platform_tickets_path(ticket_type: in_progress_sou_ticket.ticket_type) },
          { title: expected_ticket_title, url: '' }
        ]

        expect(controller.breadcrumbs).to eq(expected)
      end
    end
  end

  context 'edit' do
    before { sign_in(user) && ticket.reload && get(:edit, params: { id: ticket }) }

    it 'breadcrumbs' do
      expected = [
        { title: I18n.t('platform.home.index.title'), url: platform_root_path },
        { title: I18n.t("platform.tickets.index.#{ticket.ticket_type}.breadcrumb_title"), url: platform_tickets_path(ticket_type: ticket.ticket_type) },
        { title: ticket.title, url: '' }
      ]

      expect(controller.breadcrumbs).to eq(expected)
    end
  end

  context 'update' do
    let(:invalid_params) { { id: ticket, ticket: attributes_for(:organ, :invalid) } }

    before { sign_in(user) && ticket.reload && patch(:update, params: invalid_params) }

    it 'breadcrumbs' do
      expected = [
        { title: I18n.t('platform.home.index.title'), url: platform_root_path },
        { title: I18n.t("platform.tickets.index.#{ticket.ticket_type}.breadcrumb_title"), url: platform_tickets_path(ticket_type: ticket.ticket_type) },
        { title: ticket.title, url: '' }
      ]

      expect(controller.breadcrumbs).to eq(expected)
    end
  end
end
