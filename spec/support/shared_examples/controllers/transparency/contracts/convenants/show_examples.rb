# Shared example para action show de transparency/contracts/convenants

shared_examples_for 'controllers/transparency/contracts/convenants/show' do

  let(:convenant) { create(:integration_contracts_convenant, :with_nesteds) }

  describe '#show' do
    before { get(:show, params: { id: convenant }) }

    describe 'helper methods' do
      it 'convenant' do
        expect(controller.convenant).to eq(convenant)
      end

      describe 'additives' do
        it 'default' do
          expect(controller.additives).to eq(convenant.additives)
        end
      end

      describe 'financials' do
        it 'default' do
          expect(controller.financials).to eq(convenant.financials)
        end
      end

      describe 'infringements' do
        it 'default' do
          expect(controller.infringements).to eq(convenant.infringements)
        end
      end

      describe 'adjustments' do
        it 'default' do
          expect(controller.adjustments).to eq(convenant.adjustments)
        end
      end
    end
  end
end
