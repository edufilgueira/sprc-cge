# Shared example para action show de transparency/real_states

shared_examples_for 'controllers/transparency/real_states/show' do

  let(:real_state) { create(:integration_real_states_real_state) }

  describe '#show' do
    before { get(:show, params: { id: real_state }) }

    describe 'helper methods' do
      it 'real_state' do
        expect(controller.real_state).to eq(real_state)
      end
    end
  end
end
