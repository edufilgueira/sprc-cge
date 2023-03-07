require 'rails_helper'

describe EvaluationExportsHelper do

  describe 'can_select_ticket_type?' do
    context 'operator' do
      context 'cge' do
        let(:user) { create(:user, :operator_cge) }

        it { expect(can_select_ticket_type?(user)).to eq(true) }
      end

      context 'call_center_supervisor' do
        let(:user) { create(:user, :operator_call_center_supervisor) }

        it { expect(can_select_ticket_type?(user)).to eq(true) }
      end

      context 'sou_sectoral' do
        let(:user) { create(:user, :operator_sou_sectoral) }

        it { expect(can_select_ticket_type?(user)).to eq(false) }

        context 'acts_as_sic == true' do
          let(:user) { create(:user, :operator_sou_sectoral, acts_as_sic: true) }

          it { expect(can_select_ticket_type?(user)).to eq(true) }
        end
      end

      context 'internal' do
        let(:user) { create(:user, :operator_internal) }

        it { expect(can_select_ticket_type?(user)).to eq(false) }
      end

      context 'call_center' do
        let(:user) { create(:user, :operator_call_center) }

        it { expect(can_select_ticket_type?(user)).to eq(false) }
      end

      context 'sic_sectoral' do
        let(:user) { create(:user, :operator_sic_sectoral) }

        it { expect(can_select_ticket_type?(user)).to eq(false) }
      end

      context 'chief' do
        let(:user) { create(:user, :operator_chief) }

        it { expect(can_select_ticket_type?(user)).to eq(true) }
      end

      context 'subnet_sectoral' do
        let(:user) { create(:user, :operator_subnet_sectoral) }

        it { expect(can_select_ticket_type?(user)).to eq(true) }
      end

      context 'subnet_chief' do
        let(:user) { create(:user, :operator_subnet_chief) }

        it { expect(can_select_ticket_type?(user)).to eq(true) }
      end
    end
  end
end
