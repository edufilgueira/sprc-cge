require 'rails_helper'
require 'cancan/matchers'

describe Abilities::Users::Admin do

  subject(:ability) { Abilities::Users::Admin.new(user) }

  context 'admin' do
    let(:user) { create(:user, :admin) }

    it { is_expected.to be_able_to(:manage, :all) }
  end
end
