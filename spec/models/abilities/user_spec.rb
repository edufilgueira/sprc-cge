require 'rails_helper'
require 'cancan/matchers'

describe Abilities::User do
  describe 'factory' do

    it 'public abilities' do
      result = Abilities::User.factory(nil)
      expect(result).to be_a(Abilities::Users::Public)
    end

    it 'admin abilities' do
      user = build(:user, :admin)
      result = Abilities::User.factory(user)

      expect(result).to be_a(Abilities::Users::Admin)
    end

    it 'operator abilities' do
      user = build(:user, :operator)

      allow(Abilities::Users::Operator).to receive(:factory)
      expect(Abilities::Users::Operator).to receive(:factory).with(user)

      Abilities::User.factory(user)
    end

    it 'user abilities' do
      user = build(:user, :user)
      result = Abilities::User.factory(user)

      expect(result).to be_a(Abilities::Users::User)
    end
  end
end
