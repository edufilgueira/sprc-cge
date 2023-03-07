# Shared example para models testáveis.

shared_examples_for 'models/testable' do

  context 'factory' do
    it { is_expected.to be_valid }
  end

end
