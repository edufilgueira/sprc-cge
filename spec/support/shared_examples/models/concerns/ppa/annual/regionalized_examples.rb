# Shared example para condern PPA::Annual::Regionalized

shared_examples_for PPA::Annual::Regionalized do

  let(:association_name)  { described_class.regionalizes_association_name }
  let(:association_class) { described_class.regionalizes_association_class }
  let(:foreign_key)       { described_class.regionalizes_foreign_key }


  describe 'setup' do
    it 'defines which association this record is a regional representation of' do
      expect(association_name).to be_present
      expect(association_class).to be_present
      expect(foreign_key).to be_present
    end
  end

  describe 'associations' do
    it { is_expected.to belong_to association_name }
    it { is_expected.to belong_to :region }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of association_name }
    it { is_expected.to validate_presence_of :region }
    it { is_expected.to validate_presence_of :year }

    it { is_expected.to validate_numericality_of(:year).only_integer.is_greater_than(1900) }

    context 'uniqueness' do
      before { subject.save! }

      it { is_expected.to validate_uniqueness_of(foreign_key).scoped_to(:year, :region_id) }
    end
  end
end
