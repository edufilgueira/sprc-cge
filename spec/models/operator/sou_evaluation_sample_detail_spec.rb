require 'rails_helper'

RSpec.describe Operator::SouEvaluationSampleDetail, type: :model do

  describe 'db' do
    describe 'columns' do
      it { is_expected.to have_db_column(:created_at).of_type(:datetime) }
      it { is_expected.to have_db_column(:rated).of_type(:boolean) }
      it { is_expected.to have_db_column(:sou_evaluation_sample_id).of_type(:integer) }
      it { is_expected.to have_db_column(:ticket_id).of_type(:integer) }
      it { is_expected.to have_db_column(:updated_at).of_type(:datetime) }
    end
  end

  # Associations
  describe 'associations' do
    it { is_expected.to belong_to(:sou_evaluation_sample) }
    it { is_expected.to belong_to(:ticket) }
  end

  # Delegations
  describe 'delegations' do
    it { is_expected.to delegate_method(:name).to(:ticket).with_arguments(allow_nil: true).with_prefix }
    it { is_expected.to delegate_method(:sou_type).to(:ticket).with_arguments(allow_nil: true).with_prefix }
    it { is_expected.to delegate_method(:parent_protocol).to(:ticket).with_arguments(allow_nil: true).with_prefix }
    it { is_expected.to delegate_method(:description).to(:ticket).with_arguments(allow_nil: true).with_prefix }
  end
end
