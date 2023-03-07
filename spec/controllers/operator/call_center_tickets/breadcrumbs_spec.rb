require 'rails_helper'

describe Operator::CallCenterTicketsController do

  let(:user) { create(:user, :operator_call_center_supervisor) }
  let(:ticket) { create(:ticket, :replied, :call_center) }

  context 'index' do
    before { sign_in(user) && get(:index) }

    it 'breadcrumbs' do
      expected = [
        { title: I18n.t('operator.home.index.title'), url: operator_root_path },
        { title: I18n.t('operator.call_center_tickets.index.title'), url: '' }
      ]

      expect(controller.breadcrumbs).to eq(expected)
    end
  end

  context 'show' do
    before { sign_in(user) && get(:show, params: { id: ticket }) }

    it 'breadcrumbs' do
      expected = [
        { title: I18n.t('operator.home.index.title'), url: operator_root_path },
        { title: I18n.t('operator.call_center_tickets.index.title'), url: operator_call_center_tickets_path },
        { title: ticket.reload.title, url: '' }
      ]

      expect(controller.breadcrumbs).to eq(expected)
    end
  end
end

