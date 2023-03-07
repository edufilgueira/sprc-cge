require 'rails_helper'

describe TicketProtectAttachment do
  it { is_expected.to belong_to(:resource) }
  it { is_expected.to belong_to(:attachment) }

  describe 'db' do
    describe 'columns' do
      it { is_expected.to have_db_column(:resource_id).of_type(:integer) }
      it { is_expected.to have_db_column(:resource_type).of_type(:string) }
    end

    describe 'indexes' do
      it { is_expected.to have_db_index([:resource_type, :resource_id]) }
    end
  end
end
