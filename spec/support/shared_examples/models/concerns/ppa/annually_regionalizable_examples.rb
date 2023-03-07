# Shared example para condern PPA::AnnuallyRegionalizable

shared_examples_for PPA::AnnuallyRegionalizable do

  let(:association_name)  { described_class.annually_regionalizable_by_association_name }
  let(:association_class) { described_class.annually_regionalizable_by_association_class }
  let(:foreign_key)       { described_class.annually_regionalizable_by_foreign_key }


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
