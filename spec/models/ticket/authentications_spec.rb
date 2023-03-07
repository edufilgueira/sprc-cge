require 'rails_helper'

describe Ticket::Authentications do
  subject(:ticket) { build(:ticket) }

  describe 'devise' do
    describe 'database_authenticatable' do
      it { is_expected.to have_db_column(:protocol).of_type(:integer) }
      it { is_expected.to have_db_column(:encrypted_password).of_type(:string) }
    end

    describe 'trackable' do
      it { is_expected.to have_db_column(:sign_in_count).of_type(:integer) }
      it { is_expected.to have_db_column(:current_sign_in_at).of_type(:datetime) }
      it { is_expected.to have_db_column(:last_sign_in_at).of_type(:datetime) }
      it { is_expected.to have_db_column(:current_sign_in_ip).of_type(:inet) }
      it { is_expected.to have_db_column(:last_sign_in_ip).of_type(:inet) }
    end
  end

  describe 'helpers' do
     context 'has_password?' do
      context 'true' do
        before { ticket.update_attribute(:password, 'password') }

        it { expect(ticket.has_password?).to eq(true) }
      end

      context 'false' do
        it { expect(ticket.has_password?).to eq(false) }
      end
    end

    context 'create_password?' do
      before { ticket.confirmed! }

      context 'true' do
        it { expect(ticket.create_password?).to eq(true) }
      end

      context 'false' do
        after(:each) { expect(ticket.create_password?).to eq(false) }

        context 'when has_password is true' do
          it { ticket.update_attribute(:password, 'password') }
        end

        context 'when child is true' do
          it { ticket.parent = create(:ticket) }
        end

        context 'when in_progress' do
          it { ticket.in_progress! }
        end
      end
    end

    context 'create_password without special char' do
      before do
        allow(Devise).to receive(:friendly_token).and_return("-=_Abc0")
        ticket.create_password
      end
      it { expect(ticket.password).to eq("abc0") }
      it { expect(ticket.plain_password).to eq("abc0") }
    end
  end
end
