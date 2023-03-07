require 'rails_helper'

describe ToolbarHelper do

  describe 'user_association' do

    context 'user' do
      let(:user) { create(:user, :user) }

      it { expect(user_association(user)).to eq(nil) }
    end

    context 'operator' do

      context 'sectoral' do
        let(:user) { create(:user, :operator_sectoral) }

        it { expect(user_association(user)).to eq("[#{user.organ_acronym}]") }
      end

      context 'internal' do
        let(:user) { create(:user, :operator_internal) }

        it { expect(user_association(user)).to eq("[#{user.department_acronym}]") }
      end

    end

    context 'admin' do
      let(:user) { create(:user, :admin) }

      it { expect(user_association(user)).to eq(nil) }
    end
  end

end
