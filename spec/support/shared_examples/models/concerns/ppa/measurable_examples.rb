# Shared example para condern PPA::Measurable

shared_examples_for PPA::Measurable do

  let(:metadata)          { described_class.measurable_metadata }
  let(:association_name)  { described_class.measurable_association_name }
  let(:association_class) { described_class.measurable_metadata }
  let(:foreign_key)       { described_class.measurable_foreign_key }


  describe 'setup' do
    it 'defines the association containing measure records to be calculated in an annual context' do
      expect(association_name).to be_present
      expect(association_class).to be_present
      expect(foreign_key).to be_present
    end
  end

  describe 'associations' do
    it { is_expected.to have_many association_name }
  end

  # TODO melhorar specs
  # Provavelmente com models dummy para ter concretude
  #
end
