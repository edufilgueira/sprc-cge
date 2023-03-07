# Shared example para model abstrato PPA::Annual::Measurement

shared_examples_for PPA::Annual::Measurement do

  let(:association_name)  { described_class.measures_association_name }
  let(:association_class) { described_class.measures_association_class }
  let(:foreign_key)       { described_class.measures_foreign_key }

  describe 'setup' do
    it 'defines which association this metric is measured by' do
      expect(association_name).to be_present
      expect(association_class).to be_present
      expect(foreign_key).to be_present
    end
  end

  describe 'associations' do
    it { is_expected.to belong_to association_name }
  end

  describe 'enums' do
    it 'defines enum for :period' do
      is_expected.to define_enum_for(:period).with_values(
        until_march:     1,
        until_june:      2,
        until_september: 3,
        until_december:  4
      )
    end
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of association_name }
    # XXX we're allowing nil values for unknown periods
    # it { is_expected.to validate_presence_of :period }
    it { is_expected.to validate_numericality_of(:expected).is_greater_than_or_equal_to(0) }
    it { is_expected.to validate_numericality_of(:actual).is_greater_than_or_equal_to(0) }

    context 'when both :expected and :actual are zero' do
      before { subject.expected = subject.actual = 0 }

      it { is_expected.to include_error(:greater_than, count: 0).on(:expected) }
      it { is_expected.to include_error(:greater_than, count: 0).on(:actual) }
    end

    context 'uniqueness' do
      before { subject.save! }

      it { is_expected.to validate_uniqueness_of(foreign_key).scoped_to(:period) }
    end
  end

end
