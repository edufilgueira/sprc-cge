require 'rails_helper'

describe Comment do
  it_behaves_like 'models/paranoia'

  subject(:comment) { build(:comment) }

  describe 'factories' do
    it { is_expected.to be_valid }

    it { expect(build(:comment, :invalid)).to be_invalid }
  end

  describe 'db' do
    describe 'columns' do
      it { is_expected.to have_db_column(:description).of_type(:text) }
      it { is_expected.to have_db_column(:scope).of_type(:integer).with_options(default: :external) }

      it { is_expected.to have_db_column(:commentable_id).of_type(:integer) }
      it { is_expected.to have_db_column(:commentable_type).of_type(:string) }

      it { is_expected.to have_db_column(:author_id).of_type(:integer) }
      it { is_expected.to have_db_column(:author_type).of_type(:string) }

      it { is_expected.to have_db_column(:created_at).of_type(:datetime) }
      it { is_expected.to have_db_column(:updated_at).of_type(:datetime) }
    end

    describe 'indexes' do
      it { is_expected.to have_db_index([:commentable_type, :commentable_id]) }
    end
  end

  describe 'enums' do
    it 'scope' do
      types = [:internal, :external]

      is_expected.to define_enum_for(:scope).with_values(types)
    end
  end

  describe 'attributes' do
    it { is_expected.to respond_to(:justification) }
    it { is_expected.to respond_to(:justification=) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:description) }
    it { is_expected.to validate_presence_of(:commentable) }
    it { is_expected.to validate_presence_of(:scope) }
    it { is_expected.to_not validate_presence_of(:attachments) }
    it { is_expected.to_not validate_presence_of(:author) }
  end

  describe 'associations' do
    it { is_expected.to have_many(:attachments).dependent(:destroy) }
    it { is_expected.to belong_to(:commentable) }
    it { is_expected.to belong_to(:author) }
    it { is_expected.to have_many(:ticket_logs).dependent(:destroy) }
  end

  describe 'scopes' do
    it 'sorted' do
      expect(Comment.sorted).to eq(Comment.order(:created_at))
    end
  end

  describe 'delegations' do
    it { is_expected.to delegate_method(:as_author).to(:author) }
  end

  describe 'nested' do
    it { is_expected.to accept_nested_attributes_for(:attachments).allow_destroy(true) }
  end

  describe 'helpers' do

    context 'ticket_log' do
      let(:ticket) { create(:ticket, :with_parent) }
      let(:ticket_parent) { ticket.parent }

      let(:comment) { create(:comment, commentable: ticket) }

      let!(:ticket_log) { create(:ticket_log, ticket: ticket, resource: comment) }
      let!(:ticket_log_parent) { create(:ticket_log, ticket: ticket_parent, resource: comment) }


      it { expect(comment.ticket_log).to eq(ticket_log) }
    end
  end # helpers

end
