require 'rails_helper'

describe Ticket::Scopes do

  subject(:ticket) { build(:ticket) }

  describe 'validations' do
    it { is_expected.to validate_presence_of(:description) }
    it { is_expected.to validate_presence_of(:answer_type) }
    it { is_expected.to validate_presence_of(:ticket_type) }
    it { is_expected.to validate_presence_of(:reopened) }
    it { is_expected.to validate_presence_of(:appeals) }

    it { is_expected.to validate_uniqueness_of(:protocol) }

    describe 'email' do
      context 'allowed' do
        it { is_expected.to allow_value("").for(:email) }
        it { is_expected.to allow_value("admin@example.com").for(:email) }
        it { is_expected.to allow_value("admin@example.br").for(:email) }
      end

      context 'denied' do

        # Cusmomizando validação pois esta validação não é barrada pelo devise
        it { is_expected.to_not allow_value("admin@example").for(:email) }

        it { is_expected.to_not allow_value("admin@").for(:email) }
        it { is_expected.to_not allow_value("admin").for(:email) }
        it { is_expected.to_not allow_value("@example").for(:email) }
        it { is_expected.to_not allow_value("@example.com").for(:email) }
        it { is_expected.to_not allow_value("@example.com.br").for(:email) }
      end
    end


    describe 'sou_type' do
      # obrigatório para tickets do tipo 'sou'

      it 'validates sou_type presence' do
        # não valida sou_type para chamados do tipo :sic
        ticket.ticket_type = :sic
        expect(ticket).not_to validate_presence_of(:sou_type)

        # valida sou_type para chamados do tipo :sic
        ticket.ticket_type = :sou
        expect(ticket).to validate_presence_of(:sou_type)
      end

      context 'when denunciation' do
        before { ticket.sou_type = :denunciation }

        context 'not presence of' do
          it { expect(ticket).to_not validate_presence_of(:description) }
        end

        context 'presence of' do
          it { expect(ticket).to validate_presence_of(:denunciation_description) }
          it { expect(ticket).to validate_presence_of(:denunciation_date) }
          it { expect(ticket).to validate_presence_of(:denunciation_place) }
          it { expect(ticket).to validate_presence_of(:denunciation_assurance) }
          it { expect(ticket).to validate_presence_of(:denunciation_witness) }
          it { expect(ticket).to validate_presence_of(:denunciation_evidence) }
        end

        context 'attendance_155' do
          let(:attendance) { build :attendance, service_type: :sou_forward }
          before { ticket.attendance = attendance }

          it { expect(ticket).to_not validate_presence_of(:denunciation_description) }
        end
      end
    end

    describe 'organ' do
      it 'validates organ presence when unknown_organ is false' do
        # Órgão é obrigatório caso a opção unknown_organ não esteja marcada.
        ticket.unknown_organ = false

        expect(ticket).to validate_presence_of(:organ)
      end

      context 'validates organ presence when attendance_unknown_organ is false' do
        before do
          allow(ticket).to receive(:attendance_unknown_organ?) { false }
          ticket.unknown_organ = false
        end

        it { expect(ticket).to validate_presence_of(:organ) }
      end

      it 'validates organ presence when sou_type is denunciation' do
        # Órgão não é obrigatório caso o tipo do ticket seja denúncia.
        ticket.unknown_organ = false
        ticket.sou_type = :denunciation

        expect(ticket).to_not validate_presence_of(:organ)
      end

      context 'when immediate_answer' do
        before { ticket.unknown_organ = true }

        context 'true' do
          before { ticket.immediate_answer = true }

          context 'parent' do
            let(:ticket) { create(:ticket) }

            context 'with children' do
              let(:child) { create(:ticket, :with_parent, parent: ticket) }

              before { child }

              it { expect(ticket).not_to validate_presence_of(:organ) }
            end

            context 'without children' do
              it { expect(ticket).to validate_presence_of(:organ) }
            end
          end
        end

        it 'false' do
          ticket.immediate_answer = false
          expect(ticket).not_to validate_presence_of(:organ)
        end
      end
    end

    describe 'department' do
      let(:organ) { create(:executive_organ, subnet: true) }

      before do
        ticket.unknown_organ = false
        ticket.unknown_subnet = false
        ticket.organ = organ

      end

      it 'validates subnet presence when organ is subnet and unknown_subnet is false' do
        # Unidade é obrigatório caso a opção unknown_subnet não esteja marcada.

        expect(ticket).to validate_presence_of(:subnet)

        ticket.unknown_subnet = true
        ticket.organ = organ
        expect(ticket).not_to validate_presence_of(:subnet)

        ticket.organ = organ
        ticket.organ.subnet = false
        ticket.unknown_subnet = false
        expect(ticket).not_to validate_presence_of(:subnet)
      end

      it 'validates subnet presence when sou_type is denunciation' do
        # Órgão não é obrigatório caso o tipo do ticket seja denúncia.
        ticket.sou_type = :denunciation

        expect(ticket).to_not validate_presence_of(:subnet)
      end
    end

    describe 'classification' do
      context 'when immediate_answer' do
        context 'true' do
          before { ticket.immediate_answer = true }

          context 'parent' do
            let(:ticket) { create(:ticket) }

            context 'with children' do
              let(:child) { create(:ticket, :with_parent, :replied, parent: ticket) }

              before { child }

              it { expect(ticket).not_to validate_presence_of(:classification) }
            end

            context 'without children' do
              it { expect(ticket).to validate_presence_of(:classification) }
            end
          end
        end

        it 'false' do
          ticket.immediate_answer = false
          expect(ticket).not_to validate_presence_of(:classification)
        end
      end

      context 'when attendance service type is sic_completed' do
        it "classification is not required" do
          attendance = create(:attendance, :sic_completed)
          ticket = attendance.ticket

          expect(attendance.ticket).not_to validate_presence_of(:classification)
        end
      end
    end

    describe 'answers' do
      context 'when immediate_answer' do
        context 'true' do
          before { ticket.immediate_answer = true }

          context 'parent' do
            let(:ticket) { create(:ticket) }

            context 'with children' do
              let(:child) { create(:ticket, :with_parent, parent: ticket) }

              before { child }

              it { expect(ticket).not_to validate_presence_of(:answers) }
            end

            context 'without children' do
              it { expect(ticket).to validate_presence_of(:answers) }
            end
          end
        end

        it 'false' do
          ticket.immediate_answer = false
          expect(ticket).not_to validate_presence_of(:answers)
        end
      end
    end

    describe 'answer_type' do

      it 'sic_presential?' do
        ticket.ticket_type = :sic
        ticket.answer_type = :presential

        expect(ticket).to validate_presence_of(:city)
        expect(ticket).to validate_presence_of(:state)
      end

      context 'when identified' do
        it 'validates present' do
          ticket.anonymous = false
          expect(ticket).to validate_presence_of(:answer_type)
        end

        context 'city and state' do
          context 'when created_by operator' do
            before { ticket.created_by = create(:user, :operator) }

            it { expect(ticket).to_not validate_presence_of(:city) }
            it { expect(ticket).to_not validate_presence_of(:state) }
          end

          context 'when created_by user' do
            before { ticket.created_by = create(:user, :user) }

            it { expect(ticket).to validate_presence_of(:city) }
            it { expect(ticket).to validate_presence_of(:state) }
          end
        end
      end

      context 'when anonymous' do
        it 'not validates present' do
          ticket.anonymous = true
          expect(ticket).to_not validate_presence_of(:answer_type)
          expect(ticket).to_not validate_presence_of(:state)
          expect(ticket).to_not validate_presence_of(:city)
        end
      end

      context 'when phone' do
        it 'validates answer_phone presence' do
          # Telefone é obrigatório quando tipo de resposta é telefone.

          ticket.answer_phone = nil
          ticket.answer_type = :phone

          expect(ticket).to validate_presence_of(:answer_phone)
        end
      end

      context 'when letter' do
        before { ticket.answer_type = :letter }

        it { is_expected.to validate_presence_of(:city) }
        it { is_expected.to validate_presence_of(:answer_address_street) }
        it { is_expected.to validate_presence_of(:answer_address_number) }
        it { is_expected.to validate_presence_of(:answer_address_zipcode) }
        it { is_expected.to validate_presence_of(:answer_address_neighborhood) }
      end

      context 'when email' do
        before { ticket.answer_type = :email }

        it { is_expected.to validate_presence_of(:email) }
      end

      context 'when twitter' do
        before { ticket.answer_type = :twitter }

        it { is_expected.to validate_presence_of(:answer_twitter) }
      end

      context 'when facebook' do
        before { ticket.answer_type = :facebook }

        it { is_expected.to validate_presence_of(:answer_facebook) }
      end

      context 'when instagram' do
        before { ticket.answer_type = :instagram }

        it { is_expected.to validate_presence_of(:answer_instagram) }
      end

      context 'when whatsapp' do
        before { ticket.answer_type = :whatsapp }

        it { is_expected.to validate_presence_of(:answer_whatsapp) }
      end
    end

    describe 'user informations' do

      context 'when sou' do
        it 'validates name presence' do
          ticket.ticket_type = 'sou'
          ticket.created_by = create(:user)
          expect(ticket).to validate_presence_of(:name)
          expect(ticket).to_not validate_presence_of(:email)
          expect(ticket).to_not validate_presence_of(:document)
        end

        it 'not validates name and email presence' do
          ticket.ticket_type = 'sou'
          ticket.anonymous = true
          expect(ticket).to_not validate_presence_of(:name)
          expect(ticket).to_not validate_presence_of(:email)
          expect(ticket).to_not validate_presence_of(:document)
        end

      end

      context 'when sic' do
        before { ticket.ticket_type = :sic }

        it 'validates name and document presence' do
          expect(ticket).to validate_presence_of(:name)
          expect(ticket).to validate_presence_of(:document)
          expect(ticket).to_not validate_presence_of(:email)
        end

        it 'cannot be anonymous' do
          ticket.anonymous = true

          expect(ticket).to include_error(:invalid).on(:anonymous)
        end
      end

      describe 'person_type' do

        context 'authenticated' do
          before do
            ticket.anonymous = false
            ticket.created_by = create(:user, :user)
          end

          it { is_expected.to_not validate_presence_of(:person_type) }
        end

        context 'identified' do
          before do
            ticket.anonymous = false
            ticket.name = 'name'
          end

          it { is_expected.to validate_presence_of(:person_type) }
        end

        context 'anonymous' do
          before do
            ticket.anonymous = true
            ticket.name = ''
          end

          it { is_expected.to_not validate_presence_of(:person_type) }
        end
      end

      context 'document' do
        it { is_expected.to validate_presence_of(:name) }
        it { is_expected.not_to validate_presence_of(:document) }

        context 'sic' do
          before { ticket.ticket_type = :sic }

          it { is_expected.to validate_presence_of(:document) }

          context 'anonymous' do
            before { ticket.anonymous = true }

            it { is_expected.not_to validate_presence_of(:name) }
            it { is_expected.not_to validate_presence_of(:document) }
          end

          context 'attendance_sic_completed' do
            let(:attendance) { build :attendance, service_type: :sic_completed }
            before { ticket.attendance = attendance }

            it { is_expected.not_to validate_presence_of(:name) }
            it { is_expected.not_to validate_presence_of(:document) }
          end
        end

        context 'CPF' do
          before do
            ticket.person_type = :individual
            ticket.document_type = :cpf
            ticket.document = CPF.generate(true)
          end

          context 'format' do
            context 'wrong format' do
              before { ticket.document = '12345699999' }
              it { is_expected.to be_invalid }
            end

            context 'right format' do
              it { is_expected.to be_valid }
            end

            context 'empty' do
              before { ticket.document = '' }
              it { is_expected.to be_valid }
            end
          end
        end

        context 'CNPJ' do
          before do
            ticket.person_type = :legal
            ticket.document = CNPJ.generate(true)
          end

          context 'format' do
            context 'wrong format' do
              before { ticket.document = '12345699999' }
              it { is_expected.to be_invalid }
            end

            context 'right format' do
              it { is_expected.to be_valid }
            end

            context 'empty' do
              before { ticket.document = '' }
              it { is_expected.to be_valid }
            end
          end
        end
      end

      context 'ticket_department' do
        context 'with repeated department' do
          let(:department) { create(:department) }
          let(:ticket) { create(:ticket, :with_organ) }
          let(:ticket_department) { create(:ticket_department, ticket: ticket) }
          let(:deadline_ends_at) { Date.today + 10.day }

          let(:ticket_departments_attributes) do
            {
              "0": {
                id: ticket_department.id
              },
              "1": {
                department_id: department.id,
                description:'description',
                note: '',
                deadline: 15,
                deadline_ends_at: deadline_ends_at
              },
              "2": {
                department_id: department.id,
                description: 'description',
                note: '',
                deadline: 15,
                deadline_ends_at: deadline_ends_at
              }
            }
          end

          let(:valid_params) do
            {
              ticket_departments_attributes: ticket_departments_attributes
            }
          end

          before do
            ticket_department
            ticket.reload
          end

          it 'does not save' do
            expect do
              result = ticket.update_attributes(valid_params)

              ticket_department_with_error = ticket.ticket_departments.last

              expect(result).to be_falsey
              expect(ticket.errors['ticket_departments.department_id']).to eq([{ error: :taken, value: department.id }])
              expect(ticket_department_with_error.errors[:department_id]).to eq([I18n.t('errors.messages.taken')])
            end.to change(TicketDepartment, :count).by(0)
          end

          context 'when subnet' do
            let(:ticket) { create(:ticket, :with_subnet) }
            let(:ticket_department) { create(:ticket_department, ticket: ticket) }

            let(:ticket_departments_attributes) do
              {
                "0": {
                  id: ticket_department.id
                },
                "1": {
                  description:'description',
                  note: 'note',
                  deadline: 15,
                  deadline_ends_at: deadline_ends_at,
                  department: create(:department)
                },
                "2": {
                  description: 'description',
                  note: 'note',
                  deadline: 15,
                  deadline_ends_at: deadline_ends_at,
                  department: create(:department)
                }
              }
            end

            it 'save' do
              expect do
                result = ticket.update_attributes(valid_params)

                expect(result).to be_truthy
              end.to change(TicketDepartment, :count).by(2)
            end
          end
        end
      end
    end

    describe 'parent ticket' do

      let(:tickets) { build_list(:ticket, 2, :with_organ) }
      let(:ticket_parent) { create(:ticket)}
      let(:organ) { create(:executive_organ)}
      let(:ticket_child) { create(:ticket, :with_parent) }

      it 'validates presence of organ for child tickets' do
        # Órgão é obrigatório caso o ticket seja um filho (parent_id para outro ticket).
        ticket.parent = ticket_parent
        ticket.organ = nil

        expect(ticket).to validate_presence_of(:organ)
      end

      it 'validates parent_id != id' do
        # Órgão é obrigatório caso o ticket seja um filho (parent_id para outro ticket).
        ticket_parent.parent = ticket_parent
        ticket_parent.unknown_organ = false
        ticket_parent.organ_id = organ.id

        expect(ticket_parent).to_not be_valid
      end

      it 'validates child ticket does not have children' do
        # quando um ticket é filho ele não pode ter filhos, os novos compartilhados
        # irão ser relacionados com o pai
        ticket_child.tickets << build(:ticket, :with_organ)

        expect(ticket_child).to_not be_valid
      end

      it 'validates ticket children with equal organ' do
        # quando um ticket é filho ele não pode ter filhos, os novos compartilhados
        # irão ser relacionados com o pai
        tickets.each do |t|
          t.organ = organ
        end

        ticket_parent.tickets << tickets

        expect(ticket_parent).to_not be_valid
      end
    end

    context 'deadline' do
      context 'with status not in_progress' do
        before { ticket.status = :confirmed }

        it { expect(ticket).to validate_presence_of(:deadline) }
        it { expect(ticket).to validate_presence_of(:deadline_ends_at) }
      end

      context 'with status in_progress' do
        before { ticket.status = :in_progress }

        it { expect(ticket).not_to validate_presence_of(:deadline) }
        it { expect(ticket).not_to validate_presence_of(:deadline_ends_at) }
      end
    end

    context 'public_ticket' do
      let(:ticket) { build(:ticket, :sic, public_ticket: true) }

      it { expect(ticket.valid?).to be_truthy }

      context 'denunciation' do
        let(:ticket) { build(:ticket, :denunciation, public_ticket: true) }

        it { expect(ticket.valid?).to be_falsey }
      end

      context 'anonymous' do
        let(:ticket) { build(:ticket, :anonymous, public_ticket: true) }

        it { expect(ticket.valid?).to be_falsey }
      end
    end

    context 'justification' do
      context 'nil' do
        before { ticket.justification = nil }

        it { expect(ticket).not_to validate_presence_of(:justification) }
      end

      context 'empty' do
        before { ticket.justification = '' }

        it { is_expected.to be_invalid }
      end
    end


    context 'when related to an attendance' do
      context 'an anonymous ticket' do
        let(:ticket) { build :ticket, anonymous: true }
        subject { attendance.ticket }

        context 'from attendance service type :sic_forward' do
          let!(:attendance) { build :attendance, service_type: :sic_forward, ticket: ticket }
          let(:ticket) { build :ticket, :sic, anonymous: true } # override

          it { is_expected.to include_error(:invalid).on(:anonymous) }
        end

        context 'from attendance service type :sic_completed' do
          let!(:attendance) { build :attendance, service_type: :sic_completed, ticket: ticket, answer: 'Resposta ao atendimento' }
          let(:ticket) { build :ticket, :sic, anonymous: true } # override

          it { is_expected.to include_error(:invalid).on(:anonymous) }
        end

        # other service types...
        Attendance.service_types.except(:sic_forward, :sic_completed).keys.each do |service_type|
          context "from attendance service type :#{service_type}" do
            let!(:attendance) { build :attendance, service_type: service_type, ticket: ticket }

            it { is_expected.not_to include_error(:invalid).on(:anonymous) }
          end
        end
      end
    end

  end # validations

end
