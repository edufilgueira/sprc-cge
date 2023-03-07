# Shared example para models com timestamp.

shared_examples_for 'models/timestamp' do

  context 'db columns' do
    it { is_expected.to have_db_column(:created_at) }
    it { is_expected.to have_db_column(:updated_at) }
  end

end
