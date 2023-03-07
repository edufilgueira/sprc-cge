require 'rails_helper'

describe Ticket do
  it_behaves_like 'models/paranoia'

  subject(:ticket) { build(:ticket) }

  let(:ticket_denunciation) { build(:ticket, :denunciation) }

  describe 'factories' do
    it { is_expected.to be_valid }

    it { expect(build(:ticket, :confirmed)).to be_valid }

    it { expect(build(:ticket, :invalid)).to be_invalid }

    context 'traits' do
      subject(:ticket) { build :ticket, trait }

      context 'anonymous' do
        let(:trait) { :anonymous }
        it { is_expected.to be_valid }
        it { is_expected.to be_anonymous }
      end

      context 'identified' do
        let(:trait) { :identified }
        it { is_expected.to be_valid }
        it { is_expected.to be_identified }
      end

      context 'from_registered_user' do
        let(:trait) { :from_registered_user }
        it { is_expected.to be_valid }
        it { is_expected.to be_from_registered_user }
        it 'defined the ticket creator as an user of type :user (citizen)' do
          expect(ticket.created_by).to be_user
        end

        context 'supplying custom user' do
          let(:user) { create :user, :user, name: 'Usuário específico' }
          subject { build :ticket, trait, created_by: user }

          it { is_expected.to be_valid }
          it { is_expected.to be_from_registered_user }
        end
      end
    end
  end


  describe 'db' do
    describe 'columns' do
      it { is_expected.to have_db_column(:ticket_type).of_type(:integer) }
      it { is_expected.to have_db_column(:sou_type).of_type(:integer) }
      it { is_expected.to have_db_column(:description).of_type(:text) }
      it { is_expected.to have_db_column(:email).of_type(:string) }
      it { is_expected.to have_db_column(:name).of_type(:string) }
      it { is_expected.to have_db_column(:organ_id).of_type(:integer) }
      it { is_expected.to have_db_column(:subnet_id).of_type(:integer) }
      it { is_expected.to have_db_column(:status).of_type(:integer) }
      it { is_expected.to have_db_column(:anonymous).of_type(:boolean) }
      it { is_expected.to have_db_column(:unknown_organ).of_type(:boolean) }
      it { is_expected.to have_db_column(:unknown_subnet).of_type(:boolean) }
      it { is_expected.to have_db_column(:unknown_classification).of_type(:boolean).with_options(default: false) }
      it { is_expected.to have_db_column(:internal_status).of_type(:integer) }
      it { is_expected.to have_db_column(:reopened).of_type(:integer).with_options(default: 0) }
      it { is_expected.to have_db_column(:reopened_at).of_type(:datetime) }
      it { is_expected.to have_db_column(:appeals).of_type(:integer).with_options(default: 0) }
      it { is_expected.to have_db_column(:appeals_at).of_type(:datetime) }
      it { is_expected.to have_db_column(:responded_at).of_type(:datetime) }
      it { is_expected.to have_db_column(:parent_id).of_type(:integer) }
      it { is_expected.to have_db_column(:confirmed_at).of_type(:datetime) }
      it { is_expected.to have_db_column(:document_type).of_type(:integer) }
      it { is_expected.to have_db_column(:document).of_type(:string) }
      it { is_expected.to have_db_column(:person_type).of_type(:integer).with_options(default: :individual) }
      it { is_expected.to have_db_column(:deadline).of_type(:integer) }
      it { is_expected.to have_db_column(:deadline_ends_at).of_type(:date) }
      it { is_expected.to have_db_column(:denunciation_organ_id).of_type(:integer) }
      it { is_expected.to have_db_column(:denunciation_description).of_type(:text) }
      it { is_expected.to have_db_column(:denunciation_date).of_type(:string) }
      it { is_expected.to have_db_column(:denunciation_place).of_type(:string) }
      it { is_expected.to have_db_column(:denunciation_assurance).of_type(:integer) }
      it { is_expected.to have_db_column(:denunciation_witness).of_type(:text) }
      it { is_expected.to have_db_column(:denunciation_evidence).of_type(:text) }
      it { is_expected.to have_db_column(:denunciation_against_operator).of_type(:boolean).with_options(default: nil) }
      it { is_expected.to have_db_column(:used_input).of_type(:integer) }
      it { is_expected.to have_db_column(:used_input_url).of_type(:string) }
      it { is_expected.to have_db_column(:call_center_responsible_id).of_type(:integer) }
      it { is_expected.to have_db_column(:call_center_allocation_at).of_type(:datetime) }
      it { is_expected.to have_db_column(:answer_classification).of_type(:integer) }
      it { is_expected.to have_db_column(:priority).of_type(:boolean) }
      it { is_expected.to have_db_column(:plain_password).of_type(:string) }
      it { is_expected.to have_db_column(:gender).of_type(:integer) }
      it { is_expected.to have_db_column(:social_name).of_type(:string) }
      it { is_expected.to have_db_column(:extended).of_type(:boolean).with_options(default: false) }
      it { is_expected.to have_db_column(:public_ticket).of_type(:boolean).with_options(default: false) }
      it { is_expected.to have_db_column(:published).of_type(:boolean).with_options(default: false) }
      it { is_expected.to have_db_column(:parent_protocol).of_type(:string) }
      it { is_expected.to have_db_column(:parent_unknown_organ).of_type(:boolean) }
      it { is_expected.to have_db_column(:immediate_answer).of_type(:boolean) }
      it { is_expected.to have_db_column(:note).of_type(:text) }
      it { is_expected.to have_db_column(:rede_ouvir).of_type(:boolean).with_options(default: false) }
      it { is_expected.to have_db_column(:citizen_topic_id).of_type(:integer) }
      it { is_expected.to have_db_column(:internal_evaluation).of_type(:boolean) }
      it { is_expected.to have_db_column(:marked_internal_evaluation).of_type(:boolean) }


      # Resposta do chamado

      it { is_expected.to have_db_column(:answer_type).of_type(:integer) }
      it { is_expected.to have_db_column(:answer_phone).of_type(:string) }
      it { is_expected.to have_db_column(:answer_cell_phone).of_type(:string) }

      it { is_expected.to have_db_column(:answer_address_city_name).of_type(:string) }
      it { is_expected.to have_db_column(:answer_address_street).of_type(:string) }
      it { is_expected.to have_db_column(:answer_address_number).of_type(:string) }
      it { is_expected.to have_db_column(:answer_address_zipcode).of_type(:string) }
      it { is_expected.to have_db_column(:answer_address_neighborhood).of_type(:string) }
      it { is_expected.to have_db_column(:answer_address_complement).of_type(:string) }

      it { is_expected.to have_db_column(:answer_twitter).of_type(:string) }
      it { is_expected.to have_db_column(:answer_facebook).of_type(:string) }
      it { is_expected.to have_db_column(:answer_instagram).of_type(:string) }
      it { is_expected.to have_db_column(:answer_whatsapp).of_type(:string) }

      it { is_expected.to have_db_column(:classified).of_type(:boolean) }

      it { is_expected.to have_db_column(:city_id).of_type(:integer) }

      it { is_expected.to have_db_column(:call_center_feedback_at).of_type(:datetime) }
      it { is_expected.to have_db_column(:call_center_status).of_type(:integer) }

      # Local da ocorrência
      it { is_expected.to have_db_column(:target_address_zipcode).of_type(:string) }
      it { is_expected.to have_db_column(:target_city_id).of_type(:integer) }
      it { is_expected.to have_db_column(:target_address_street).of_type(:string) }
      it { is_expected.to have_db_column(:target_address_number).of_type(:string) }
      it { is_expected.to have_db_column(:target_address_neighborhood).of_type(:string) }
      it { is_expected.to have_db_column(:target_address_complement).of_type(:string) }

      # Audits

      it { is_expected.to have_db_column(:created_by_id).of_type(:integer) }
      it { is_expected.to have_db_column(:updated_by_id).of_type(:integer) }
      it { is_expected.to have_db_column(:created_at).of_type(:datetime) }
      it { is_expected.to have_db_column(:updated_at).of_type(:datetime) }
    end

    describe 'indexes' do
      it { is_expected.to have_db_index(:created_by_id) }
      it { is_expected.to have_db_index(:deleted_at) }
      it { is_expected.to have_db_index(:ticket_type) }
      it { is_expected.to have_db_index(:sou_type) }
      it { is_expected.to have_db_index(:organ_id) }
      it { is_expected.to have_db_index(:subnet_id) }
      it { is_expected.to have_db_index(:parent_protocol) }
      it { is_expected.to have_db_index(:status) }
      it { is_expected.to have_db_index(:anonymous) }
      it { is_expected.to have_db_index(:unknown_organ) }
      it { is_expected.to have_db_index(:unknown_subnet) }
      it { is_expected.to have_db_index(:updated_by_id) }
      it { is_expected.to have_db_index(:call_center_responsible_id) }
      it { is_expected.to have_db_index(:parent_protocol) }
    end
  end

  describe 'constants' do
    it { expect(Ticket::SIC_DEADLINE).to eq(20) }
    it { expect(Ticket::SOU_DEADLINE).to eq(20) }
    it { expect(Ticket::SIC_EXTENSION_DAYS).to eq(10) }
    it { expect(Ticket::SOU_EXTENSION_DAYS).to eq(10) }
    it { expect(Ticket::SIC_EXTENSION).to eq(Ticket::SIC_DEADLINE + Ticket::SIC_EXTENSION_DAYS) }
    it { expect(Ticket::SOU_EXTENSION).to eq(Ticket::SOU_DEADLINE + Ticket::SOU_EXTENSION_DAYS) }

    it 'PERMITTED_PARAMS_FOR_SHARE' do
      permitted_params_for_share = [
        :id,
        :rede_ouvir,
        :organ_id,
        :subnet_id,
        :unknown_subnet,
        :description,
        :sou_type,
        :denunciation_organ_id,
        :denunciation_description,
        :denunciation_date,
        :denunciation_place,
        :denunciation_witness,
        :denunciation_evidence,
        :denunciation_assurance,
        :justification,
        protected_attachment_ids: []
      ]

      expect(Ticket::PERMITTED_PARAMS_FOR_SHARE).to eq(permitted_params_for_share)
    end

    it 'PERMITTED_PARAMS_FOR_SHARE_TO_REDE_OUVIR' do
      unpermitted_params_rede_ouvir = ['organ_id', 'subnet_id', 'unknown_subnet']
      expect(Ticket::PERMITTED_PARAMS_FOR_SHARE_TO_REDE_OUVIR ).to eq(Ticket::PERMITTED_PARAMS_FOR_SHARE - unpermitted_params_rede_ouvir)
    end

    it 'FILTER_DEADLINE' do
      filter_deadlines = {
        not_expired: 0..Float::INFINITY,
        expired_can_extend: -Float::INFINITY..-1,
        expired: -Float::INFINITY..-1
      }

      expect(Ticket::FILTER_DEADLINE).to eq(filter_deadlines)
    end
  end

  describe 'associations' do
    it { is_expected.to belong_to(:organ) }
    it { is_expected.to belong_to(:subnet) }
    it { is_expected.to belong_to(:parent).class_name('Ticket').touch(true) }
    it { is_expected.to belong_to(:created_by).class_name('User') }
    it { is_expected.to belong_to(:updated_by).class_name('User') }
    it { is_expected.to belong_to(:call_center_responsible).class_name('User') }
    it { is_expected.to belong_to(:denunciation_organ).class_name('Organ') }
    it { is_expected.to belong_to(:city) }

    it { is_expected.to have_many(:attachments).dependent(:destroy) }
    it { is_expected.to have_many(:tickets) }
    it { is_expected.to have_many(:ticket_departments).dependent(:destroy) }
    it { is_expected.to have_many(:extensions).dependent(:destroy) }
    it { is_expected.to have_many(:ticket_subscriptions).dependent(:destroy) }
    it { is_expected.to have_many(:attendance_responses).dependent(:destroy) }
    it { is_expected.to have_many(:ticket_subscriptions_confirmed).dependent(:destroy) }
    it { is_expected.to have_many(:subscribers).through(:ticket_subscriptions_confirmed) }
    it { is_expected.to have_many(:ticket_protect_attachments).dependent(:destroy) }

    it { is_expected.to have_one(:attendance).inverse_of(:ticket) }
    it { is_expected.to have_one(:attendance_evaluation) }
    it { is_expected.to have_one(:classification).inverse_of(:ticket) }
    it { is_expected.to have_one(:state).through(:city) }

    it { is_expected.to belong_to(:target_city).class_name(:City) }
    it { is_expected.to have_one(:target_state).through(:target_city).class_name(:State).source(:state) }
  end

  describe 'attributes' do
    it { is_expected.to respond_to(:justification) }
    it { is_expected.to respond_to(:justification=) }
  end

  describe 'nested' do
    it { is_expected.to accept_nested_attributes_for(:attachments).allow_destroy(true) }
    it { is_expected.to accept_nested_attributes_for(:tickets) }
    it { is_expected.to accept_nested_attributes_for(:ticket_departments) }
    it { is_expected.to accept_nested_attributes_for(:classification) }
  end

  describe 'delegations' do
    it { is_expected.to delegate_method(:name).to(:organ).with_prefix }
    it { is_expected.to delegate_method(:acronym).to(:organ).with_prefix }
    it { is_expected.to delegate_method(:subnet?).to(:organ).with_prefix.with_arguments(allow_nil: true) }
    it { is_expected.to delegate_method(:full_acronym).to(:organ).with_prefix }
    it { is_expected.to delegate_method(:name).to(:unit).with_prefix }
    it { is_expected.to delegate_method(:acronym).to(:unit).with_prefix }
    it { is_expected.to delegate_method(:full_acronym).to(:unit).with_prefix }
    it { is_expected.to delegate_method(:name).to(:unit).with_prefix }
    it { is_expected.to delegate_method(:title).to(:unit).with_prefix }
    it { is_expected.to delegate_method(:acronym).to(:denunciation_organ).with_prefix }
    it { is_expected.to delegate_method(:name).to(:denunciation_organ).with_prefix }
    it { is_expected.to delegate_method(:average_attendance_evaluation).to(:organ).with_arguments(allow_nil: true).with_prefix }
    it { is_expected.to delegate_method(:name).to(:city).with_prefix }
    it { is_expected.to delegate_method(:title).to(:city).with_prefix }
    it { is_expected.to delegate_method(:state_acronym).to(:city).with_prefix }
    it { is_expected.to delegate_method(:id).to(:state).with_prefix }
    it { is_expected.to delegate_method(:other_organs).to(:classification).with_arguments(allow_nil: true) }
    it { is_expected.to delegate_method(:ignore_cge_validation).to(:organ).with_arguments(allow_nil: true).with_prefix }

    it { is_expected.to delegate_method(:acronym).to(:subnet).with_arguments(allow_nil: true).with_prefix }
    it { is_expected.to delegate_method(:full_acronym).to(:subnet).with_arguments(allow_nil: true).with_prefix }
    it { is_expected.to delegate_method(:ignore_sectoral_validation).to(:subnet).with_arguments(allow_nil: true).with_prefix }
    it { is_expected.to delegate_method(:service_type).to(:attendance).with_arguments(allow_nil: true).with_prefix }
    it { is_expected.to delegate_method(:unknown_organ?).to(:attendance).with_arguments(allow_nil: true).with_prefix }
    it { is_expected.to delegate_method(:completed?).to(:attendance).with_arguments(allow_nil: true).with_prefix }

    it { is_expected.to delegate_method(:organ).to(:updated_by).with_arguments(allow_nil: true).with_prefix }
    it { is_expected.to delegate_method(:department_organ).to(:updated_by).with_arguments(allow_nil: true).with_prefix }
    it { is_expected.to delegate_method(:title).to(:target_city).with_arguments(allow_nil: true).with_prefix }
    it { is_expected.to delegate_method(:public_ticket).to(:parent).with_arguments(allow_nil: true).with_prefix }
  end

  describe 'helpers' do

    it 'evaluation_average' do
      answer = create(:answer, status: :user_evaluated)
      evaluation = create(:evaluation, answer: answer)
      ticket = create(:ticket, answers: [answer])

      expect(ticket.last_evaluation_average).to eq(evaluation.average)
    end

    it 'unit' do
      ticket.organ = Organ.new
      ticket.subnet = nil

      expect(ticket.unit).to eq(ticket.organ)

      ticket.organ.subnet = true
      ticket.subnet = Subnet.new

      expect(ticket.unit).to eq(ticket.subnet)
    end

    describe 'self.response_deadline' do
      context 'when ticket_type :sou' do
        it { expect(Ticket.response_deadline(:sou)).to eq(Ticket::SOU_DEADLINE) }
      end
      context 'when ticket_type :sic' do
        it { expect(Ticket.response_deadline(:sic)).to eq(Ticket::SIC_DEADLINE) }
      end
    end

    describe 'self.response_extension' do
      context 'when ticket_type :sou' do
        it { expect(Ticket.response_extension(:sou)).to eq(Ticket::SOU_EXTENSION) }
      end
      context 'when ticket_type :sic' do
        it { expect(Ticket.response_extension(:sic)).to eq(Ticket::SIC_EXTENSION) }
      end
    end

    describe 'self.response_extension_days' do
      context 'when ticket_type :sou' do
        it { expect(Ticket.response_extension_days(:sou)).to eq(Ticket::SOU_EXTENSION_DAYS) }
      end
      context 'when ticket_type :sic' do
        it { expect(Ticket.response_extension_days(:sic)).to eq(Ticket::SIC_EXTENSION_DAYS) }
      end
    end

    it 'title' do
      expected = I18n.t('ticket.protocol_title.sou', protocol: ticket.parent_protocol)
      expect(ticket.title).to eq(expected)
    end

    describe 'access_type' do

      it 'anonymous access' do
        ticket.anonymous = true
        expect(ticket.access_type).to eq('anonymous')
      end

      it 'anonymous access' do
        ticket.anonymous = false
        expect(ticket.access_type).to eq('identified')
      end

    end

    describe 'elegible_to_answer' do
      describe 'any user' do
        it 'without classification' do
          ticket = build(:ticket)
          expect(ticket.elegible_to_answer?).to eq(false)
        end
        it 'with classification' do
          ticket = build(:ticket, :with_classification)
          expect(ticket.elegible_to_answer?).to eq(true)
        end
        it 'final_answer' do
          ticket = build(:ticket, :with_classification, internal_status: :final_answer)
          expect(ticket.elegible_to_answer?).to eq(false)
        end
        it 'child sectoral_validation' do
          ticket = build(:ticket, :with_classification, :with_parent, internal_status: :sectoral_validation)
          expect(ticket.elegible_to_answer?).to eq(true)
        end
        it 'subnet child sectoral_validation' do
          ticket = build(:ticket, :with_classification, :with_parent, :with_subnet, internal_status: :sectoral_validation)
          expect(ticket.elegible_to_answer?).to eq(false)
        end
        it 'child subnet_validation' do
          ticket = build(:ticket, :with_classification, :with_parent, internal_status: :subnet_validation)
          expect(ticket.elegible_to_answer?).to eq(true)
        end
        it 'child subnet_attendance' do
          ticket = build(:ticket, :with_classification, :with_parent, internal_status: :subnet_attendance)
          expect(ticket.elegible_to_answer?).to eq(true)
        end
        it 'cge_validation' do
          ticket = build(:ticket, :with_classification, internal_status: :cge_validation)
          expect(ticket.elegible_to_answer?).to eq(false)
        end
        it 'with answer' do
          ticket = build(:ticket, :with_classification, :with_parent)
          create(:answer, :sectoral_approved, ticket: ticket)
          expect(ticket.elegible_to_answer?).to eq(false)
        end
      end

      describe 'internal user' do
        let(:user) { build(:user, :operator_internal) }

        it 'without classification' do
          ticket = build(:ticket)
          expect(ticket.elegible_to_answer?(user)).to eq(true)
        end
        it 'with classification' do
          ticket = build(:ticket, :with_classification)
          expect(ticket.elegible_to_answer?(user)).to eq(true)
        end
        it 'final_answer' do
          ticket = build(:ticket, :with_classification, internal_status: :final_answer)
          expect(ticket.elegible_to_answer?(user)).to eq(false)
        end
        it 'child sectoral_validation' do
          ticket = build(:ticket, :with_classification, :with_parent, internal_status: :sectoral_validation)
          expect(ticket.elegible_to_answer?(user)).to eq(true)
        end
        it 'child subnet_validation' do
          ticket = build(:ticket, :with_classification, :with_parent, internal_status: :subnet_validation)
          expect(ticket.elegible_to_answer?(user)).to eq(true)
        end
        it 'child subnet_attendance' do
          ticket = build(:ticket, :with_classification, :with_parent, internal_status: :subnet_attendance)
          expect(ticket.elegible_to_answer?(user)).to eq(true)
        end
        it 'cge_validation' do
          ticket = build(:ticket, :with_classification, internal_status: :cge_validation)
          expect(ticket.elegible_to_answer?(user)).to eq(false)
        end
        it 'with answer' do
          ticket = build(:ticket, :with_classification, :with_parent)
           create(:answer, :sectoral_approved, ticket: ticket)
          expect(ticket.elegible_to_answer?(user)).to eq(false)
        end
      end
    end

    describe 'parent_no_active_children?' do
      context 'parent with children' do
        let(:ticket) { create(:ticket, :with_parent) }
        let(:ticket_parent) { ticket.parent }

        it { expect(ticket_parent.parent_no_active_children?).to eq(false) }
      end

      context 'without children' do
        let(:ticket) { build(:ticket) }

        it { expect(ticket.parent_no_active_children?).to eq(true) }
      end

      context 'parent with inactive children' do
        let(:ticket) { create(:ticket, :with_parent, internal_status: :final_answer) }
        let(:ticket_parent) { ticket.parent }

        it { expect(ticket_parent.parent_no_active_children?).to eq(true) }
      end
    end

    context 'response_deadline' do
      context 'not in_progress ticket' do
        let(:confirmed_ticket) { create(:ticket, :confirmed) }
        let(:expected) { I18n.l(confirmed_ticket.deadline_ends_at) }

        it { expect(confirmed_ticket.response_deadline).to eq(expected) }
      end

      context 'in_progress ticket' do
        let(:in_progress_ticket) { create(:ticket, :in_progress) }

        it { expect(in_progress_ticket.response_deadline).to eq('-') }
      end
    end

    context 'remaining_days_to_deadline' do
      context 'ticket not in_progress' do
        let(:confirmed_ticket) { create(:ticket, :confirmed) }
        let(:expected) { (confirmed_ticket.deadline_ends_at - Date.today).to_i }

        it { expect(confirmed_ticket.remaining_days_to_deadline).to eq(expected) }
      end

      context 'ticket in_progress' do
        let(:not_confirmed_ticket) { create(:ticket, :in_progress) }

        it { expect(not_confirmed_ticket.remaining_days_to_deadline).to eq('-') }
      end
    end

    context 'child?' do

      let(:ticket_child) { create(:ticket, :with_parent) }
      let(:ticket_parent) { ticket_child.parent }

      context 'true' do
        it { expect(ticket_child.child?).to eq(true) }
      end

      context 'false' do
        it { expect(ticket_parent.child?).to eq(false) }
      end

    end

    context 'parent?' do

      let(:ticket_child) { create(:ticket, :with_parent) }
      let(:ticket_parent) { ticket_child.parent }

      context 'true' do
        it { expect(ticket_parent.parent?).to eq(true) }
      end

      context 'false' do
        it { expect(ticket_child.parent?).to eq(false) }
      end

    end

    context 'shared?' do
      let(:ticket_child) { create(:ticket, :with_parent) }
      let(:ticket_parent) { ticket_child.parent }

      context 'true' do
        before { create(:ticket, :with_parent, :replied, parent: ticket_parent) }

        it { expect(ticket_parent.shared?).to eq(true) }
        it { expect(ticket_child.shared?).to eq(true) }
      end

      context 'false' do
        before { create(:ticket, :with_parent, :invalidated, parent: ticket_parent) }

        it { expect(ticket_parent.shared?).to eq(false) }
        it { expect(ticket_child.shared?).to eq(false) }
      end
    end

    context 'all_active_children_classified?' do
      it 'no classified' do
        child = create(:ticket, :with_parent)
        parent = child.parent
        create(:ticket, :with_parent, :invalidated, parent: parent)

        expect(parent.all_active_children_classified?).to be_falsey
      end

      it 'child classified' do
        child = create(:ticket, :with_parent, :with_classification)
        parent = child.parent
        create(:ticket, :with_parent, :invalidated, parent: parent)

        expect(child.all_active_children_classified?).to be_truthy
      end

      it 'only parent classified' do
        inactive_child = create(:ticket, :with_parent, :invalidated)
        parent = inactive_child.parent

        parent.update_attributes(classified: true)

        expect(parent.all_active_children_classified?).to be_truthy
      end

      it 'one child classified' do
        first_child = create(:ticket, :with_parent, :with_classification)
        parent = first_child.parent
        second_child = create(:ticket, :with_parent)
        second_child.update_attributes(parent: parent)
        create(:ticket, :with_parent, :invalidated, parent: parent)

        expect(parent.all_active_children_classified?).to be_falsey
      end

      it 'all active children classified' do
        first_child = create(:ticket, :with_parent, :with_classification)
        parent = first_child.parent
        second_child = create(:ticket, :with_classification)
        second_child.update_attributes(parent: parent)
        create(:ticket, :with_parent, :invalidated, parent: parent)

        expect(parent.all_active_children_classified?).to be_truthy
      end
    end

    context 'any_children_classified?' do
      let(:ticket) { create(:ticket) }
      let(:child_1) { create(:ticket, :with_classification, :with_parent, parent: ticket) }
      let(:child_2) { create(:ticket, :with_parent, parent: ticket) }

      let(:other) { create(:ticket) }
      let(:other_child) { create(:ticket, :with_parent, parent: other) }

      before do
        child_1
        child_2
        other_child
      end

      it { expect(ticket.any_children_classified?).to be_truthy }
      it { expect(other.any_children_classified?).to be_falsey }
    end

    context 'no_children?' do

      let(:ticket_child) { create(:ticket, :with_parent) }
      let(:ticket_parent) { ticket_child.parent }
      let(:ticket_single) { create(:ticket, :with_parent) }

      context 'true' do
        it { expect(ticket_child.no_children?).to eq(true) }
        it { expect(ticket_single.no_children?).to eq(true) }
      end

      context 'false' do
        it { expect(ticket_parent.no_children?).to eq(false) }
      end

      context 'ignore not active tickets when internal_status' do

        let(:ticket_parent) { create(:ticket) }

        context 'in_filling' do
          let!(:ticket_ignored) { create(:ticket, :with_parent, parent: ticket_parent, internal_status: :in_filling) }

          it { expect(ticket_parent.no_active_children?).to eq(true) }
        end

        context 'invalidated' do
          let!(:ticket_ignored) { create(:ticket, :with_parent, parent: ticket_parent, internal_status: :invalidated) }

          it { expect(ticket_parent.no_active_children?).to eq(true) }
        end

        context 'final_answer' do
          let!(:ticket_ignored) { create(:ticket, :with_parent, parent: ticket_parent, internal_status: :final_answer) }

          it { expect(ticket_parent.no_active_children?).to eq(true) }
        end
      end
    end

    describe '#no_answers?' do
      let(:ticket_child) { create(:ticket, :with_parent, :with_classification) }

      context 'when ticket hasnt a answer' do
        it 'return true' do
          expect(ticket_child.no_answers?).to be_truthy
        end
      end

      context 'when ticket has a answer' do
        it 'return false' do
          create(:answer, :cge_approved, version: 1, ticket_id: ticket_child.id)
          expect(ticket_child.no_answers?).to be_falsey
        end
      end


    end

    it 'denunciation_assurance_str' do
      # helper para poder ser usado com content_with_label(ticket, :denunciation_assurance_str)

      expected = Ticket.human_attribute_name("denunciation_assurance.#{ticket_denunciation.denunciation_assurance}")
      expect(ticket_denunciation.denunciation_assurance_str).to eq(expected)
    end

    it 'denunciation_description_str' do
      # helper para poder ser usado com content_with_label(ticket, :denunciation_description_str)

      expected = ticket_denunciation.denunciation_description
      expect(ticket_denunciation.denunciation_description_str).to eq(expected)
    end

    it 'denunciation_date_str' do
      # helper para poder ser usado com content_with_label(ticket, :denunciation_date_str)

      expected = ticket_denunciation.denunciation_date
      expect(ticket_denunciation.denunciation_date_str).to eq(expected)
    end

    it 'denunciation_place_str' do
      # helper para poder ser usado com content_with_label(ticket, :denunciation_place_str)

      expected = ticket_denunciation.denunciation_place
      expect(ticket_denunciation.denunciation_place_str).to eq(expected)
    end

    it 'denunciation_witness_str' do
      # helper para poder ser usado com content_with_label(ticket, :denunciation_witness_str)

      expected = ticket_denunciation.denunciation_witness
      expect(ticket_denunciation.denunciation_witness_str).to eq(expected)
    end

    it 'denunciation_evidence_str' do
      # helper para poder ser usado com content_with_label(ticket, :denunciation_evidence_str)

      expected = ticket_denunciation.denunciation_evidence
      expect(ticket_denunciation.denunciation_evidence_str).to eq(expected)
    end

    context 'create_ticket_child' do

      let(:ticket) { create(:ticket, :with_organ, :with_classification) }
      let(:child) { ticket.tickets.first }
      let(:classification) { ticket.classification }

      it 'creates for non_subnet organs' do
        classification

        ticket.create_ticket_child

        expect(ticket.classified).to eq(false)
        expect(ticket.classification).to be_nil
        expect(ticket.organ).to be_nil
        expect(ticket.unknown_organ).to eq(true)
        expect(ticket.tickets.count).to eq(1)

        expect(ticket.protocol).not_to eq(child.protocol)

        expect(child.classification).to eq(classification)
      end

      it 'does create for subnet organs' do
        ticket.organ.subnet = true
        ticket.unknown_subnet = true
        ticket.organ.save

        expect do
          ticket.create_ticket_child
        end.to change(Ticket, :count).by(1)
      end

      it 'creates for subnet organs if subnet exists' do
        classification
        organ = ticket.organ
        subnet = create(:subnet, organ: ticket.organ)
        ticket.subnet = subnet
        ticket.internal_status = :sectoral_attendance
        ticket.save

        ticket.create_ticket_child

        expect(ticket.classified).to eq(false)
        expect(ticket.classification).to be_nil
        expect(ticket.organ).to be_nil
        expect(ticket.unknown_organ).to eq(true)
        expect(ticket.subnet).to be_nil
        expect(ticket.unknown_subnet).to eq(true)
        expect(ticket.tickets.count).to eq(1)

        expect(ticket.protocol).not_to eq(child.protocol)

        expect(child.classification).to eq(classification)
        expect(child.organ).to eq(organ)
        expect(child.subnet).to eq(subnet)
        expect(child).to be_subnet_attendance
      end

      context 'public_ticket' do
        let(:ticket) { create(:ticket, :sic, :with_organ, public_ticket: true) }
        let(:child) { ticket.tickets.first }

        before do
          ticket.create_ticket_child
          ticket.reload
        end

        it { expect(child.public_ticket).to be_falsey }
      end

      context 'with immediate answer' do
        let(:immediate_answer) { build_list(:answer, 1) }
        let(:organ) { create(:executive_organ) }
        let(:created_by) { create(:user, :operator_sectoral, organ: organ) }
        let(:ticket) { create(:ticket, :with_organ, :with_classification, organ: organ, created_by: created_by, immediate_answer: '1', answers: immediate_answer) }
        let(:service) { double }

        let(:child) { ticket.tickets.first }
        let(:answer) { child.answers.first }

        before do
          allow(Answer::CreationService).to receive(:new) { service }
          allow(service).to receive(:call)
          allow(RegisterTicketLog).to receive(:call)

          ticket.create_ticket_child
          ticket.reload
        end

        it { expect(ticket.answers).to be_blank }
        it { expect(child).to be_present }
        it { expect(answer).to be_present }
        it { expect(answer.ticket).to eq(child) }

        it 'invoke answer service' do
          expect(Answer::CreationService).to have_received(:new).with(answer, created_by)
          expect(service).to have_received(:call)
        end

        it 'register log' do
          user = ticket.created_by
          expect(RegisterTicketLog).to have_received(:call).with(ticket, user, :create_classification, { resource: child })
          expect(RegisterTicketLog).to have_received(:call).with(child, user, :create_classification, { resource: child })
        end
      end

      context 'with priority' do
        let(:ticket) { create(:ticket, :with_organ, priority: true) }
        let(:child) { ticket.tickets.first }

        before do
          allow(RegisterTicketLog).to receive(:call)

          ticket.create_ticket_child
          ticket.reload
        end

        it 'register log' do
          expect(RegisterTicketLog).to have_received(:call).with(child, ticket, :priority, { resource: child })
        end
      end
    end

    context 'ticket_department_by_user' do
      let(:ticket) { create(:ticket) }
      let(:ticket_department) { create(:ticket_department, ticket: ticket) }
      let(:other_ticket_department) { create(:ticket_department, ticket: ticket) }
      let(:department) { ticket_department.department }
      let(:user) { create(:user, :operator_internal, department: department, organ: department.organ)}

      it { expect(ticket.ticket_department_by_user(user)).to eq(ticket_department) }
    end

    describe 'elegible_organ_to_extension?' do
      let(:ticket) { create(:ticket, :with_parent) }

      it 'in_progress' do
        create(:extension, ticket: ticket, status: :in_progress)
        expect(ticket.elegible_organ_to_extension?).to be_falsey
      end

      it 'approved' do
        create(:extension, ticket: ticket, status: :approved)
        expect(ticket.elegible_organ_to_extension?).to be_falsey
      end

      it 'rejected' do
        create(:extension, ticket: ticket, status: :rejected)
        expect(ticket.elegible_organ_to_extension?).to be_truthy
      end

      it 'cancelled' do
        create(:extension, ticket: ticket, status: :cancelled)
        expect(ticket.elegible_organ_to_extension?).to be_truthy
      end

      context 'reopened' do
        before do
          ticket.reopened_at = Date.today
          ticket.save
        end

        it 'in_progress' do
          create(:extension, ticket: ticket, status: :in_progress)
          expect(ticket.elegible_organ_to_extension?).to be_falsey
        end

        it 'approved' do
          create(:extension, ticket: ticket, status: :in_progress, updated_at: 2.days.ago)
          create(:extension, ticket: ticket, status: :approved)
          expect(ticket.elegible_organ_to_extension?).to be_falsey
        end

        it 'rejected' do
          create(:extension, ticket: ticket, status: :in_progress, updated_at: 2.days.ago)
          create(:extension, ticket: ticket, status: :rejected)
          expect(ticket.elegible_organ_to_extension?).to be_truthy
        end

        it 'cancelled' do
          create(:extension, ticket: ticket, status: :in_progress, updated_at: 2.days.ago)
          create(:extension, ticket: ticket, status: :cancelled)
          expect(ticket.elegible_organ_to_extension?).to be_truthy
        end

      end
    end

    describe '#elegible_organ_to_approve_reject_or_cancel_second_extension?' do
      context 'on first solicitation' do
        let(:ticket) { create(:ticket, :with_parent) }
        context 'when ticket has a progress extension' do
          it 'return false' do
            create(:extension, ticket: ticket, status: :approved)
            expect(ticket.elegible_organ_to_approve_reject_or_cancel_second_extension?).to be_falsey
          end
        end

        context 'when ticket hasnt a progress extension' do
          it 'return false' do
            create(:extension, ticket: ticket, status: :in_progress)
            expect(ticket.elegible_organ_to_approve_reject_or_cancel_second_extension?).to be_falsey
          end
        end
      end

      context 'on second solicitation' do
        let(:ticket_with_extension) { create(:ticket, :with_extension) }
        context 'when ticket has a progress extension' do
          it 'return true' do
            create(:extension, ticket: ticket_with_extension, status: :approved, solicitation: 2)
            expect(ticket_with_extension.elegible_organ_to_approve_reject_or_cancel_second_extension?).to be_falsey
          end
        end

        context 'when ticket hasnt a progress extension' do
          it 'return true' do
            create(:extension, ticket: ticket_with_extension, status: :in_progress, solicitation: 2)
            expect(ticket_with_extension.elegible_organ_to_approve_reject_or_cancel_second_extension?).to be_truthy
          end
        end
      end
    end

    describe '#next_extension_number' do
      context 'when ticket was extended' do
        it 'return 2' do
          ticket_with_extension = create(:ticket, :with_extension)
          expect(ticket_with_extension.next_extension_number).to eq(2)
        end
      end

      context 'when ticket havent a extension' do
        it 'return 1' do
          ticket = create(:ticket)
          expect(ticket.next_extension_number).to eq(1)
        end
      end
    end

    describe '#tickets_organ_extension_approved' do
      let(:ticket) { create(:ticket, :with_parent) }

      context 'on first solicitation' do
        context 'when ticket has a approved extension' do
          it 'return approved tickets' do
            create(:extension, ticket: ticket, status: :approved)
            expect(ticket.tickets_organ_extension_approved.count).to eq(1)
          end
        end

        context 'when ticket hasnt a approved extension' do
          it 'return empty' do
            create(:extension, ticket: ticket, status: :in_progress)
            expect(ticket.tickets_organ_extension_approved).to eq([])
          end
        end
      end

      context 'on second solicitation' do
        context 'when ticket has a second approved extension' do
          it 'return approved tickets' do
            create(:extension, ticket: ticket, status: :approved, solicitation: 2)
            expect(ticket.tickets_organ_extension_approved(2).count).to eq(1)
          end
        end

        context 'when ticket hasnt a approved extension' do
          it 'return empty' do
            create(:extension, ticket: ticket, status: :in_progress, solicitation: 2)
            expect(ticket.tickets_organ_extension_approved(2)).to eq([])
          end
        end
      end
    end

    describe 'elegible_organ_to_cancel_extension?' do
      let(:ticket) { create(:ticket, :with_parent) }

      it 'in_progress' do
        create(:extension, ticket: ticket, status: :in_progress)
        expect(ticket.elegible_organ_to_cancel_extension?).to be_truthy
      end

      it 'approved' do
        create(:extension, ticket: ticket, status: :approved)
        expect(ticket.elegible_organ_to_cancel_extension?).to be_falsey
      end
    end

    context 'expired?' do
      it 'true' do
        ticket.deadline = -1

        expect(ticket.expired?).to be_truthy
      end

      it 'false' do
        ticket.deadline = 1

        expect(ticket.expired?).to be_falsey
      end
    end

    # XXX: Somente SIC estão liberados para ser públicos até a decisão da CGE
    context 'eligible_to_publish?' do
      context 'sic' do
        let(:ticket) { create(:ticket, :sic) }

        it { expect(ticket.eligible_to_publish?).to be_truthy }
      end

      context 'sou' do
        let(:ticket) { create(:ticket) }

        it { expect(ticket.eligible_to_publish?).to be_falsey }

        # context 'denunciation' do
        #   let(:ticket) { create(:ticket, :denunciation) }

        #   it { expect(ticket.eligible_to_publish?).to be_falsey }
        # end

        # context 'anonymous' do
        #   let(:ticket) { create(:ticket, :anonymous) }

        #   it { expect(ticket.eligible_to_publish?).to be_falsey }
        # end
      end
    end

    context 'organ_can_be_evaluated' do
      it 'true' do
        ticket = create(:ticket, :with_organ, :replied, internal_status: :final_answer)

        expect(ticket.organ_can_be_evaluated?).to be_truthy
      end

       it 'false without organ' do
        ticket = create(:ticket, :replied, internal_status: :final_answer)

        expect(ticket.organ_can_be_evaluated?).to be_falsey
      end

      it 'false not replied' do
        ticket = create(:ticket, internal_status: :final_answer)

        expect(ticket.organ_can_be_evaluated?).to be_falsey
      end

      it 'false not final_answer' do
        ticket = create(:ticket,:replied)

        expect(ticket.organ_can_be_evaluated?).to be_falsey
      end

      it 'false with child' do
        ticket_child = create(:ticket, :with_parent, :replied, internal_status: :final_answer)
        ticket = ticket_child.parent

        expect(ticket.organ_can_be_evaluated?).to be_falsey
      end
    end

    context 'ticket_open' do
      it 'true' do
        ticket_open = build(:ticket, :confirmed, internal_status: :sectoral_attendance)

        expect(ticket_open.open?).to be_truthy
      end

      context 'false' do
        it 'finalized' do
          ticket_finalized = build(:ticket, :confirmed, internal_status: :final_answer)

          expect(ticket_finalized.open?).to be_falsey
        end

        it 'invalidated' do
          ticket_invalidated = build(:ticket, :confirmed, internal_status: :invalidated)

          expect(ticket_invalidated.open?).to be_falsey
        end
      end
    end

    describe '#as_author' do
      subject { ticket.as_author }

      context 'when ticket is created by an unregistered anonymous user' do
        let(:ticket) { create :ticket, :anonymous }

        it { is_expected.to eq I18n.t('messages.comments.anonymous_user') }
      end

      context 'when ticket is created by an unregistered identified user' do
        context 'when identified user supplied his/her social name' do
          let(:ticket) { create :ticket, :identified, social_name: 'Xororó', name: 'Durval de Lima' }

          it { is_expected.to eq 'Xororó'}
        end

        context 'when identified user supplied only his/her name (not social name)' do
          let(:ticket) { create :ticket, :identified, social_name: '', name: 'Durval de Lima' }

          it { is_expected.to eq 'Durval de Lima' }
        end
      end

      context 'when ticket is created by a registered user' do
        let(:ticket) { create :ticket, :from_registered_user }
        let(:user) { ticket.created_by }

        it { is_expected.to eq user.as_author }
      end
    end

    context 'active?' do
      # inactive tickets
      let(:ticket_in_progess) { create(:ticket, :in_progress) }
      let(:ticket_finalized) { create(:ticket, :replied) }
      let(:ticket_invalidated) { create(:ticket, :invalidated) }
      let(:ticket_nil_internal_status) { create(:ticket, internal_status: nil) }

      it 'not active' do
        expect(ticket_in_progess.active?).to be_falsey
        expect(ticket_finalized.active?).to be_falsey
        expect(ticket_invalidated.active?).to be_falsey
        expect(ticket_nil_internal_status.active?).to be_falsey
      end

      it 'check inactive statuses' do
        inactive_statuses = [:in_filling, :invalidated, :final_answer]

        expect(Ticket::INACTIVE_STATUSES).to eq(inactive_statuses)
      end

    end

    context 'can_ignore_cge_validation?' do
      it 'default' do
        expect(ticket.can_ignore_cge_validation?).to be_falsey
      end
      it 'with organ ignore true ' do
        organ = create(:executive_organ, ignore_cge_validation: true)
        ticket = create(:ticket, :with_organ, organ: organ)
        expect(ticket.can_ignore_cge_validation?).to be_truthy
      end
      it 'denunciation with organ ignore true ' do
        organ = create(:executive_organ, ignore_cge_validation: true)
        ticket = create(:ticket, :with_organ, :denunciation, organ: organ)

        expect(ticket.can_ignore_cge_validation?).to be_falsey
      end
    end

    context 'can_extend?' do
      it 'false, more than limit' do
        ticket_not_extended = create(:ticket, :confirmed)
        deadline = Holiday.next_weekday(Ticket::LIMIT_TO_EXTEND_DEADLINE, ticket_not_extended.confirmed_at)

        deadline += 1 # deixando a data fora do período

        date = Date.today + deadline.days

        allow(Date).to receive(:today) { date }

        expect(ticket_not_extended.can_extend_deadline?).to be_falsey
      end

      it 'true, equals limit' do
        in_limit = DateTime.now - Ticket::LIMIT_TO_EXTEND_DEADLINE.days
        ticket_can_extended = create(:ticket, :with_organ, confirmed_at: in_limit)

        expect(ticket_can_extended.can_extend_deadline?).to be_truthy
      end

      it 'true, in limit' do
        in_limit = DateTime.now - (Ticket::LIMIT_TO_EXTEND_DEADLINE - 1).days
        ticket_can_extended = create(:ticket, :with_organ, confirmed_at: in_limit)

        expect(ticket_can_extended.can_extend_deadline?).to be_truthy
      end

      it 'true, in limit when reopened' do
        in_limit = DateTime.now - (Ticket::LIMIT_TO_EXTEND_DEADLINE - 1).days
        ticket_can_extended = create(:ticket, :with_reopen, confirmed_at: 2.months.ago.to_date, reopened_at: in_limit)

        expect(ticket_can_extended.can_extend_deadline?).to be_truthy
      end
    end
  end # helpers

  describe 'callbacks' do
    context 'before_validation' do
      it { is_expected.to callback(:clear_organ_if_unknown_organ).before(:validation) }

      it 'clears organ if unknown_organ is true' do
        ticket.organ = Organ.new
        ticket.unknown_organ = true
        ticket.valid?

        expect(ticket.organ).to be_blank
      end

      it 'clears subnet if unknown_subnet is true' do
        ticket.subnet = Subnet.new
        ticket.unknown_subnet = true
        ticket.valid?

        expect(ticket.subnet).to be_blank
      end

      context 'clears classification if unknown_classification is true' do
        it 'without classification persisted' do
          ticket.classification = Classification.new
          ticket.unknown_classification = true

          ticket.valid?

          expect(ticket.classification).to be_blank
        end

        it 'with classification persisted' do
          ticket = create(:ticket, :with_classification)
          ticket.unknown_classification = true

          ticket.valid?

          expect(ticket.classification).to be_present
        end
      end

      context 'set answer_type default when anonymous' do
        it 'ticket anonymous' do
          ticket = build(:ticket, :anonymous, answer_type: nil)

          ticket.valid?

          expect(ticket.answer_type).to eq('default')
        end

        it 'ticket identified' do
          ticket = build(:ticket, :identified, answer_type: nil)

          ticket.valid?

          expect(ticket.answer_type).to eq(nil)
        end
      end
    end

    context 'after_create' do
      let(:parent) { create(:ticket) }
      let(:child) { create(:ticket, :with_parent, parent: parent) }

      context 'create parent protocol' do
        it { is_expected.to callback(:create_parent_protocol).after(:create) }

        it 'parent' do
          expect(parent.parent_protocol).to eq(parent.protocol.to_s)
        end

        it 'child ' do
          expect(child.parent_protocol).to eq(parent.protocol.to_s)
        end
      end
    end

    context 'after_commit' do

      context 'update :published attribute' do

        let(:ticket) { create(:ticket, :sic, :confirmed, public_ticket: true) }
        let(:child) { create(:ticket, :sic, :with_parent, parent: ticket) }

        context 'when child' do
          before { child }

          context 'whithout classification' do
            it { expect(child.reload.published).to be_falsey }
            it { expect(ticket.reload.published).to be_falsey }
          end

          context 'with classification' do
            let(:child) { create(:ticket, :sic, :with_parent, :with_classification, parent: ticket) }

            it { expect(child.reload.published).to be_falsey }
            it { expect(ticket.reload.published).to be_truthy }
          end
        end

        context 'when parent' do

          context 'without any children classified' do

            before { child }

            context 'public_ticket = false' do
              let(:ticket) { create(:ticket, :confirmed, public_ticket: false) }

              it { expect(ticket.reload.published).to be_falsey }
            end

            context 'public_ticket = true' do

              context 'not classified' do
                let(:ticket) { create(:ticket, :confirmed, :sic, public_ticket: true) }

                it { expect(ticket.reload.published).to be_falsey }
              end

              context 'classified' do
                let(:ticket) { create(:ticket, :sic, :confirmed, :with_classification, public_ticket: true) }

                it { expect(ticket.reload.published).to be_truthy }
              end

            end
          end

          context 'with any child set public_ticket = true' do

            let(:child_public) { create(:ticket, :with_parent, parent: ticket, public_ticket: true) }
            let(:child_non_public) { create(:ticket, :with_parent, parent: ticket, public_ticket: false) }

            before do
              child_public
              child_non_public
            end

            context 'public_ticket = false' do
              let(:ticket) { create(:ticket, :confirmed, public_ticket: false) }

              it { expect(ticket.reload.published).to be_falsey }
            end

            context 'public_ticket = true' do
              let(:ticket) { create(:ticket, :sic, :confirmed, public_ticket: true) }

              it { expect(ticket.reload.published).to be_truthy }
            end
          end
        end
      end
    end
  end

  it 'children_from_executive_power' do
    ticket_parent = create(:ticket)
    ticket_from_executive_power = create(:ticket, :with_parent, parent: ticket_parent)
    ticket_from_rede_ouvir = create(:ticket, :with_parent, parent: ticket_parent, organ: create(:rede_ouvir_organ))

    expect(ticket_parent.children_from_executive_power).to eq([ticket_from_executive_power])
  end

  describe 'attachments accepts_nested_attributes_for' do
    let(:ticket) { build(:ticket) }
    let(:attachment) { build(:attachment) }
    let(:document) { Refile::FileDouble.new("test", "logo.png", content_type: "image/png") }

    it 'with document' do
      ticket.assign_attributes( { attachments_attributes: [ { document: document } ] } )

      ticket.save

      expect(ticket.attachments.count).to eq 1
    end

    it 'with blank document' do
      ticket.assign_attributes( { attachments_attributes: [ document: '{}' ] } )

      ticket.save

      expect(ticket.attachments.count).to eq 0
    end
  end

  describe '#within_share_deadline' do
    context 'when date param is older than share prize' do
      it 'return false' do
        expect(Ticket.within_share_deadline?(10.days.ago)).to be_falsey
      end
    end

    context 'when date param is equal or younger than 5 days ago' do
      it 'return false' do
        expect(Ticket.within_share_deadline?(5.days.ago)).to be_truthy
      end
    end

    context 'when date param is today' do
      it 'return true' do
        expect(Ticket.within_share_deadline?(Date.today)).to be_truthy
      end
    end
  end

  describe '#has_attribute_protected_attachment' do
    context 'when has ticket_attachment_protected' do
      context 'when attachment attribute param exist' do
        it 'return true' do
          ticket_protect_attachment = create(:ticket_protect_attachment)
          ticket = ticket_protect_attachment.resource
          ticket.protected_attachment_ids = [ticket_protect_attachment.attachment_id]
          expect(ticket.has_attribute_protected_attachment(ticket_protect_attachment.attachment_id)).to eq(true)
        end
      end

      context 'when attachment attribute param is not associated' do
        it 'return false' do
          ticket_protect_attachment = create(:ticket_protect_attachment)
          ticket = ticket_protect_attachment.resource
          ticket.protected_attachment_ids = [ticket_protect_attachment.attachment_id]
          expect(ticket.has_attribute_protected_attachment(ticket_protect_attachment.attachment_id + 1)).to eq(false)
        end
      end

      context 'when protected_attachment attribute not exist' do
        it 'return nil' do
          ticket_protect_attachment = create(:ticket_protect_attachment)
          ticket = ticket_protect_attachment.resource
          expect(ticket.has_attribute_protected_attachment(ticket_protect_attachment.attachment_id + 1)).to be_nil
        end
      end
    end

    context 'when hasnt ticket_attachment_protected' do
      it 'return false' do
        ticket = create(:ticket)
        expect(ticket.has_attribute_protected_attachment(1)).to eq(nil)
      end
    end
  end

  describe '#ticket_logs_reopened_by_range' do
    context 'when exist reopen ticket log in range' do
      it 'return ticket_logs' do
        ticket_log = create(:ticket_log, :reopened)
        ticket = ticket_log.ticket
        expect(ticket.ticket_logs_reopened_by_range(Date.today..Date.today.end_of_month)).to eq([ticket_log])
      end
    end

    context 'when not exist ticket log in range' do
      it 'return existent ticket_log' do
        ticket_log = create(:ticket_log, :reopened)
        ticket = ticket_log.ticket
        expect(ticket.ticket_logs_reopened_by_range).to eq([ticket_log])
      end
    end

    context 'when ticket log is not reopened' do
      it 'return empty' do
        ticket_log = create(:ticket_log, :forward)
        ticket = ticket_log.ticket
        expect(ticket.ticket_logs_reopened_by_range(Date.today..Date.today.end_of_month)).to eq([])
      end
    end
  end

  describe '#reopen_pseudo_time_in_days' do
    context 'when ticket have reopened' do
      context 'when ticket have associated version answer' do
        it 'return time_in_days' do
          ticket_organ = create(:ticket, :with_reopen_and_log)
          ticket_parent = ticket_organ
          ticket_with_pseudo_reopened = create(:ticket, :with_organ, :confirmed, parent_id: ticket_parent.id, confirmed_at: Date.yesterday)
          create(:answer, :cge_approved, version: 1, ticket_id: ticket_with_pseudo_reopened.id)

          expect(ticket_with_pseudo_reopened.reopen_pseudo_time_in_days).to eq(1)
        end
      end

      context 'when ticket havent associated answer' do
        it 'return zero' do
          ticket_organ = create(:ticket, :with_reopen_and_log)
          ticket_parent = ticket_organ
          ticket_with_pseudo_reopened = create(:ticket, :with_organ, :confirmed, parent_id: ticket_parent.id)
          create(:answer, :cge_approved, version: 1, ticket_id: ticket_with_pseudo_reopened.id)

          expect(ticket_with_pseudo_reopened.reopen_pseudo_time_in_days).to eq(0)
        end
      end
    end
  end

  describe '#average_days_spent_to_answer' do
    context 'when havent a reopening' do
      context 'when have an answer a day before the ticket creation' do
        context 'when in date range' do
          it 'return 1 day' do
            ticket = create(:ticket, :with_organ, :confirmed, confirmed_at: Date.yesterday)
            create(:answer, :cge_approved, ticket_id: ticket.id)
            ticket.internal_status = :final_answer
            date_range = ticket.confirmed_at.beginning_of_day..ticket.confirmed_at.end_of_day
            expect(ticket.average_days_spent_to_answer(date_range)).to eq(1)
          end
        end

        context 'when out of reopening daterange' do
          it 'return 1 day' do
            ticket = create(:ticket, :with_organ, :confirmed, confirmed_at: Date.yesterday)
            create(:answer, :cge_approved, ticket_id: ticket.id)
            ticket.internal_status = :final_answer
            date_range = ticket.confirmed_at.tomorrow.beginning_of_day..ticket.confirmed_at.tomorrow.end_of_day
            expect(ticket.average_days_spent_to_answer(date_range)).to eq(1)
          end
        end
      end

      context 'when havent an answer' do
        it 'return 0 days' do
          ticket = create(:ticket, :with_organ, :confirmed, confirmed_at: Date.yesterday)
          date_range = ticket.confirmed_at.beginning_of_day..ticket.confirmed_at.end_of_day
          expect(ticket.average_days_spent_to_answer(date_range)).to eq(0)
        end
      end
    end

    context 'when have a reopening' do
      context 'when have a reopen a week ago until finish the ticket' do
        context 'when have a reopen answer after 7 days' do
          it 'return 3 days spent' do
            ticket_organ = create(:ticket, :confirmed, :with_reopen_and_log)
            date_range = ticket_organ.confirmed_at.weeks_ago(1)..ticket_organ.confirmed_at.end_of_day

            create(:answer, :with_cge_approved_partial_answer, ticket_id: ticket_organ.id, version: 1, created_at: ticket_organ.created_at + 7.days)

            expect(ticket_organ.average_days_spent_to_answer(date_range)).to eq(3)
          end
        end

        context 'when have a reopen answer after 8 days' do
          it 'return 4 days spent' do
            ticket_organ = create(:ticket, :confirmed, :with_reopen_and_log)
            date_range = ticket_organ.confirmed_at.weeks_ago(1)..ticket_organ.confirmed_at.end_of_day

            create(:answer, :with_cge_approved_partial_answer, ticket_id: ticket_organ.id, version: 1, created_at: ticket_organ.created_at + 8.days)

            expect(ticket_organ.average_days_spent_to_answer(date_range)).to eq(4)
          end
        end
      end

      context 'when have a pseudo reopened' do
        context 'when not have ticket version 0' do
          it 'return 8 days spent' do
            user = create :user, :user, name: 'Usuário específico'
            ticket_organ = create(:ticket, :with_reopen_and_log)
            ticket_parent = ticket_organ
            ticket_with_pseudo_reopened = create(:ticket, :confirmed, :with_organ, parent_id: ticket_parent.id, reopened: 1, reopened_at: Date.today, created_by: user)
            create(:answer, :cge_approved, version: 1, ticket_id: ticket_with_pseudo_reopened.id, created_at: ticket_with_pseudo_reopened.created_at + 8.days)
            expect(ticket_with_pseudo_reopened.average_days_spent_to_answer).to eq(8)
          end
        end
      end

      context 'when ticket not confirmed' do
        it 'return 0 days spent' do
          ticket_organ = create(:ticket, :with_organ)
          expect(ticket_organ.average_days_spent_to_answer).to eq(0)
        end
      end
    end
  end

  describe '#create_attachment_protection' do
    context 'when has attachments making a association' do
      it 'create ticket_protect_attachment' do
        expect do
          ticket = create(:ticket)
          create(:attachment, attachmentable: ticket)
          create(:attachment, attachmentable: ticket)
          new_ticket = create(:ticket, :with_organ, parent_id: ticket.id, protected_attachment_ids: ticket.attachment_ids)
        end.to change(TicketProtectAttachment, :count).by(2)
      end
    end
  end

  describe '#first_version_answer' do
    context 'when have an answer' do
      context 'when have version is 0' do
        it 'return first answer' do
          first_answer = create(:answer, :with_cge_approved_partial_answer)
          ticket = first_answer.ticket
          second_answer = create(:answer, :with_cge_approved_final_answer, ticket_id: ticket.id)
          third_answer = create(:answer, :with_cge_approved_final_answer, version: 1, ticket_id: ticket.id)

          expect(ticket.first_version_answer).to eq(first_answer)
        end
      end

      context 'when have only version 1' do
        it 'no answer return' do
          ticket_organ = create(:ticket, :with_reopen_and_log)
          ticket_parent = ticket_organ
          ticket_with_pseudo_reopened = create(:ticket, :with_organ, parent_id: ticket_parent.id)
          create(:answer, :cge_approved, version: 1, ticket_id: ticket_with_pseudo_reopened.id)
          expect(ticket_with_pseudo_reopened.first_version_answer).to eq(nil)
        end
      end
    end

    context 'when havent an answer' do
      it 'return nil' do
        ticket = create(:ticket)
        ticket_organ = create(:ticket, :with_reopen_and_log)
        ticket_parent = ticket_organ
        ticket_with_pseudo_reopened = create(:ticket, :with_organ, parent_id: ticket_parent.id)
        expect(ticket.first_version_answer).to eq(nil)
      end
    end
  end

  describe '#create_pseudo_reopen_ticket_log' do
    let(:user) { create :user, :user, name: 'Usuário específico' }

    context 'when have a pseudo reopen after_create' do
      it 'pseudo_reopen is set true' do
        ticket_parent = create(:ticket, :with_reopen_and_log)
        ticket_with_pseudo_reopened = create(:ticket, :with_organ, parent_id: ticket_parent.id, created_by: user)
        expect(ticket_with_pseudo_reopened.pseudo_reopen).to eq(true)
      end

      it 'create a pseudo_reopen ticket_log' do
        ticket_parent = create(:ticket, :with_reopen_and_log)
        ticket_with_pseudo_reopened = create(:ticket, :with_organ, parent_id: ticket_parent.id, created_by: user)
        expect(ticket_with_pseudo_reopened.ticket_logs.where(action: :pseudo_reopen).count).to eq(1)
      end

      context 'when ticket is a parent' do
        it 'not created a pseudo_reopen ticket_log' do
          ticket_organ = create(:ticket, :with_reopen_and_log, created_by: user)
          expect(ticket_organ.parent.ticket_logs.where(action: :pseudo_reopen)).to eq([])
        end
      end

      context 'when ticket is a child but not a pseudo_reopen' do
        it 'not created a pseudo_reopen ticket_log' do
          ticket_organ = create(:ticket, :with_reopen_and_log)
          expect(ticket_organ.ticket_logs.where(action: :pseudo_reopen)).to eq([])
        end
      end
    end

    context 'when havent a pseudo reopen' do
      it 'pseudo_reopen is set false' do
        ticket_organ = create(:ticket, :with_reopen_and_log)
        expect(ticket_organ.pseudo_reopen).to eq(false)
      end
    end
  end

  describe '#reopened_without_organ?' do
    context 'when ticket is parent and reopened without organ' do
      it 'return true' do
        ticket = create(:ticket, :reopened_without_organ)
        expect(ticket.reopened_without_organ?).to eq(true)
      end
    end
  end

  describe '#define_marked_internal_evaluation' do
    context 'when ticket is created' do
      it 'marked_internal_evaluation is set false' do
        ticket = create(:ticket)
        expect(ticket.marked_internal_evaluation).to be_falsey
      end
    end
  end

  describe '#define_decrement_deadline' do
    context 'when ticket is created' do
      it 'decrement_deadline flag is defined with true' do
        ticket = create(:ticket)
        expect(ticket.decrement_deadline).to be_truthy
      end
    end
  end

  describe '#update_decrement_deadline' do
    context 'when ticket status changed to one of the INTERNAL_STATUSES_TO_LOCK_DEADLINE' do
      it 'decrement_deadline is set to false' do
        ticket = create(:ticket)

        Ticket::INTERNAL_STATUSES_TO_LOCK_DEADLINE.each do |internal_status|
          ticket.internal_status = internal_status
          ticket.save
          expect(ticket.decrement_deadline).to be_falsey
        end
      end
    end

    context 'when ticket status changed to one of the INTERNAL_STATUSES_TO_ACTIVE_DEADLINE' do
      it 'decrement_deadline is set to true' do
        ticket = create(:ticket)

        Ticket::INTERNAL_STATUSES_TO_ACTIVE_DEADLINE.each do |internal_status|
          ticket.internal_status = internal_status
          ticket.save
          expect(ticket.decrement_deadline).to be_truthy
        end
      end
    end

    context 'when ticket is reopened' do
      it 'decrement_deadline is set to true' do
        ticket = create(:ticket, internal_status: :sectoral_attendance)
        ticket.reopened = 1
        ticket.save
        expect(ticket.decrement_deadline).to be_truthy
      end
    end
  end
end
