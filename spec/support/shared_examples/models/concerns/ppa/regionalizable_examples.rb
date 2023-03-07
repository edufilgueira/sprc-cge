# Shared example para condern PPA::Regionalizable

shared_examples_for PPA::Regionalizable do

  let(:association_name)  { described_class.regionalizable_association_name }
  let(:association_class) { described_class.regionalizable_association_class }
  let(:foreign_key)       { described_class.regionalizable_foreign_key }


  describe 'setup' do
    it 'defines the annually regionalizable by asociation' do
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
