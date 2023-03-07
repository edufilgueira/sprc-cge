# Shared example para action show de transparency/constructions/daes

shared_examples_for 'controllers/transparency/constructions/daes/show' do

  describe '#show' do
    before { get(:show, params: { id: dae }) }

    describe 'helper methods' do
      it 'dae' do
        expect(controller.dae).to eq(dae)
      end

      it 'transparency_export' do
        expect(controller.transparency_follower.resourceable).to eq(controller.dae)
        expect(controller.transparency_follower.transparency_link).to eq(url)
      end
    end
  end
end
