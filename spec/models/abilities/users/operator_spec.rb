require 'rails_helper'
require 'cancan/matchers'

describe Abilities::Users::Operator do
  describe 'factory' do

    let(:result) { Abilities::User.factory(user) }

    context 'sou_sectoral' do
      let(:user) { build(:user, :operator_sou_sectoral) }

      it { expect(result).to be_a(Abilities::Users::Operator::SouSectoral) }
    end

    context 'sic_sectoral' do
      let(:user) { build(:user, :operator_sic_sectoral) }

      it { expect(result).to be_a(Abilities::Users::Operator::SicSectoral) }
    end

    context 'subnet_sectoral' do
      let(:user) { build(:user, :operator_subnet_sectoral) }

      it { expect(result).to be_a(Abilities::Users::Operator::SubnetSectoral) }
    end

    context 'cge' do
      let(:user) { build(:user, :operator_cge) }

      it { expect(result).to be_a(Abilities::Users::Operator::Cge) }
    end

    context 'chief' do
      let(:user) { build(:user, :operator_chief) }

      it { expect(result).to be_a(Abilities::Users::Operator::Chief) }
    end

    context 'subnet_chief' do
      let(:user) { build(:user, :operator_subnet_chief) }

      it { expect(result).to be_a(Abilities::Users::Operator::SubnetChief) }
    end

    context 'internal' do
      let(:user) { build(:user, :operator_internal) }

      it { expect(result).to be_a(Abilities::Users::Operator::Internal) }
    end

    context 'call_center' do
      let(:user) { build(:user, :operator_call_center) }

      it { expect(result).to be_a(Abilities::Users::Operator::CallCenter) }
    end

    context 'call_center_supervisor' do
      let(:user) { build(:user, :operator_call_center_supervisor) }

      it { expect(result).to be_a(Abilities::Users::Operator::CallCenterSupervisor) }
    end
  end
end
