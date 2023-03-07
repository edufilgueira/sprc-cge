# Shared example para action show de transparency/constructions/ders

shared_examples_for 'controllers/transparency/constructions/ders/show' do

  let(:der) { create(:integration_constructions_der) }

  describe '#show' do
    before { get(:show, params: { id: der }) }

    describe 'helper methods' do
      it 'der' do
        expect(controller.der).to eq(der)
      end
    end
  end
end
