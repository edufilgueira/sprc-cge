require 'rails_helper'

describe ExtensionsHelper do

  describe 'extension_class' do
    let(:extension) { build(:extension) }

    it 'in_progress' do
      expect(extension_class('in_progress')).to eq('alert-info')
    end

    it 'rejected' do
      expect(extension_class('rejected')).to eq('alert-danger')
    end

    it 'approved' do
      expect(extension_class('approved')).to eq('alert-success')
    end

    it 'cancelled' do
      expect(extension_class('cancelled')).to eq('alert-warning')
    end
  end

  it 'extension_request_for_select' do
    expected = [
      [Extension.human_attribute_name("status.approved"), 'approved'],
      [Extension.human_attribute_name("status.rejected"), 'rejected']
    ]

    expect(extension_request_for_select).to eq(expected)
  end

  it 'extension_operator_path' do
    ticket = create(:ticket)
    extension = create(:extension, ticket: ticket)
    path = new_operator_ticket_extensions_organ_path(ticket)
    expect(extension_operator_path(ticket)).to eq(path)
  end

  describe '#extension_operator_cancel_path' do
    context 'when extension is in progress' do
      it 'return link to cancel first prorrogation' do
        ticket = create(:ticket, :with_parent)
        extension = create(:extension, :in_progress, ticket: ticket)
        path = operator_ticket_extensions_organ_path(ticket, extension)
        expect(extension_operator_cancel_path(ticket)).to eq(path)
      end
    end

    context 'when second extension is in progress' do
      it 'return link to cancel second prorrogation' do
        ticket = create(:ticket, :with_extension)
        extension = create(:extension, :in_progress, :second, ticket: ticket)
        path = operator_ticket_extensions_organ_path(ticket, extension)
        expect(extension_operator_cancel_path(ticket)).to eq(path)
      end
    end
  end

end
