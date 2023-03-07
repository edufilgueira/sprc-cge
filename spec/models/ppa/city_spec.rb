require 'rails_helper'

RSpec.describe PPA::City, type: :model do

  before { create :ppa_city }

  let(:parent_city)  { City.first }

  describe 'associations' do
    it { is_expected.to belong_to(:region) }
  end

  describe '.all' do
    it 'return PPA::City objects' do
      expect(PPA::City.all.first).to be_kind_of(PPA::City)
    end
  end

  describe '.default_scope' do
    let!(:state) { parent_city.state }

    it 'return state scoped queries' do
      expect(PPA::City.default_scoped.to_sql).to eq(PPA::City.unscoped.where(state_id: state.id).to_sql)
    end
  end

  describe '.find_by' do
    let(:record) { PPA::City.find_by(name: parent_city.name) }

    context 'when record exists' do
      it 'return it' do
        expect(record).not_to be_nil
      end

      it 'return PPA::City object' do
        expect(record).to be_kind_of(PPA::City)
      end
    end

    context 'when record dont exist' do
      let(:record) { PPA::City.find_by(name: 'foo') }

      it 'return nil' do
        expect(record).to be_nil
      end
    end

    context 'when city doesnt belong to scoped state' do
      let(:city)   { create :city, name: 'Awesomecity' }
      let(:record) { PPA::City.find_by(name: city.name) }

      it 'return nil' do
        expect(record).to be_nil
      end
    end
  end

  describe '.find' do
    let(:record) { PPA::City.find(parent_city.id) }

    context 'when record exists' do
      it 'return it' do
        expect(record).not_to be_nil
      end

      it 'return PPA::City object' do
        expect(record).to be_kind_of(PPA::City)
      end
    end

    context 'when record dont exist' do
      it 'raise not found error' do
        expect { PPA::City.find('99XD').to raise_error(ActiveRecord::RecordNotFound) }
      end
    end
  end

  describe 'instance' do
    let(:parent) { parent_city }
    let(:city)   { PPA::City.find(parent.id) }

    it { expect(city.id).to eq parent.id }
    it { expect(city.code).to eq parent.code }
    it { expect(city.name).to eq parent.name }


    %w[destroy delete update update! update_column update_columns].each do |method|
      context 'raise error for' do
        it method do
          expect { city.public_send(method) }.to raise_error(NoMethodError)
        end
      end
    end
  end

end
