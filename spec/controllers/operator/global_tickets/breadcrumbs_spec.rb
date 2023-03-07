require 'rails_helper'

describe Operator::GlobalTicketsController do
  let(:user_sectoral) { create(:user, :operator_sectoral) }
  let(:ticket) { create(:ticket) }

  context 'index' do
    before { sign_in(user_sectoral) && get(:index) }

    context 'sou tickets' do
      before { get(:index) }

      it 'breadcrumbs' do
        expected = [
          { title: I18n.t('operator.home.index.title'), url: operator_root_path },
          { title: I18n.t('operator.global_tickets.index.title'), url: '' }
        ]

        expect(controller.breadcrumbs).to eq(expected)
      end
    end
  end
end
