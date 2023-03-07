require 'rails_helper'

describe NotesHelper do

  context 'notes_link_to' do
    let(:namespace) { 'operator' }

    context 'comes from call_center_ticket' do
      let(:ticket_call_center) { create(:ticket, :replied, :call_center) }
      let(:expected) { send("edit_#{namespace}_note_path", ticket_call_center) + '&from=call_center_ticket' }

      before do
        allow_any_instance_of(ActionController::TestRequest).to receive(:referrer) do
          operator_call_center_ticket_path(id: ticket_call_center)
        end
      end

      it { expect(notes_link_to(namespace, ticket_call_center)).to eq(expected) }
    end

    context 'default' do
      let(:ticket) { create(:ticket, :confirmed) }
      let(:expected) { send("edit_#{namespace}_note_path", ticket) }

      before do
        allow_any_instance_of(ActionController::TestRequest).to receive(:referrer) do
          operator_ticket_path(ticket)
        end
      end

      it { expect(notes_link_to(namespace, ticket)).to eq(expected) }
    end
  end
end
