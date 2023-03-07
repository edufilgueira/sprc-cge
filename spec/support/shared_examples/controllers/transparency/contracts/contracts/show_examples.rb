# Shared example para action show de transparency/contracts/contracts

shared_examples_for 'controllers/transparency/contracts/contracts/show' do

  let(:contract) { create(:integration_contracts_contract, :with_nesteds) }

  describe '#show' do
    before { get(:show, params: { id: contract }) }

    describe 'helper methods' do
      it 'contract' do
        expect(controller.contract).to eq(contract)
      end

      describe 'additives' do
        it 'default' do
          expect(controller.additives).to eq(contract.additives)
        end
      end

      describe 'financials' do
        it 'default' do
          expect(controller.financials).to eq(contract.financials)
        end
      end

      describe 'infringements' do
        it 'default' do
          expect(controller.infringements).to eq(contract.infringements)
        end
      end

      describe 'adjustments' do
        it 'default' do
          expect(controller.adjustments).to eq(contract.adjustments)
        end
      end
    end
  end
end
