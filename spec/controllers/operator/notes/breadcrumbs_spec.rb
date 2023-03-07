require 'rails_helper'

describe Operator::NotesController do

  let(:user) { create(:user, :operator) }
  let(:ticket) { create(:ticket, created_by: user) }

  describe 'edit' do
    before { sign_in(user) && ticket.reload && get(:edit, params: { id: ticket }) }

    it 'breadcrumbs' do
      expected = [
        { title: I18n.t('operator.home.index.title'), url: operator_root_path },
        { title: I18n.t('operator.notes.edit.title'), url: '' }
      ]

      expect(controller.breadcrumbs).to eq(expected)
    end
  end
end
