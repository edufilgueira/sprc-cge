require 'rails_helper'

describe Answer do
  it_behaves_like 'models/paranoia'

  subject(:answer) { build(:answer) }

  describe 'factories' do
    it { is_expected.to be_valid }

    it { expect(build(:answer, :invalid)).to be_invalid }
  end

  describe 'db' do
    describe 'columns' do
      it { is_expected.to have_db_column(:user_id).of_type(:integer) }
      it { is_expected.to have_db_column(:description).of_type(:text) }
      it { is_expected.to have_db_column(:original_description).of_type(:text) }

      it { is_expected.to have_db_column(:ticket_id).of_type(:integer) }

      it { is_expected.to have_db_column(:answer_scope).of_type(:integer) }
      it { is_expected.to have_db_column(:answer_type).of_type(:integer) }
      it { is_expected.to have_db_column(:status).of_type(:integer) }
      it { is_expected.to have_db_column(:classification).of_type(:integer) }
      it { is_expected.to have_db_column(:version).of_type(:integer).with_options(null: false, default: 0) }

      it { is_expected.to have_db_column(:deadline).of_type(:integer) }
      it { is_expected.to have_db_column(:sectoral_deadline).of_type(:integer) }

      it { is_expected.to have_db_column(:created_at).of_type(:datetime) }
      it { is_expected.to have_db_column(:updated_at).of_type(:datetime) }
    end
  end

  describe 'enums' do
    it 'status' do
      types = {
        awaiting: 0,
        sectoral_rejected: 1,
        sectoral_approved: 2,
        cge_rejected: 3,
        cge_approved: 4,
        user_evaluated: 5,
        call_center_approved: 7,
        subnet_rejected: 8,
        subnet_approved: 9
        # awaiting_cge: 10
      }

      is_expected.to define_enum_for(:status).with_values(types)
    end

    it 'answer_type' do
      types = [:partial, :final]

      is_expected.to define_enum_for(:answer_type).with_values(types)
    end

    it 'answer_scope' do
      types = [:department, :sectoral, :cge, :call_center, :subnet, :subnet_department]

      is_expected.to define_enum_for(:answer_scope).with_values(types)
    end

    it 'classification' do
      classifications = {
        'sic_attended_personal_info'=>0,
        'sic_attended_rejected_partially'=>1,
        'sic_rejected_secret'=>2,
        'sic_rejected_need_work'=>3,
        # 'sic_rejected_reserved'=>4,
        'sic_rejected_personal_info'=>5,
        'sic_not_attended_info_unclear'=>6,
        'sic_not_attended_info_nonexistent'=>7,
        'sic_rejected_ultrasecret'=>8,
        'sic_rejected_generic'=>9,
        'sic_not_attended_other_organs'=>10,
        'sic_attended_active'=>11,
        'sic_attended_passive'=>12,
        'appeal_deferred'=>13,
        'appeal_rejected'=>14,
        'appeal_deferred_partially'=>15,
        'appeal_loss_object'=>16,
        'appeal_loss_object_partially'=>17,
        'appeal_not_allowed'=>18,
        'sou_demand_well_founded'=>19,
        'sou_demand_unfounded'=>20,
        'sou_well_founded_partially'=>21,
        'sou_could_not_verify'=>22,
        'sou_waitting_determination_result'=>23,
        'other_organs'=>24,
        'legacy_classification'=>-1
      }

      is_expected.to define_enum_for(:classification).with_values(classifications)
      expect(Ticket.answer_classifications).to eq(Answer.classifications)
    end
  end

  describe 'attributes' do
    it { is_expected.to respond_to(:justification) }
    it { is_expected.to respond_to(:justification=) }
    it { is_expected.to respond_to(:department_id) }
    it { is_expected.to respond_to(:department_id=) }
  end

  describe 'delegations' do
    it { is_expected.to delegate_method(:as_author).to(:user) }
    it { is_expected.to delegate_method(:average).to(:evaluation).with_arguments(allow_nil: true).with_prefix }
    it { is_expected.to delegate_method(:department).to(:user).with_arguments(allow_nil: true).with_prefix }

    it { is_expected.to delegate_method(:sic?).to(:ticket).with_arguments(allow_nil: true).with_prefix }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:description) }
    it { is_expected.to validate_presence_of(:ticket) }
    it { is_expected.to validate_presence_of(:answer_type) }
    it { is_expected.to validate_presence_of(:answer_scope) }
    it { is_expected.to validate_presence_of(:status) }
    it { is_expected.to_not validate_presence_of(:attachments) }


    describe 'certificate' do

      context 'with rejected classification' do
        %w(
          sic_attended_rejected_partially
          sic_rejected_secret
          sic_rejected_need_work

          sic_rejected_personal_info
          sic_rejected_ultrasecret
          sic_rejected_generic

        ).each do |classification|
          it "rejected classification" do
            answer.classification = classification
            answer.answer_scope = :sectoral
            expect(answer).to validate_presence_of(:certificate)
          end
        end
      end

      context 'with rejected answer_classification' do
        %w(
          sic_attended_personal_info
          sic_not_attended_info_unclear
          sic_not_attended_info_nonexistent
          sic_attended_active
          sic_attended_passive
          sic_not_attended_other_organs
          appeal_rejected
        ).each do |classification|
          it "rejected classification" do
            answer.classification = classification

            expect(answer).to_not validate_presence_of(:certificate)
          end
        end
      end
    end

    context 'classification' do
      it 'scope cge' do
        answer.answer_scope = :cge
        is_expected.to validate_presence_of(:classification)
      end
      it 'scope sectoral' do
        answer.answer_scope = :sectoral
        is_expected.to validate_presence_of(:classification)
      end
      it 'scope department' do
        answer.answer_scope = :department
        is_expected.to_not validate_presence_of(:classification)
      end
      it 'scope subnet' do
        answer.answer_scope = :subnet
        is_expected.to validate_presence_of(:classification)
      end
      it 'scope subnet_department' do
        answer.answer_scope = :subnet_department
        is_expected.to_not validate_presence_of(:classification)
      end
      it 'scope call_center' do
        answer.answer_scope = :call_center
        is_expected.to_not validate_presence_of(:classification)
      end

    end
  end

  describe 'associations' do
    it { is_expected.to have_many(:attachments).dependent(:destroy) }
    it { is_expected.to belong_to(:ticket) }
    it { is_expected.to belong_to(:user) }
    it { is_expected.to have_many(:ticket_logs) }
    it { is_expected.to have_one(:evaluation) }
    it { is_expected.to have_one(:ticket_department_email) }
  end

  describe 'scopes' do
    it 'sorted' do
      expect(Answer.sorted).to eq(Answer.order(:created_at))
    end

    it 'approved' do
      expected = Answer.where(status: [:cge_approved, :sectoral_approved, :subnet_approved]).to_sql

      expect(Answer.approved.to_sql).to eq(expected)
    end

    it 'approved_for_citizen' do
      expected = Answer.where(status: [:cge_approved, :user_evaluated, :call_center_approved, :sectoral_approved]).to_sql

      expect(Answer.approved_for_citizen.to_sql).to eq(expected)
    end

    context 'by_department' do
      let(:user) { create(:user, :operator_internal) }
      let(:department) { user.department }
      let(:user_answer) { create(:answer, :positioning, user: user) }

      let(:ticket_department) { create(:ticket_department, department: department) }
      let(:ticket_department_email_answer) { create(:ticket_department_email, :with_positioning, ticket_department: ticket_department).answer }

      before do
        user_answer
        ticket_department_email_answer

        other_department_user = create(:user, :operator_internal)
        create(:answer, :positioning, user: other_department_user)
      end

      it { expect(Answer.by_department(department.id)).to match_array([user_answer, ticket_department_email_answer]) }

      context 'when scope subnet_department' do
        let(:user) { create(:user, :operator_subnet_internal) }
        let(:user_answer) { create(:answer, :subnet_positioning, user: user) }

        it { expect(Answer.by_department(department.id)).to match_array([user_answer, ticket_department_email_answer]) }
      end
    end

    it 'by_version' do
      answer = create(:answer, version: 0)
      create(:answer, version: 1)

      expect(Answer.by_version(0)).to match_array([answer])
    end

    it 'active' do
      awaiting = create(:answer, status: :awaiting)
      sectoral_approved = create(:answer, status: :sectoral_approved)
      cge_approved = create(:answer, status: :cge_approved)
      user_evaluated = create(:answer, status: :user_evaluated)
      call_center_approved = create(:answer, status: :call_center_approved)
      subnet_approved = create(:answer, status: :subnet_approved)

      create(:answer, status: :sectoral_rejected)
      create(:answer, status: :cge_rejected)
      create(:answer, status: :subnet_rejected)

      expected = [awaiting, sectoral_approved, cge_approved, user_evaluated, call_center_approved, subnet_approved]

      expect(Answer.active).to match_array(expected)
    end
  end

  describe 'constants' do
    it 'visible_to_user_statuses' do
      expect(Answer::VISIBLE_TO_USER_STATUSES).to eq(
        [
          :cge_approved,
          :user_evaluated,
          :call_center_approved,
          :sectoral_approved
        ]
      )
    end

    it 'visible_to_operators_statuses' do
      expect(Answer::VISIBLE_TO_OPERATOR_STATUSES).to eq(
        [
          :sectoral_rejected,
          :cge_rejected,
          :subnet_rejected,
          :subnet_approved,
          :cge_approved,
          :user_evaluated,
          :call_center_approved,
          :sectoral_approved
        ]
      )
    end
  end

  describe 'nested' do
    it { is_expected.to accept_nested_attributes_for(:attachments).allow_destroy(true) }
  end

  describe 'helpers' do

    describe 'approved_for_user' do
      it 'cge_approved' do
        answer.status = :cge_approved
        expect(answer.approved_for_user?).to be_truthy
      end
      it 'call_center_approved' do
        answer.status = :call_center_approved
        expect(answer.approved_for_user?).to be_truthy
      end
      it 'sectoral_approved' do
        answer.status = :sectoral_approved
        expect(answer.approved_for_user?).to be_falsey
      end
      it 'sectoral_approved' do
        answer.status = :subnet_approved
        expect(answer.approved_for_user?).to be_falsey
      end
    end

    it 'answer_type_str' do

      expected = Answer.human_attribute_name("answer_type.#{answer.answer_type}")
      expect(answer.answer_type_str).to eq(expected)
    end

    it 'status_str' do
      answer.status = :cge_approved
      expected = Answer.human_attribute_name("status.#{answer.ticket.ticket_type}.cge_approved")
      expect(answer.status_str).to eq(expected)
    end

    context 'classification_str' do
      it 'when nil' do
        answer.classification = nil
        expect(answer.classification_str).to eq('')
      end

      it 'when present' do

        answer.classification = :sic_attended_passive
        expected = Answer.human_attribute_name("classification.#{answer.classification}")
        expect(answer.classification_str).to eq(expected)
      end
    end


    context 'ticket_log' do
      let(:ticket) { create(:ticket, :with_parent) }
      let(:ticket_parent) { ticket.parent }

      let(:answer) { create(:answer, ticket: ticket) }

      let!(:ticket_log) { create(:ticket_log, ticket: ticket, resource: answer) }
      let!(:ticket_log_parent) { create(:ticket_log, ticket: ticket_parent, resource: answer) }


      it { expect(answer.ticket_log).to eq(ticket_log) }
    end

    context 'modified_description?' do
      it 'false' do
        answer.description = answer.original_description

        expect(answer.modified_description?).to be_falsey
      end

      it 'true' do
        answer.description = 'Modified description'

        expect(answer.modified_description?).to be_truthy
      end
    end

    context 'positioning?' do
      context 'department' do
        before { answer.answer_scope = :department }

        it { expect(answer).to be_positioning }
      end

      context 'subnet_department' do
        before { answer.answer_scope = :subnet_department }

        it { expect(answer).to be_positioning }
      end

      context 'sectoral' do
        before { answer.answer_scope = :sectoral }

        it { expect(answer).not_to be_positioning }
      end

      context 'cge' do
        before { answer.answer_scope = :cge }

        it { expect(answer).not_to be_positioning }
      end

      context 'call_center' do
        before { answer.answer_scope = :call_center }

        it { expect(answer).not_to be_positioning }
      end

      context 'subnet' do
        before { answer.answer_scope = :subnet }

        it { expect(answer).not_to be_positioning }
      end
    end

    context 'rejected_answer?' do
      let(:approved_positioning) { build(:answer, :approved_positioning) }
      let(:rejected_positioning) { build(:answer, :rejected_positioning) }
      let(:cge_rejected) { build(:answer, :cge_rejected) }

      it { expect(approved_positioning).not_to be_rejected_answer }
      it { expect(rejected_positioning).to be_rejected_answer }
      it { expect(cge_rejected).to be_rejected_answer }
    end
  end # helpers

  describe 'callbacks' do
    context 'before_create' do
      it 'set original_answer' do
        expect do
          expect(answer.original_description).to eq(nil)

          answer.save

          expect(answer.reload.original_description).to eq(answer.description)
        end.to change(Answer, :count).by(1)
      end


      context 'set sectoral_deadline' do
        let(:deadline) { 2 }
        let(:ticket) { create(:ticket, :confirmed, deadline: deadline) }

        context 'when already have a partial answer' do
          let(:answer_scope) { :sectoral }

          it 'set previous answer sectoral_deadline' do
            previous_answer = create(:answer, ticket: ticket, answer_scope: answer_scope, answer_type: :partial, status: :cge_approved)

            # change deadline value
            ticket.update(deadline: 0)

            new_answer = create(:answer, ticket: ticket, answer_scope: answer_scope)

            # get sectoral_deadline on previous answer
            expect(new_answer.sectoral_deadline).to eq(previous_answer.sectoral_deadline)
          end
        end

        context 'when answer_scope is' do
          let(:answer) { build(:answer, ticket: ticket, answer_scope: answer_scope) }

          before { answer.save }

          context 'sectoral' do
            let(:answer_scope) { :sectoral }

            it { expect(answer.reload.sectoral_deadline).to eq(deadline) }
          end

          context 'cge' do
            let(:answer_scope) { :cge }

            it { expect(answer.reload.sectoral_deadline).to eq(deadline) }
          end

          context 'call_center' do
            let(:answer_scope) { :call_center }

            it { expect(answer.reload.sectoral_deadline).to eq(deadline) }
          end

          context 'subnet' do
            let(:answer_scope) { :subnet }

            it { expect(answer.reload.sectoral_deadline).to eq(deadline) }
          end

          context 'department' do
            let(:answer_scope) { :department }

            it { expect(answer.reload.sectoral_deadline).to eq(nil) }
          end

          context 'subnet_department' do
            let(:answer_scope) { :subnet_department }

            it { expect(answer.reload.sectoral_deadline).to eq(nil) }
          end
        end
      end
    end
  end
end
