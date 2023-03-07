require 'rails_helper'

describe TicketArea::SessionsController do

  before { @request.env['devise.mapping'] = Devise.mappings[:ticket] }

  # garante que o controller tá incluíndo seu breadcrumb
  it { is_expected.to be_kind_of(TicketArea::SessionsBreadcrumbs) }

  context 'template' do
    render_views

    it 'renders session layout and new template' do
      get :new
      is_expected.to render_template('sessions/new')
      is_expected.to render_template('sessions/_form')
    end
  end

  context 'login' do
    let(:ticket) { create(:ticket) }

    before { sign_in(ticket) }

    it 'redirects on signed out' do
      delete(:destroy)

      expected_flash = I18n.t('devise.sessions.ticket.signed_out')

      is_expected.to set_flash.to(expected_flash)
      is_expected.to redirect_to(new_ticket_session_path)
    end
  end

  it_behaves_like 'controllers/base/single_authentication_guard' do
    let(:resource) { create(:ticket) }
  end
end
