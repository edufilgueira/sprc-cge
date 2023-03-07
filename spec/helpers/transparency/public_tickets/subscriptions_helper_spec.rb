require 'rails_helper'

describe Transparency::PublicTickets::SubscriptionsHelper do

  context 'edit path if ticket_subscription not created' do
    let(:ticket) { create(:ticket, :public_ticket) }

    it 'edit path' do
      user = create(:user, :user)
      ticket_subscription = create(:ticket_subscription, ticket: ticket, user: user)

      expected_path = edit_transparency_public_ticket_subscription_path(ticket, ticket_subscription)

      expect(subscriptions_create_edit_path(ticket, user)).to eq(expected_path)
    end

    it 'new path' do
      ticket_subscription = create(:ticket_subscription, ticket: ticket)

      expected_path = new_transparency_public_ticket_subscription_path(ticket)

      expect(subscriptions_create_edit_path(ticket, nil)).to eq(expected_path)
    end
  end
end
