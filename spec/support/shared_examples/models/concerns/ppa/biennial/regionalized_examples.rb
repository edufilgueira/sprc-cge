# Shared example para condern PPA::Biennial::Regionalized

shared_examples_for PPA::Biennial::Regionalized do

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

    it { is_expected.to validate_numericality_of(:start_year).only_integer.is_greater_than(1900) }
    it { is_expected.to validate_numericality_of(:end_year).only_integer }

    it 'validates end_year greater than start_year' do
      subject.end_year = subject.start_year - 10
      expect(subject).to include_error(:greater_than, count: subject.start_year).on(:end_year)
    end

    it 'validates that end_year must be consecutive to start_year' do
      subject.end_year = subject.start_year + 3
      expect(subject).to include_error(:invalid).on(:end_year)
    end

    context 'uniqueness' do
      before { subject.save! }

      it { is_expected.to validate_uniqueness_of(foreign_key).scoped_to(:start_year, :end_year, :region_id) }
    end
  end
end
