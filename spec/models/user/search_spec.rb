require 'rails_helper'

describe User::Search do
  let(:user) { create(:user, name: 'abcdef', social_name: 'klmn', email: '123456@example.com') }
  let(:another_user) { create(:user, name: 'ghij', social_name: 'opqr', email: '7890@example.com') }

  before do
    user
    another_user
  end

  describe 'name' do
    it { expect(User.search('a d f')).to eq([user]) }
  end

  describe 'social_name' do
    it { expect(User.search('k l')).to eq([user]) }
  end

  describe 'email' do
    it { expect(User.search('1 4 6 @')).to eq([user]) }
  end
end
