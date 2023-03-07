# Shared example para action show de transparency/city_undertakings

shared_examples_for 'controllers/transparency/city_undertakings/show' do

  let(:contract) { create(:integration_contracts_contract) }
  let(:city_undertaking) { create(:integration_city_undertakings_city_undertaking, sic: contract.isn_sic) }

  describe '#show' do
    before { get(:show, params: { id: city_undertaking }) }

    it { is_expected.to redirect_to(transparency_contracts_contract_path(city_undertaking.contract)) }

    describe 'helper methods' do
      it 'city_undertaking' do
        expect(controller.city_undertaking).to eq(city_undertaking)
      end
    end
  end
end
