require 'rails_helper'

RSpec.describe PPA::Workshop, type: :model do

  subject(:workshop) { create :ppa_workshop }

  describe 'factories' do
    it { is_expected.to be_valid }

    context 'in the past' do
      subject(:workshop) { build :ppa_workshop, :past }

      it { is_expected.to be_valid }
      it { expect(workshop.end_at).to be < Date.today }
    end
  end

  describe 'associations' do
    it { is_expected.to belong_to(:city) }
    it { is_expected.to belong_to(:plan) }
    it { is_expected.to have_many(:documents).dependent(:destroy) }
    it { is_expected.to have_many(:photos).dependent(:destroy) }
  end

  describe 'delegations' do
    it { is_expected.to delegate_method(:name).to(:city).with_arguments(allow_nil: true).with_prefix }
    it { is_expected.to delegate_method(:region_name).to(:city).with_arguments(allow_nil: true).with_prefix }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:address) }
    it { is_expected.to validate_presence_of(:start_at) }
    it { is_expected.to validate_presence_of(:end_at) }
    it { is_expected.to validate_presence_of(:city) }

    it do
      is_expected.to validate_numericality_of(:participants_count)
        .only_integer
        .is_greater_than(0)
        .allow_nil
    end

    context 'when end_at is before start_at' do
      before do
        workshop.end_at = workshop.start_at - 1.day
        workshop.validate
      end

      it { is_expected.to include_error(:invalid_range).on(:end_at) }
    end
  end

  describe 'nested documents' do
    it { is_expected.to accept_nested_attributes_for(:documents) }

    context 'documents' do
      let(:workshop) { build(:ppa_workshop) }
      let(:document) { attributes_for(:ppa_document) }

      context 'with valid attributes' do
        before do
          workshop.assign_attributes( { documents_attributes: [ document ] } )
          workshop.save
        end

        it 'save to db' do
          expect(workshop.documents.count).to eq 1
        end
      end

      context 'with blank attributes' do
        before do
          workshop.assign_attributes( { documents_attributes: [ attachment: '{}' ] } )
          workshop.save
        end

        it 'does not save to db' do
          expect(workshop.documents.count).to eq 0
        end
      end
    end
  end

  describe 'nested photos' do
    it { is_expected.to accept_nested_attributes_for(:photos) }

    context 'photos' do
      let(:workshop) { build(:ppa_workshop) }
      let(:photo)    { attributes_for(:ppa_photo) }

      context 'with valid attributes' do
        before do
          workshop.assign_attributes( { photos_attributes: [ photo ] } )
          workshop.save
        end

        it 'save to db' do
          expect(workshop.photos.count).to eq 1
        end
      end

      context 'with blank attributes' do
        before do
          workshop.assign_attributes( { photos_attributes: [ attachment: '{}' ] } )
          workshop.save
        end

        it 'does not save to db' do
          expect(workshop.photos.count).to eq 0
        end
      end
    end
  end

  describe 'scopes' do
    describe '.starting_at' do
      let!(:workshop1) { create :ppa_workshop, start_at: Date.today }
      let!(:workshop2) { create :ppa_workshop, start_at: Date.tomorrow }

      context 'when date is blank' do
        subject { described_class.starting_at }

        it 'use today as base' do
          is_expected.to eq [workshop1, workshop2]
        end
      end

      context 'when date is present' do
        subject { described_class.starting_at(Date.tomorrow.to_s) }

        it 'uses it as base' do
          is_expected.to eq [workshop2]
        end
      end
    end

    describe '.finished_until' do
      let(:date)       { Date.yesterday - 1.week }
      let!(:workshop1) { create :ppa_workshop, base_date: date }
      let!(:workshop2) { create :ppa_workshop, base_date: date + 2.days }

      context 'when date is blank' do
        subject { described_class.finished_until }

        it 'use today as base' do
          is_expected.to eq [workshop1, workshop2]
        end
      end

      context 'when date is present' do
        subject { described_class.finished_until((date + 1.day).to_s) }

        it 'uses it as base' do
          is_expected.to eq [workshop1]
        end
      end
    end

    describe '.in_city' do
      let(:city) { create :ppa_city }
      let!(:workshop1) { create :ppa_workshop, city: city }
      let!(:workshop2) { create :ppa_workshop }

      subject { described_class.in_city(city.id) }

      it { is_expected.to eq [workshop1] }
    end

    describe '.sorted' do
      it 'use start_at column' do
        expect(described_class.sorted.to_sql).to eq(described_class.order(:start_at).to_sql)
      end
    end
  end

  describe '#address_with_city' do
    let(:expected) { [workshop.address, workshop.city_name].join(', ') }

    it 'joins addresss and city using a comma' do
      expect(workshop.address_with_city).to eq expected
    end
  end

end
