# Shared example para condern PPA::Regional

shared_examples_for PPA::Regional do |uniqueness: true, **options|

  let(:metadata)          { described_class.regional_metadata }
  let(:association_name)  { metadata[:association_name] }
  let(:association_class) { metadata[:association_class] }
  let(:foreign_key)       { metadata[:foreign_key] }


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

    if uniqueness
      context 'uniqueness' do
        before { subject.save! }

        it { is_expected.to validate_uniqueness_of(foreign_key).scoped_to(metadata[:uniqueness_scope]) }
      end
    end
  end
end
