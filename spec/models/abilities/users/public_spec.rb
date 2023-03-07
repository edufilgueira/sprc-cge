require 'rails_helper'
require 'cancan/matchers'

describe Abilities::Users::Public do

  subject(:ability) { Abilities::Users::Public.new }

  describe '#can_change_extension_status' do
    it 'extension in_progress' do
      extension = create(:extension, status: :in_progress)
      is_expected.to be_able_to(:change_extension_status, extension)
    end
    it 'extension approved' do
      extension = create(:extension, status: :approved)
      is_expected.not_to be_able_to(:change_extension_status, extension)
    end
    it 'extension rejected' do
      extension = create(:extension, status: :rejected)
      is_expected.not_to be_able_to(:change_extension_status, extension)
    end
  end

  describe 'Answer' do
    let(:answer) { build(:answer) }

    context 'when awaiting' do
      before { answer.status = :awaiting }

      it { is_expected.to_not be_able_to(:view, answer) }
    end

    context 'when sectoral_rejected' do
      before { answer.status = :sectoral_rejected }

      it { is_expected.to_not be_able_to(:view, answer) }
    end

    context 'when sectoral_approved' do
      before { answer.status = :sectoral_approved }

      it { is_expected.to_not be_able_to(:view, answer) }
    end

    context 'when cge_rejected' do
      before { answer.status = :cge_rejected }

      it { is_expected.to_not be_able_to(:view, answer) }
    end

    context 'when cge_approved' do
      before { answer.status = :cge_approved }

      it { is_expected.to be_able_to(:view, answer) }
    end

    context 'when user_evaluated' do
      before { answer.status = :user_evaluated }

      it { is_expected.to be_able_to(:view, answer) }
    end

    context 'when call_center_approved' do
      before { answer.status = :call_center_approved }

      it { is_expected.to be_able_to(:view, answer) }
    end
  end

  describe 'Operator SouEvaluationSamples' do
    it { is_expected.not_to be_able_to(:manage, Operator::SouEvaluationSample) }
  end

  describe 'Operator SouEvaluationSamples GeneratedList' do
    it { is_expected.not_to be_able_to(:manage, Operator::SouEvaluationSamples::GeneratedList) }
  end
end
