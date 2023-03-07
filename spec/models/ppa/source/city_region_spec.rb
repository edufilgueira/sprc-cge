require 'rails_helper'

RSpec.describe PPA::Source::CityRegion, type: :model do

  describe '.all' do
    let(:records) { described_class.all }

    it 'returns an array' do
      expect(records).to be_kind_of(Array)
    end

    it 'parse records' do
      expect(records.first).to be_kind_of(described_class)
    end
  end

  describe '.find_each' do
    before do
      allow(described_class).to receive(:all).and_call_original
      described_class.find_each {}
    end

    it 'iterates over all records' do
      expect(described_class).to have_received(:all)
    end
  end

  let(:line)   { CSV.read(PPA::Source::CityRegion::FILE_PATH).first }
  let(:record) { described_class.new(line) }

  describe '#city_code' do
    it { expect(record.city_code).to eq line[0].to_i }
  end

  describe '#city_name' do
    it { expect(record.city_name).to eq line[1] }
  end

  describe '#region_name' do
    it { expect(record.region_name).to eq line[2] }
  end

end
