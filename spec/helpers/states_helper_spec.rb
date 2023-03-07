require 'rails_helper'

describe StatesHelper do

  let!(:state) { create(:state) }

  it 'states_for_select' do
    states = State.sorted

    expected = states.map do |state|
      [ state.acronym, state.id ]
    end

    expect(states_for_select).to eq(expected)
  end

  context 'states_default_selected_for_ticket' do
    let(:default_state) { create(:state, :default) }
    let(:user_city) { create(:city) }
    let(:user_state) { user_city.state }
    let(:user) { create(:user, city: user_city) }

    let(:ticket_city) { create(:city) }
    let(:ticket_state) { ticket_city.state }
    let(:ticket) { create(:ticket, city: ticket_city) }

    before do
      user
      ticket
    end

    it { expect(states_default_selected_for_ticket(ticket, user)).to eq(ticket_state.id) }

    context 'when ticket.city nil' do
      before { ticket.city = nil }

      it { expect(states_default_selected_for_ticket(ticket, user)).to eq(user_state.id) }

      context 'and user.city nil' do
        before { user.city = nil }

        context 'default' do
          it { expect(states_default_selected_for_ticket(ticket, user)).to eq(State.default) }
        end

      end
    end
  end

  context 'states_default_selected_for_user' do
    let(:default_state) { create(:state, :default) }
    let(:city) { create(:city) }
    let(:state) { city.state }
    let(:user) { create(:user, city: city) }

    before { user }

    it { expect(states_default_selected_for_user(user)).to eq(state.id) }

    context 'default' do
      before { user.city = nil }

      it { expect(states_default_selected_for_user(user)).to eq(State.default) }
    end
  end

end
