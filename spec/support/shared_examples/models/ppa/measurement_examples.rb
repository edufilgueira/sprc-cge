# Shared example para model abstrato PPA::Measurement

shared_examples_for PPA::Measurement do |uniqueness: true, **options|

  let(:metadata)          { described_class.measurement_metadata }
  let(:association_name)  { metadata[:association_name] }
  let(:association_class) { metadata[:association_class] }
  let(:foreign_key)       { metadata[:foreign_key] }


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


  describe 'validations' do
    it { is_expected.to validate_presence_of association_name }
    it { is_expected.to validate_numericality_of(:expected).is_greater_than_or_equal_to(0) }
    it { is_expected.to validate_numericality_of(:actual).is_greater_than_or_equal_to(0) }

    context 'when both :expected and :actual are zero' do
      before { subject.expected = subject.actual = 0 }

      it { is_expected.to include_error(:greater_than, count: 0).on(:expected) }
      it { is_expected.to include_error(:greater_than, count: 0).on(:actual) }
    end

    if uniqueness
      context 'uniqueness' do
        before { subject.save! }

        if uniqueness.respond_to?(:key?) && uniqueness.key?(:scope)
          it { is_expected.to validate_uniqueness_of(foreign_key).scoped_to(metadata[:uniqueness_scope]) }
        else
          it { is_expected.to validate_uniqueness_of(foreign_key) }
        end
      end
    end
  end

end
