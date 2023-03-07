require 'rails_helper'

describe Operator::TicketsController do

  let(:user) { create(:user, :operator) }

  let(:ticket) { create(:ticket, :confirmed, created_by: user) }
  let(:confirmed_ticket) { create(:ticket, :confirmed)}
  let(:in_progress_ticket) { create(:ticket, :in_progress)}
  let(:replied_ticket) { create(:ticket, :replied)}

  let(:permitted_params) do
    [
      :name,
      :email,
      :social_name,
      :gender,
      :description,
      :sou_type,
      :organ_id,
      :unknown_organ,
      :subnet_id,
      :unknown_subnet,
      :unknown_classification,
      :status,
      :used_input,
      :used_input_url,
      :priority,

      :answer_type,
      :answer_phone,
      :answer_cell_phone,

      :city_id,
      :answer_address_street,
      :answer_address_number,
      :answer_address_zipcode,
      :answer_address_neighborhood,
      :answer_address_complement,
      :answer_twitter,
      :answer_facebook,
      :answer_instagram,

      :target_address_zipcode,
      :target_city_id,
      :target_address_street,
      :target_address_number,
      :target_address_neighborhood,
      :target_address_complement,

      :document_type,
      :document,
      :person_type,

      :anonymous,

      :denunciation_organ_id,
      :denunciation_description,
      :denunciation_date,
      :denunciation_place,
      :denunciation_witness,
      :denunciation_evidence,
      :denunciation_assurance,

      :immediate_answer,

      attachments_attributes: [
        :id, :document, :_destroy
      ],

      classification_attributes: permmited_classification_params,

      answers_attributes: [
        :user,
        :description,
        :ticket_id,

        :answer_scope,
        :answer_type,
        :status,
        :classification,
        :certificate,

        attachments_attributes: [
          :document
        ]
      ]
    ]
  end

  let(:permmited_classification_params) do
    [
      :topic_id,
      :subtopic_id,
      :department_id,
      :sub_department_id,
      :budget_program_id,
      :service_type_id,
      :other_organs
    ]
  end

  let(:tempfile) do
    file = Tempfile.new("test.png", Rails.root + "spec/fixtures")
    file.write('1')
    file.close
    file.open
    file
  end

  let(:attachment) { Rack::Test::UploadedFile.new(tempfile, "image/png") }

  describe '#index' do
    let(:params) { { ticket_type: :sou } }

    context 'unauthorized' do
      before { get(:index) }

      it { is_expected.to redirect_to(new_user_session_path) }
    end

    context 'authorized' do
      before { sign_in(user) }

      context 'template' do
        before { get(:index, params: { ticket_type: :sic }) }
        render_views

        it { is_expected.to respond_with(:success) }
      end

      context 'ticket_type' do
        # como esse controller cuida de dois tipos de tickets (sou e sic) e
        # isso é usado em diversas partes, como definir o título das páginas e
        # dos breadcrumbs por ex., precisamos garantir que o valor desse
        # parâmetro esteja definido.

        let(:default_ticket_type) { 'sou' }

        context 'operator_type' do

          it 'when cge' do
            user = create(:user, :operator_cge)
            sign_in(user)

            get(:index)

            expect(controller.ticket_type).to eq(default_ticket_type)
          end

          it 'when call_center_supervisor' do
            user = create(:user, :operator_call_center_supervisor)
            sign_in(user)

            get(:index)

            expect(controller.ticket_type).to eq(default_ticket_type)
          end

          it 'when call_center' do
            user = create(:user, :operator_call_center)
            sign_in(user)

            get(:index)

            expect(controller.ticket_type).to eq(default_ticket_type)
          end

          it 'when sou_sectoral' do
            user = create(:user, :operator_sectoral)
            sign_in(user)

            get(:index)

            expect(controller.ticket_type).to eq(default_ticket_type)
          end

          it 'when internal' do
            user = create(:user, :operator_internal)
            sign_in(user)

            get(:index, params: { ticket_type: :sou })

            expect(controller.ticket_type).to eq(default_ticket_type)
          end
        end

        it 'when empty' do
          get(:index)

          expect(controller.ticket_type).to eq('sou')
        end

        it 'when invalid' do
          get(:index, params: { ticket_type: :nao_existe })

          expect(controller.ticket_type).to eq('sou')
        end
      end

      context 'helpers' do
        it 'filters ticket_type' do
          sou_ticket = create(:ticket, :confirmed, ticket_type: :sou)
          another_type_ticket = create(:ticket, :confirmed, ticket_type: :sic)

          # apenas tickets do usuário corrente.
          get(:index, params: { ticket_type: :sou })
          expect(controller.tickets).to eq([sou_ticket])
        end

        it 'tickets' do
          create(:ticket, :confirmed)

          expect(controller.tickets).to be_present
        end

        context 'title' do
          it 'sou ticket_type' do
            get(:index, params: { ticket_type: :sou })

            expect(controller.title).to eq(I18n.t('operator.tickets.index.sou.title'))
          end

          it 'sic ticket_type' do
            get(:index, params: { ticket_type: :sic })

            expect(controller.title).to eq(I18n.t('operator.tickets.index.sic.title'))
          end
        end

        context 'ticket_department' do

          let(:operator_internal) { create(:user, :operator_internal) }
          let(:ticket) { create(:ticket, :in_internal_attendance) }
          let(:ticket_department) { create(:ticket_department, ticket: ticket, department: operator_internal.department) }

          before do
            ticket_department

            sign_in(operator_internal)

            get(:index, params: { ticket_type: :sou })
          end

          it { expect(controller.tickets.first.ticket_department_by_user(operator_internal)).to eq(ticket_department) }
        end

        context 'readonly?' do
          it { expect(controller.readonly?).to be_falsey }
        end
      end

      context 'pagination' do
        it 'calls kaminari methods' do
          allow(Ticket).to receive(:page).and_call_original
          expect(Ticket).to receive(:page).and_call_original

          # para poder acionar o método page que estamos testando

          controller.tickets
        end
      end

      context 'filter' do
        let(:ticket_child) { create(:ticket, :with_parent)}
        let(:organ) { ticket_child.organ }
        let(:topic) { create(:topic, organ: organ) }
        let(:subtopic) { create(:subtopic, topic: topic) }
        let(:sub_department) { create(:sub_department) }
        let(:budget_program) { create(:budget_program) }

        before { confirmed_ticket }

        context 'reopened' do
          it 'once' do
            ticket = create(:ticket, :with_parent)
            ticket_reopened = create(:ticket, :with_parent)
            ticket_parent = ticket_reopened.parent
            ticket_parent.update_column(:reopened, 1)

            get(:index, params: { reopened: true })

            expect(controller.tickets).to eq([ticket_parent])
          end
        end

        context 'internal_status' do
          it 'waiting_referral' do
            in_progress_ticket

            get(:index, params: { internal_status: :waiting_referral })

            expect(controller.tickets).to eq([confirmed_ticket])
          end

          it 'awaiting_invalidation' do
            ticket_waiting_invalidate = create(:ticket, :with_parent, organ: organ, internal_status: :awaiting_invalidation)
            ticket_parent = ticket_waiting_invalidate.parent

            get(:index, params: { internal_status: :awaiting_invalidation })

            expect(controller.tickets).to eq([ticket_parent])
          end

          it 'awaiting_invalidation and organ' do
            ticket_waiting_invalidate = create(:ticket, :with_parent, organ: organ, internal_status: :awaiting_invalidation)
            ticket_parent = ticket_waiting_invalidate.parent

            get(:index, params: { internal_status: :awaiting_invalidation, organ: organ })

            expect(controller.tickets).to eq([ticket_parent])
          end

          # Essa validação, não consideramos o status e sim,
          # se possui uma resposta que precisa ser aprovada pela CGE
          it 'cge_validation' do
            ticket = create(:ticket, :confirmed)
            create(:ticket, :confirmed, internal_status: :cge_validation)

            create(:ticket_log, :with_awaiting_sectoral, ticket: ticket)

            get(:index, params: { internal_status: :cge_validation })

            expect(controller.tickets).to eq([ticket])

          end


          #
          # Operadores :cge, :call_center e :call_center_supervisor tem o escopo
          # de tickets pai, porém a busca pelo :internal_status deve ser
          # feito nos tickets filhos e nos tickets sem filhos (tickets "folha")
          #
          context 'when user scoped by parent tickets' do
            let(:user) { create(:user, :operator_cge) }

            let(:ticket_parent) { ticket_child.parent }
            let(:ticket_child) { create(:ticket, :with_parent, internal_status: :sectoral_attendance) }
            let(:ticket_without_children) { create(:ticket, internal_status: :sectoral_attendance) }

            it 'sectoral_attendance' do
              ticket_child
              ticket_without_children

              create(:ticket, :with_parent)

              get(:index, params: { internal_status: :sectoral_attendance })

              expect(controller.tickets).to match_array([ticket_parent, ticket_without_children])
            end

            it 'appeal' do
              appeal_parent = create(:ticket, :replied, :sic, internal_status: :appeal, status: :confirmed, appeals: 1, appeals_at: DateTime.now)
              appeal_child = create(:ticket, :with_organ, parent_id: appeal_parent)
              appeal_parent.tickets << appeal_child
              appeal_parent.save

              get(:index, params: { internal_status: :appeal , ticket_type: :sic})

              expect(controller.tickets).to match_array([appeal_parent])
            end

            it 'rede_ouvir' do
              ticket_parent
              ticket_rede_ouvir = create(:ticket, :with_rede_ouvir)
              parent_rede_ouvir = ticket_rede_ouvir.parent

              get(:index, params: { rede_ouvir: true})

              expect(controller.tickets).to eq([parent_rede_ouvir])
            end

            it 'rede_ouvir_cge' do
              ticket_parent
              ticket_rede_ouvir = create(:ticket, :with_rede_ouvir)
              parent_rede_ouvir = ticket_rede_ouvir.parent
              ticket_rede_ouvir_cge = create(:ticket, :with_rede_ouvir, organ: create(:rede_ouvir_organ, :cge))
              parent_rede_ouvir_cge = ticket_rede_ouvir_cge.parent

              get(:index, params: { rede_ouvir_cge: true})

              expect(controller.tickets).to eq([parent_rede_ouvir_cge])
            end
          end
        end

        it 'organ' do
          get(:index, params: { organ: organ })

          expect(controller.tickets).to eq([ticket_child.parent])
        end

        it 'department' do
          department = create(:department, organ: organ)
          create(:ticket_department, ticket: ticket_child, department: department)

          get(:index, params: { department: department })

          expect(controller.tickets).to eq([ticket_child.parent])
        end

        it 'sub_department' do
          create(:classification, sub_department: sub_department, ticket: ticket_child)
          get(:index, params: { sub_department: sub_department.id })

          expect(controller.tickets).to eq([ticket_child.parent])
        end

        context 'topic' do

          before { create(:classification, topic: topic, ticket: ticket_child) }

          it 'with organ' do
            get(:index, params: { organ: organ, topic: topic })

            expect(controller.tickets).to eq([ticket_child.parent])
          end

          it 'without organ' do
            get(:index, params: { topic: topic })

            expect(controller.tickets).to eq([ticket_child.parent])
          end

        end

        context 'subtopic' do

          let(:other_ticket) { create(:ticket, :with_parent, organ: organ) }
          let(:classification) { create(:classification, topic: topic, subtopic: subtopic, ticket: ticket_child) }

          before { classification }

          context 'with organ' do

            it 'with topic' do
              get(:index, params: { organ: organ, topic: topic, subtopic: subtopic })

              expect(controller.tickets).to eq([ticket_child.parent])
            end

            it 'without topic' do
              create(:classification, topic: topic, subtopic: subtopic, ticket: other_ticket)

              get(:index, params: { organ: organ, subtopic: subtopic })

              expect(controller.tickets).to eq([ticket_child.parent, other_ticket.parent])
            end
          end

          context 'without organ' do

            it 'with topic' do
              get(:index, params: { topic: topic, subtopic: subtopic })

              expect(controller.tickets).to eq([ticket_child.parent])
            end

            it 'without topic' do
              get(:index, params: { subtopic: subtopic })

              expect(controller.tickets).to eq([confirmed_ticket, ticket_child.parent])
            end
          end
        end

        it 'budget_program' do
          create(:classification, budget_program: budget_program, ticket: ticket_child)

          get(:index, params: { budget_program: budget_program })

          expect(controller.tickets).to eq([ticket_child.parent])
        end

        it 'service_type' do
          service_type = create(:service_type)
          create(:classification, service_type: service_type, ticket: ticket_child)

          get(:index, params: { service_type: service_type })

          expect(controller.tickets).to eq([ticket_child.parent])
        end

        it 'priority' do
          priority_ticket = create(:ticket,:confirmed, priority: true)

          confirmed_ticket
          in_progress_ticket

          get(:index, params: { priority: '1' })

          expect(controller.tickets).to eq([priority_ticket])
        end

        context 'finalized' do
          it 'true' do
            create(:ticket, internal_status: :final_answer)

            confirmed_ticket
            in_progress_ticket

            get(:index, params: { finalized: '1' })

            expect(controller.tickets.size).to eq(3)
          end

          it 'false' do
            create(:ticket, internal_status: :final_answer)

            confirmed_ticket
            in_progress_ticket

            get(:index, params: { finalized: '0' })

            expect(controller.tickets.size).to eq(1)
          end
        end

        context 'deadline' do
          context 'default' do
            it 'not_expired' do
              create(:ticket, :confirmed, deadline: 2 )

              confirmed_ticket
              in_progress_ticket

              get(:index, params: { deadline: :not_expired })

              expect(controller.tickets.size).to eq(2)
            end

            it 'expired_can_extend' do
              create(:ticket, :confirmed, deadline: Ticket::LIMIT_TO_EXTEND_DEADLINE )

              ticket_days = Ticket::LIMIT_TO_EXTEND_DEADLINE - 1
              in_limit = DateTime.now - ticket_days.days
              create(:ticket, :confirmed, deadline: Ticket::SOU_DEADLINE - ticket_days, confirmed_at: in_limit)

              get(:index, params: { deadline: :expired_can_extend })

              expect(controller.tickets.size).to eq(1)
            end

            it 'expired' do
              ticket = create(:ticket, :confirmed, deadline: -1)
              create(:ticket, :confirmed, deadline: -1)

              confirmed_ticket
              in_progress_ticket

              get(:index, params: { deadline: :expired })

              expect(controller.tickets.size).to eq(2)
            end
          end

          context 'internal operator' do
            let(:user) { create(:user, :operator_internal) }

            it 'filters by department deadline' do
              ticket_days = Ticket::LIMIT_TO_EXTEND_DEADLINE - 1
              in_limit = DateTime.now - ticket_days.days
              internal_expired = create(:ticket, :in_internal_attendance, internal_status: :internal_attendance)
              create(:ticket_department, department: user.department, ticket: internal_expired, deadline: Ticket::SOU_DEADLINE - ticket_days, created_at: in_limit)

              get(:index, params: { ticket_type: :sou, deadline: :expired_can_extend })

              expect(controller.tickets).to eq([internal_expired])
            end

          end
        end

        context 'ticket_department_deadline' do
          context 'operator sectoral' do
            let(:user) { create(:user, :operator_sectoral) }
            let(:organ) { user.organ }
            let(:internal_department) { create(:department) }

            let(:not_expired) do
              ticket = create(:ticket, :with_parent, organ: organ)
              create(:ticket_department, deadline: 2, ticket: ticket)
              ticket
            end

            let(:expired_can_extend) do
              ticket_days = Ticket::LIMIT_TO_EXTEND_DEADLINE - 1
              in_limit = DateTime.now - ticket_days.days
              internal_expired = create(:ticket, :with_organ, organ: organ, internal_status: :internal_attendance)
              create(:ticket_department, department: internal_department, ticket: internal_expired, deadline: Ticket::SOU_DEADLINE - ticket_days, created_at: in_limit)
              internal_expired
            end

            let(:expired) do
              ticket = create(:ticket, :with_organ, organ: organ, extended: true)
              create(:ticket_department, department: internal_department, deadline: -1, ticket: ticket)
              ticket
            end

            before do
              not_expired
              expired_can_extend
              expired
            end

            it 'not_expired' do
              get(:index, params: { ticket_departments_deadline: :not_expired })

              expect(controller.tickets).to match_array([not_expired])
            end

            it 'expired_can_extend' do
              get(:index, params: { ticket_departments_deadline: :expired_can_extend })

              expect(controller.tickets).to match_array([expired_can_extend])
            end

            it 'expired' do
              get(:index, params: { ticket_departments_deadline: :expired })

              expect(controller.tickets).to match_array([ expired, expired_can_extend ])
            end
          end
        end

        it 'answer_type' do
          ticket_answer_phone = create(:ticket, :confirmed, answer_type: :phone)
          create(:ticket, answer_type: :default)

          get(:index, params: { answer_type: :phone })

          expect(controller.tickets.size).to eq(1)
          expect(controller.tickets.first).to eq(ticket_answer_phone)
        end

        context 'only other_organs' do
          let(:operator_cge) { create(:user, :operator_cge) }
          before do
            create(:ticket, :with_parent, :with_classification_other_organs)
            sign_in(operator_cge)
          end

          it 'with param' do
            create(:ticket, :confirmed)

            get(:index, params: { other_organs: '1' })

            expect(controller.tickets.size).to eq(1)
            expect(controller.total_count).to eq(4)
          end

          it 'without param' do
            create(:ticket, :confirmed)

            get(:index)

            expect(controller.tickets.size).to eq(4)
            expect(controller.total_count).to eq(4)
          end
        end

        context 'with denunciation_tracking' do
          before do
            user_denunciation_tracking = create(:user, :operator_cge_denunciation_tracking)
            sign_in(user_denunciation_tracking)
          end

          it 'not denunciation' do
            ticket_denunciation = create(:ticket, :denunciation)
            ticket_denunciation
            create(:ticket, :confirmed)

            get(:index,  params: { denunciation: '0' })

            expect(controller.tickets.size).to eq(3)
            expect(controller.total_count).to eq(3)
          end

          it 'default filter denunciation' do
            ticket_denunciation = create(:ticket, :denunciation)
            ticket_denunciation
            create(:ticket, :confirmed)

            get(:index)

            expect(controller.tickets.size).to eq(3)
            expect(controller.total_count).to eq(3)
          end

          it 'denunciation' do
            ticket_denunciation = create(:ticket, :denunciation)
            ticket_denunciation
            create(:ticket, :confirmed)

            get(:index, params: { denunciation: '1' })

            expect(controller.tickets.size).to eq(1)
            expect(controller.total_count).to eq(3)
            expect(controller.tickets.first).to eq(ticket_denunciation)
          end

          it 'without denunciations' do
            denunciation = create(:ticket, :denunciation)

            get(:index, params: { without_denunciation: 'true' })

            expect(controller.tickets).to eq([confirmed_ticket])
          end
        end

        context 'when operator sectoral' do
          let(:user) { create(:user, :operator_sectoral) }

          context 'department' do
            let(:organ) { user.organ }
            let(:department) { create(:department, organ: organ) }
            let(:ticket_child) { create(:ticket, :with_parent, organ: organ) }
            let(:ticket_department) { create(:ticket_department, ticket: ticket_child, department: department) }

            before do
              ticket_department
              ticket_child.reload

              get(:index, params: { department: department })
            end

            it { expect(controller.tickets).to eq([ticket_child]) }
          end

          context 'coordination' do
            let(:user) { create(:user, :operator_coordination) }
            let(:ticket_child) { create(:ticket, :with_parent) }
            let(:other_ticket_parent) { Ticket.first }

            before do
              user
              ticket_child
              create(:extension, ticket: ticket_child, status: :in_progress, solicitation: 2)
            end

            context 'when extension_in_progress param is passed' do
              it "return ticket child with extension" do
                get(:index, params: { extension_status: :in_progress, solicitation: 2 })
                expect(controller.tickets).to eq([ticket_child])
              end
            end

            context 'when extension_in_progress param not passed' do
              it "return ticket parent without your child" do
                get(:index)
                expect(controller.tickets).to eq([other_ticket_parent, ticket_child.parent])
              end
            end
          end


          context 'subnet' do
            let(:user) { create(:user, :operator_subnet_chief) }
            let(:organ) { create(:organ) }
            let(:ticket_child) { create(:ticket, :with_organ, organ: user.subnet.organ, subnet: user.subnet) }
            let(:other_ticket) { create(:ticket, :with_parent, organ: organ ) }
            let(:subnet) { ticket_child.subnet }

            before do
              ticket_child
              other_ticket
              get(:index, params: { subnet: subnet })
            end

            it {expect(controller.tickets).to eq([ticket_child]) }
          end
        end

        context 'entension in progress' do
          context 'when operator chief' do
            let(:user) { create(:user, :operator_chief) }

            it 'in progress' do
              ticket_extension_in_progress = create(:ticket, :with_parent, internal_status: :cge_validation, organ: user.organ)
              ticket_extension_approved = create(:ticket, :with_parent, internal_status: :cge_validation, organ: user.organ)

              create(:extension, ticket: ticket_extension_in_progress, status: :in_progress)
              create(:extension, ticket: ticket_extension_approved, status: :approved)

              get(:index, params: { extension_status: :in_progress, solicitation: '1' })

              expect(controller.tickets).to eq([ticket_extension_in_progress])
            end
          end

          context 'when operator subnet chief' do
            let(:user) { create(:user, :operator_subnet_chief) }

            it 'extension in progress' do
              ticket_extension_in_progress = create(:ticket, :with_parent, internal_status: :cge_validation, subnet: user.subnet, organ: user.organ)
              ticket_extension_approved = create(:ticket, :with_parent, internal_status: :cge_validation, subnet: user.subnet, organ: user.organ)

              create(:extension, ticket: ticket_extension_in_progress, status: :in_progress)
              create(:extension, ticket: ticket_extension_approved, status: :approved)

              get(:index, params: { extension_status: :in_progress, solicitation: '1' })

              expect(controller.tickets).to eq([ticket_extension_in_progress])
            end
          end
        end

        context 'sic' do
          context 'when operator denunciation' do
            let(:user) { create(:user, :operator_cge_denunciation_tracking) }
            let(:ticket) { create(:ticket, :confirmed, :sic) }

            before do
              ticket

              get(:index, params: { ticket_type: :sic })
            end

            it { expect(controller.tickets).to eq([ticket]) }
          end
        end
      end

      it 'sou_type' do
        ticket_compliment = create(:ticket, :confirmed, sou_type: :compliment)

        get(:index, params: { sou_type: :compliment })

        expect(controller.tickets.size).to eq(1)
        expect(controller.tickets.first).to eq(ticket_compliment)
      end

      context 'confirmed_at' do

        before do
          create(:ticket, :confirmed, confirmed_at: Time.zone.parse('2001-2-3 1:00'))
          create(:ticket, :confirmed, confirmed_at: Time.zone.parse('2002-2-3 1:00'))
          create(:ticket, :confirmed, confirmed_at: Time.zone.parse('2005-2-3 1:00'))
          create(:ticket, :confirmed, confirmed_at: Date.today.end_of_day)
        end

        it 'after date' do
          confirmed_at = {
            start: '01/01/2016',
            end: ''
          }

          get(:index, params: { confirmed_at: confirmed_at })

          expect(controller.tickets.size).to eq(1)
        end

        it 'in date' do
          confirmed_at = {
            start: '01/01/2000',
            end: '01/01/2004'
          }

          get(:index, params: { confirmed_at: confirmed_at })

          expect(controller.tickets.size).to eq(2)
        end

        it 'before date' do
          confirmed_at = {
            start: '',
            end: '01/01/2000'
          }

          get(:index, params: { confirmed_at: confirmed_at })

          expect(controller.tickets.size).to eq(0)
        end

        it 'same day' do
          confirmed_at = {
            start: '03/02/2001',
            end: '03/02/2001'
          }

          get(:index, params: { confirmed_at: confirmed_at })

          expect(controller.tickets.size).to eq(1)
        end
      end

      context 'search' do
        it 'protocol' do
          ticket = create(:ticket, :confirmed)
          another_ticket = create(:ticket, :confirmed)

          get(:index, params: { search: ticket.parent_protocol })

          expect(controller.tickets).to eq([ticket])
        end

        it 'only protocol' do
          ticket = create(:ticket, :confirmed)
          another_ticket = create(:ticket, :confirmed)

          get(:index, params: { parent_protocol: ticket.parent_protocol })

          expect(controller.tickets).to eq([ticket])
        end

        it 'dont show with partial protocol' do
          ticket = create(:ticket, :confirmed)
          another_ticket = create(:ticket, :confirmed)
          partial_protocol = ticket.parent_protocol.first(3)

          get(:index, params: { search: ticket.parent_protocol, parent_protocol: partial_protocol })

          expect(controller.tickets).to eq([])
        end

        # os testes de search do model devem ser feitos direto em seu 'search'
        # -> spec/models/ticket/search_spec.rb
      end

      describe '#sort' do

        context 'operator cge' do

          before { sign_in(user) }

          it 'sou sort_columns helper' do
            get(:index, params: { ticket_type: :sou })

            expected = [
              'tickets.confirmed_at',
              'tickets.deadline',
              'tickets.name',
              'tickets.parent_protocol',
              'tickets.sou_type',
              'tickets.internal_status'
            ]

            expect(controller.sort_columns).to eq(expected)
          end

          it 'sic sort_columns helper' do
            get(:index, params: { ticket_type: :sic })

            expected = [
              'tickets.confirmed_at',
              'tickets.deadline',
              'tickets.name',
              'tickets.parent_protocol',
              'tickets.internal_status'
            ]

            expect(controller.sort_columns).to eq(expected)
          end
        end

        context 'operator internal' do

          context 'sou' do
            before do
              operator_internal = create(:user, :operator_internal)
              sign_in(operator_internal)
            end

            it 'sort_columns helper' do
              get(:index, params: { ticket_type: :sou })

              expected = [
                'tickets.confirmed_at',
                'ticket_departments.deadline',
                'tickets.name',
                'tickets.parent_protocol',
                'tickets.sou_type',
                'tickets.internal_status'
              ]

              expect(controller.sort_columns).to eq(expected)
            end
          end

          context 'sic' do
            before do
              operator_internal = create(:user, :operator_internal)
              sign_in(operator_internal)
            end

            it 'sort_columns helper' do
              get(:index, params: { ticket_type: :sic })

              expected = [
                'tickets.confirmed_at',
                'ticket_departments.deadline',
                'tickets.name',
                'tickets.parent_protocol',
                'tickets.internal_status'
              ]

              expect(controller.sort_columns).to eq(expected)
            end
          end
        end

        it 'default' do
          first_unsorted = create(:ticket,:confirmed, deadline: '1')
          last_unsorted = create(:ticket,:confirmed, deadline: '2')

          first_unsorted
          last_unsorted

          get(:index)

          expect(controller.tickets).to eq([first_unsorted, last_unsorted])
        end
      end

      context 'operator type scope' do
        let(:sectoral_organ) { create(:executive_organ) }
        let(:internal_department) { create(:department) }

        let(:operator_cge) { create(:user, :operator_cge) }
        let(:operator_sectoral) { create(:user, :operator_sectoral, organ: sectoral_organ) }
        let(:operator_sectoral_sic) { create(:user, :operator_sectoral_sic, organ: sectoral_organ) }
        let(:operator_internal) { create(:user, :operator_internal, department: internal_department) }
        let(:operator_internal) { create(:user, :operator_internal, department: internal_department) }

        # São criados 4 tickets previamente
        let!(:sectoral_ticket) { create(:ticket, :confirmed, :with_organ, organ: sectoral_organ, internal_status: :sectoral_attendance) }
        let!(:sectoral_ticket_sic) { create(:ticket, :confirmed, :sic, :with_organ, organ: sectoral_organ, internal_status: :sectoral_attendance) }
        let!(:internal_ticket) { create(:ticket, :confirmed, :with_organ, organ: sectoral_organ, internal_status: :internal_attendance) }
        let!(:internal_ticket_sic) { create(:ticket, :confirmed, :sic, :with_organ, organ: sectoral_organ, internal_status: :internal_attendance) }
        let!(:child_ticket) { create(:ticket, :with_parent) } # ticket pai e filho
        let!(:denunciation_ticket) { create(:ticket, :denunciation) }
        # São criados 4 tickets previamente

        let!(:ticket_department) { create(:ticket_department, department: internal_department, ticket: internal_ticket) }
        let!(:ticket_department_sic) { create(:ticket_department, department: internal_department, ticket: internal_ticket_sic) }

        context 'cge operator' do
          let!(:ticket_in_filling) { create(:ticket, internal_status: nil) }
          before { sign_in(operator_cge) && get(:index) }

          # Deve listar apenas os tickets pais existentes, menos as denúncias
          it { expect(controller.tickets).to match_array(Ticket.where.not(id: [child_ticket.id, sectoral_ticket_sic.id, internal_ticket_sic.id, denunciation_ticket.id, ticket_in_filling.id])) }

          context 'with denunciation tracking' do
            before do
              # Operador com permissão de visualizar denúncias
              operator_cge.denunciation_tracking!
              sign_in(operator_cge)
              get(:index)

              # Deve listar todos os tickets pais, inclusive as denúncias
              it { expect(controller.tickets).to match_array(Ticket.where.not(id: [child_ticket.id, sectoral_ticket_sic.id, internal_ticket_sic.id])) }
            end
          end
        end

        context 'sectoral operator' do

          context 'sou sectoral' do
            before { sign_in(operator_sectoral) }

            it 'allow sou tickets' do
              get(:index, params: { ticket_type: :sou })

              is_expected.to respond_with(:success)

              # Deve listar apenas os tickets que possuem órgão e estão no atendimento setorial sou
              expect(controller.tickets).to eq([sectoral_ticket, internal_ticket])
            end

            it 'allow sic tickets' do
              operator_sectoral.update(acts_as_sic: true)

              get(:index, params: { ticket_type: :sic })

              is_expected.to respond_with(:success)
            end
          end

          context 'sic sectoral' do
            before { sign_in(operator_sectoral_sic) }

            it 'allow sic tickets' do
              get(:index, params: { ticket_type: :sic })

              is_expected.to respond_with(:success)

              # Deve listar apenas os tickets que possuem órgão e estão no atendimento setorial sic
              expect(controller.tickets).to eq([sectoral_ticket_sic, internal_ticket_sic])
            end

            it 'deny sou tickets' do
              get(:index, params: { ticket_type: :sou })

              is_expected.to respond_with(:forbidden)
            end
          end

        end

        context 'internal operator' do
          it 'sic allowed' do
            get(:index, params: { ticket_type: :sic })

            is_expected.to respond_with(:success)
          end

          it 'sou allowed' do
            get(:index, params: { ticket_type: :sou })

            is_expected.to respond_with(:success)
          end
        end
      end
    end
  end

  describe '#new' do
    context 'unauthorized' do
      before { get(:new) }

      it { is_expected.to redirect_to(new_user_session_path) }
    end

    context 'authorized' do
      before { sign_in(user) }

      context 'template' do
        before { get(:new) }

        render_views

        it { is_expected.to respond_with(:success) }
        it { is_expected.to render_template('operator/tickets/new') }
        it { is_expected.to render_template('operator/tickets/_form') }
      end

      context 'clone_ticket' do
        let(:existent_ticket) { create(:ticket, :sic, :with_classification, :answer_by_facebook) }
        let(:without_classification_ticket) { create(:ticket, :sic, :answer_by_facebook) }
        let(:classification) { existent_ticket.classification }

        let(:extistent_ticket_attributes) { existent_ticket.attributes.symbolize_keys }
        let(:classification_attributes) { classification.attributes.symbolize_keys }

        context 'attributes' do
          let(:controller_ticket) { controller.ticket }

          it 'ticket' do
            expected = extistent_ticket_attributes.slice(*permitted_params)

            get(:new, params: { clone_ticket: existent_ticket.id })

            result = controller_ticket.attributes.symbolize_keys.slice(*permitted_params)

            expect(result).to eq(expected)
          end

          context 'ticket denunciation' do
            let!(:user) { create(:user, :operator_sectoral) }
            let(:ticket_denunciation) { create(:ticket, :with_classification, :denunciation, :with_parent, organ: user.organ) }
            let(:ticket_denunciation_attributes) { ticket_denunciation.attributes.symbolize_keys }

            it 'user denunciation_tracking false' do
              expected = ticket_denunciation_attributes.slice(*permitted_params)
              expected[:name] = nil
              expected[:social_name] = nil
              expected[:gender] = nil
              expected[:document_type] = nil
              expected[:document] = nil
              expected[:email] = nil
              expected[:answer_phone] = nil
              expected[:answer_address_street] = nil
              expected[:answer_address_number] = nil
              expected[:answer_address_zipcode] = nil
              expected[:answer_address_complement] = nil
              expected[:answer_address_neighborhood] = nil
              expected[:answer_cell_phone] = nil
              expected[:answer_twitter] = nil
              expected[:answer_facebook] = nil
              expected[:city_id] = nil
              expected[:answer_instagram] = nil

              get(:new, params: { clone_ticket: ticket_denunciation.id })

              result = controller.ticket.attributes.symbolize_keys.slice(*permitted_params)

              expect(result).to eq(expected)
            end

            context 'user denunciation_tracking' do
              let!(:user) { create(:user, :operator_cge_denunciation_tracking) }
              let(:ticket_denunciation) { create(:ticket, :with_classification, :denunciation) }
              let(:ticket_denunciation_attributes) { ticket_denunciation.attributes.symbolize_keys }

              it 'not slice user info' do
                expected = ticket_denunciation_attributes.slice(*permitted_params)

                get(:new, params: { clone_ticket: ticket_denunciation.id })

                result = controller.ticket.attributes.symbolize_keys.slice(*permitted_params)

                expect(result).to eq(expected)
              end
            end
          end

          it 'classification' do
            expected = classification_attributes.slice(*permmited_classification_params)

            get(:new, params: { clone_ticket: existent_ticket.id })

            result = controller_ticket.classification.attributes.symbolize_keys.slice(*permmited_classification_params)

            expect(result).to eq(expected)
          end

          it 'without classification' do
            get(:new, params: { clone_ticket: without_classification_ticket.id })

            expect(controller.ticket.classification).to be_a_new(Classification)
          end

          it 'ticket_type' do
            expected = (extistent_ticket_attributes.slice(*permitted_params))
                        .merge!existent_ticket.slice(:ticket_type.to_s)

            get(:new, params: { clone_ticket: existent_ticket.id})

            result = (controller_ticket.attributes.symbolize_keys.slice(*permitted_params))
                      .merge!controller_ticket.attributes.slice(:ticket_type.to_s)

            expect(result).to eq(expected)
          end
        end
      end

      context 'helpers' do
        before { get(:new) }

        it 'ticket' do
          expect(controller.ticket).to be_new_record
        end

        it 'ticket default sou_type' do
          expect(controller.ticket.sou_type).to be_nil
        end

        it 'answer' do
          expect(controller.ticket.answers.first).to be_new_record
        end

        context 'ticket_type based on params' do
          it 'sou ticket_type' do
            get(:new, params: { ticket_type: :sou })
            expect(controller.ticket).to be_sou
          end

          it 'sic ticket_type' do
            get(:new, params: { ticket_type: :sic })
            expect(controller.ticket).to be_sic
          end
        end

        it 'classification_other_organs' do
          topic = create(:topic, :other_organs)
          subtopic = create(:subtopic, :other_organs)
          service_type = create(:service_type, :other_organs)
          budget_program = create(:budget_program, :other_organs)

          expect(controller.classification_other_organs.topic).to eq(topic)
          expect(controller.classification_other_organs.subtopic).to eq(subtopic)
          expect(controller.classification_other_organs.service_type).to eq(service_type)
          expect(controller.classification_other_organs.budget_program).to eq(budget_program)
          expect(controller.classification_other_organs.department).to eq(nil)
          expect(controller.classification_other_organs.sub_department).to eq(nil)
        end
      end

      context 'unknown_classification' do
        context 'as cge' do
          let(:user) { create(:user, :operator_cge) }

          before { get(:new) }

          it { expect(controller.ticket).to be_unknown_classification }
        end

        context 'other operators' do
          let(:user) { create(:user, :operator_sectoral) }

          before { get(:new) }

          it { expect(controller.ticket).not_to be_unknown_classification }
        end
      end
    end
  end

  describe '#create' do
    let(:valid_ticket) { build(:ticket).attributes }
    let(:invalid_ticket) { build(:ticket, :invalid).attributes }
    let(:ticket_denunciation) { build(:ticket, :denunciation).attributes }
    let(:created_ticket) { controller.ticket }
    let(:created_child) { created_ticket.tickets.first }
    let(:organ) { create(:executive_organ) }

    context 'unauthorized' do
      before { post(:create, params: { ticket: valid_ticket }) }
      it { is_expected.to redirect_to(new_user_session_path) }
    end

    context 'authorized' do

      before { sign_in(user) }

      it 'permits ticket params' do
        should permit(*permitted_params).for(:create, params: { ticket: valid_ticket })
      end

      context 'valid' do
        it 'saves' do
          ticket = build(:ticket, ticket_type: :sou).attributes
          expect do
            post(:create, params: { ticket: ticket })

            expect(response).to redirect_to(operator_ticket_path(created_ticket))
          end.to change(Ticket, :count).by(1)
        end

        describe 'saves confirmation' do
          # quando o usuário salva o form, precisamos setar o
          # flash 'from_confirmation' para que o show possa exibir
          # a mensagem de sucesso para o usuário.

          let(:confirmed_at) { Date.today }

          context 'unknown organ' do
            before { post(:create, params: { ticket: valid_ticket }) }

            # o flash é usado para exibir a mensagem específica avisando ao usuário
            # que sua manifestação foi recebida!

            it { expect(controller).to set_flash[:from_confirmation].to(true) }
            it { expect(response).to redirect_to(operator_ticket_path(created_ticket)) }

            it { expect(created_ticket).to be_confirmed }
            it { expect(created_ticket).to be_waiting_referral }
            it { expect(created_ticket.parent_unknown_organ).to be_truthy }
            it { expect(created_ticket.confirmed_at.to_date).to eq(confirmed_at) }
          end

          describe 'set_ticket_user' do
            it 'call set ticket_user' do
              ticket_params = build(:ticket, ticket_type: :sou).attributes

              service = double
              allow(SetTicketUser).to receive(:delay) { service }
              allow(service).to receive(:call)

              post(:create, params: { ticket: ticket_params })

              ticket_created = Ticket.last

              expect(service).to have_received(:call).with(ticket_created.id)
            end
          end

          context 'knowledge organ' do
            let(:child_ticket) { created_ticket.tickets.first }


            before do
              allow(RegisterTicketLog).to receive(:call)

              valid_ticket["organ_id"] = organ.id
              valid_ticket["unknown_organ"] = false
              post(:create, params: { ticket: valid_ticket })
            end
            it { expect(created_ticket).to be_confirmed }
            it { expect(created_ticket).to be_sectoral_attendance }
            it { expect(created_ticket.confirmed_at.to_date).to eq(confirmed_at) }
            it { expect(created_ticket.organ_id).to be_nil }

            it { expect(child_ticket).to be_confirmed }
            it { expect(child_ticket).to be_sectoral_attendance }
            it { expect(child_ticket.confirmed_at.to_date).to eq(confirmed_at) }
            it { expect(child_ticket.parent_id).to eq(created_ticket.id) }
            it { expect(child_ticket.organ).to eq(organ) }
            it { expect(child_ticket.parent_unknown_organ).to be_falsey }

            it 'register ticket log' do
              expect(RegisterTicketLog).to have_received(:call).with(created_ticket, user, :share, { resource: child_ticket.organ } )
            end
          end

          context 'register ticket log' do
            it 'for confirmation' do
              allow(RegisterTicketLog).to receive(:call)

              post(:create, params: { ticket: valid_ticket })

              data = { responsible_as_author: user.as_author }

              expect(RegisterTicketLog).to have_received(:call).with(created_ticket, user, :confirm, { data: data })
            end

            it 'for classification' do
              valid_ticket = build(:ticket, :with_parent, unknown_classification: false).attributes
              valid_ticket[:classification_attributes] = build(:classification).attributes

              allow(RegisterTicketLog).to receive(:call)

              post(:create, params: { ticket: valid_ticket })

              expect(RegisterTicketLog).to have_received(:call).with(created_child, user, :create_classification, { resource: created_child })
              expect(RegisterTicketLog).to have_received(:call).with(created_ticket, user, :create_classification, { resource: created_child })
            end

            it 'for priority' do
              valid_ticket = build(:ticket, :with_parent, priority: '1').attributes

              allow(RegisterTicketLog).to receive(:call)

              post(:create, params: { ticket: valid_ticket })

              expect(RegisterTicketLog).to have_received(:call).with(created_ticket, user, :priority, { resource: created_ticket })
            end
          end

          context 'set deadline' do
            let(:deadline) { Holiday.next_weekday(Ticket.response_deadline(:sou)) }
            let(:deadline_ends_at) { Date.today + deadline }
            before { post(:create, params: { ticket: valid_ticket }) }

            it { expect(created_ticket.deadline).to eq(deadline) }
            it { expect(created_ticket.deadline_ends_at).to eq(deadline_ends_at) }
          end
        end

        it 'sets created_by' do
          ticket = build(:ticket).attributes
          post(:create, params: { ticket: ticket })

          expect(controller.ticket.created_by).to eq user
          expect(controller.ticket).not_to be_anonymous
          expect(controller.ticket).to be_identified
        end

        context 'set unknown_classification = false when immediate_answer' do
          let(:ticket) do
            valid_ticket['unknown_classification'] = true
            valid_ticket['immediate_answer'] = true
            valid_ticket['answers_attributes'] = {
              '1': {
                description: 'resposta ao cidadão',
                answer_type: :final,
                answer_scope: :sectoral,
                status: :cge_approved,
                classification: :sou_demand_well_founded
              }
            }

            valid_ticket
          end

          before { post(:create, params: { ticket: ticket }) }

          it { expect(controller.ticket.unknown_classification).to be_falsey }
        end

        context 'with attachment' do

          let(:ticket_with_attachment) do
            valid_ticket[:attachments_attributes] = {
              '1': {
                document: attachment
              }
            }
            valid_ticket
          end

          it 'saves' do
            post(:create, params: { ticket: ticket_with_attachment })

            expect(controller.ticket.attachments.count).to eq(1)
          end

          it 'register ticket_log for attachments' do
            allow(RegisterTicketLog).to receive(:call).with(anything, user, :confirm, anything)
            allow(RegisterTicketLog).to receive(:call).with(anything, user, :create_attachment, anything)

            post(:create, params: { ticket: ticket_with_attachment })

            created_attachment = created_ticket.attachments.first

            expect(RegisterTicketLog).to have_received(:call).with(created_ticket, user, :create_attachment, { resource: created_attachment })
          end
        end

        context 'with immediate_answer' do

          let(:operator_sectoral) { create(:user, :operator_sectoral) }
          let(:department) { create(:department) }
          let(:ticket_with_answer) do
            valid_ticket['organ_id'] = operator_sectoral.organ_id
            valid_ticket['unknown_organ'] = false
            valid_ticket['immediate_answer'] = '1'
            valid_ticket['answers_attributes'] = {
              '1': {
                description: 'resposta ao cidadão',
                answer_type: :final,
                answer_scope: :sectoral,
                status: :cge_approved,
                classification: :sou_demand_well_founded
              }
            }
            valid_ticket['classification_attributes'] = {
              topic_id: create(:topic).id,
              budget_program_id: create(:budget_program).id,
              department_id: department.id,
              sub_department_id: create(:sub_department, department: department).id
            }

            valid_ticket
          end

          let(:parent) { controller.ticket }
          let(:child) { parent.tickets.first }

          before { sign_in(operator_sectoral) }

          it 'create answer' do
            post(:create, params: { ticket: ticket_with_answer })

            answer_child = child.answers.first

            expect(answer_child.sectoral?).to be_truthy
            expect(answer_child.cge_approved?).to be_truthy
          end

          it 'operator subnet' do
            operator_subnet = create(:user, :operator_subnet)
            ticket_with_answer['subnet_id'] = operator_subnet.subnet_id
            ticket_with_answer['organ_id'] = operator_subnet.subnet.organ_id

            sign_in(operator_subnet)
            post(:create, params: { ticket: ticket_with_answer })

            answer = child.answers.first
            expect(answer).to be_present
          end

          it 'operator cge' do
            operator_cge = create(:user, :operator_cge)

            sign_in(operator_cge)
            post(:create, params: { ticket: ticket_with_answer })

            answer = child.answers.first
            expect(answer).to be_present
          end

          it 'operator coordination' do
            operator_coordination = create(:user, :operator_coordination)

            sign_in(operator_coordination)
            post(:create, params: { ticket: ticket_with_answer })

            answer = child.answers.first
            expect(answer).to be_present
          end

          context 'other organ' do
            let(:other_organ) { create(:executive_organ) }

            before { ticket_with_answer['organ_id'] = other_organ }

            it 'does not save' do
              expect do
                post(:create, params: { ticket: ticket_with_answer })

                expect(response).to render_template('operator/tickets/new')
              end.to change(Ticket, :count).by(0)
            end
          end

          it 'answer classification' do
            ticket_with_answer['answers_attributes'][:'1']['classification'] = 'sou_demand_well_founded'

            post(:create, params: { ticket: ticket_with_answer })

            answer = child.answers.first

            expect(answer).to be_sou_demand_well_founded
          end

          it 'create child' do
            post(:create, params: { ticket: ticket_with_answer })

            expect(controller.ticket.parent?).to be_truthy
            expect(controller.ticket.tickets.first).to be_present
          end

          it 'change ticket status' do
            post(:create, params: { ticket: ticket_with_answer })

            expect(parent).to be_final_answer
            expect(parent.call_center_status).to be_nil

            expect(parent).to be_final_answer
            expect(child.call_center_status).to be_nil
          end

          it 'change call_center_status when answer_type phone' do
            ticket_with_answer[:answer_type] = :phone
            ticket_with_answer[:answer_phone] = "(11) 91111-1111"

            post(:create, params: { ticket: ticket_with_answer })

            expect(controller.ticket.final_answer?).to be_truthy
            expect(controller.ticket).to be_waiting_allocation
          end
        end

        it 'ticket type denunciation set unknown_organ true' do
          expect do
            post(:create, params: { ticket: ticket_denunciation })

            expect(created_ticket.unknown_organ).to be_truthy
            expect(created_ticket.organ).to be_nil
          end.to change(Ticket, :count).by(1)
        end

        it 'set_deadline for sou' do
          deadline_ends_at = Date.today + Holiday.next_weekday(Ticket::SOU_DEADLINE)

          post(:create, params: { ticket: valid_ticket, ticket_type: :sou })

          expect(controller.ticket.deadline_ends_at).to eq(deadline_ends_at)
        end

        it 'set_deadline for sic' do
          deadline_ends_at = Date.today + Holiday.next_weekday(Ticket::SIC_DEADLINE)

          post(:create, params: { ticket: valid_ticket, ticket_type: :sic })

          expect(controller.ticket.deadline_ends_at).to eq(deadline_ends_at)
        end

        context 'with operator sectoral' do
          let(:user) { create(:user, :operator_sectoral) }
          let(:other_organ) { create(:executive_organ) }

          let(:ticket) { build(:ticket, :with_parent, organ: user.organ, created_by: user) }
          let(:ticket_other_organ) { build(:ticket, :with_parent, organ: other_organ, created_by: user) }
          let(:ticket_subnet) { build(:ticket, :with_subnet, created_by: user) }


          let(:ticket_params) { {params: {ticket: ticket.attributes}} }
          let(:ticket_other_organ_params) { {params: {ticket: ticket_other_organ.attributes}} }
          let(:ticket_subnet_params) { {params: {ticket: ticket_subnet.attributes}} }

          let(:created_ticket) { Ticket.last }

          before { sign_in(user) }

          context 'ticket child created with same organ of sectoral' do
            before do
              allow(RegisterTicketLog).to receive(:call)
              post(:create, ticket_params)
            end

            it 'redirect_to' do
              expect(response).to redirect_to(operator_ticket_path(created_ticket))
            end

            context 'register ticket log' do
              it 'for confirmation' do
                data = { responsible_as_author: user.as_author }

                expect(RegisterTicketLog).to have_received(:call).with(created_ticket.parent, user, :confirm, { data: data })
              end
            end
          end

          context 'ticket child created with different organ of sectoral' do
            before do
              allow(controller).to receive(:can?).and_return(false)
            end

            it 'redirect_to' do
              post(:create, ticket_params)

              expect(response).to redirect_to(operator_tickets_path)
            end
          end

          context 'ticket parent created with other organ of sectoral' do
            before { post(:create, ticket_other_organ_params) }

            it 'redirect_to' do
              expect(response).to redirect_to(operator_ticket_path(created_ticket.parent))
            end
          end

          context 'ticket parent created with subnet' do
            before { post(:create, ticket_subnet_params) }

            it 'redirect_to' do
              parent_ticket = created_ticket.parent || created_ticket

              expect(response).to redirect_to(operator_ticket_path(parent_ticket))
            end
          end
        end

      end

      context 'invalid' do
        render_views

        it 'does not save' do
          expect do
            post(:create, params: { ticket: invalid_ticket })

            expect(response).to render_template('operator/tickets/new')
          end.to change(Ticket, :count).by(0)
        end
      end

      context 'before_validation' do
        it 'saves cnpj' do
          valid_ticket[:person_type] = :legal
          post(:create, params: { ticket: valid_ticket })

          expect(controller.ticket.document_type).to eq('cnpj')
        end

        it 'dont saves cnpj' do
          valid_ticket[:person_type] = :individual
          valid_ticket[:document_type] = :other
          post(:create, params: { ticket: valid_ticket })

          expect(controller.ticket.document_type).to eq('other')
        end
      end

      context 'helpers' do
        it 'ticket' do
          expect(controller.ticket).to be_new_record
        end
      end
    end
  end

  describe '#show' do
    context 'unauthorized' do
      before { get(:show, params: { id: ticket }) }

      it { is_expected.to redirect_to(new_user_session_path) }
    end

    context 'authorized' do
      render_views
      let(:service) { double }
      before do
        sign_in(user)
        allow(Notifier::NewTicket).to receive(:delay) { service }
        allow(service).to receive(:call)
      end

      context 'confirmed' do

        before { get(:show, params: { id: confirmed_ticket }) }

        it { is_expected.to render_template('operator/tickets/show') }
        it { is_expected.to render_template('shared/tickets/_confirmed') }
        it { is_expected.not_to render_template('shared/tickets/_unconfirmed') }
        it { is_expected.to render_template('shared/tickets/_show') }

        it 'create ticket password' do
          expect(controller.ticket.password).not_to be_empty
        end

        it 'notify' do
          expect(service).to have_received(:call).with(confirmed_ticket.id)
        end

      end

      context 'sectoral redirect to new ticket' do
        let(:user) { create(:user, :operator_sectoral) }
        let(:ticket) { create(:ticket, :with_parent, organ: user.organ) }

        before { get(:show, params: { id: ticket }) }

        it { is_expected.to render_template('operator/tickets/show') }
        it { is_expected.to render_template('shared/tickets/_confirmed') }
        it { is_expected.not_to render_template('shared/tickets/_unconfirmed') }
        it { is_expected.to render_template('shared/tickets/_show') }

        it 'create ticket password' do
          expect(controller.ticket.parent.password).not_to be_empty
        end

        it 'notify' do
          expect(service).to have_received(:call).with(ticket.parent_id)
        end
      end

      context 'with password was created' do
        it 'not notify' do
          ticket_with_password = create(:ticket, :confirmed, password: 'pass')

          get(:show, params: { id: ticket_with_password })

          expect(service).not_to have_received(:call).with(ticket_with_password.id)
        end
      end

      context 'print' do
        it 'operators' do
          get(:show, params: { id: confirmed_ticket, print: true })

          is_expected.to render_template('shared/tickets/print')
        end
      end

      context 'helpers' do

        let(:ticket_child) { create(:ticket, :with_parent, parent: ticket) }

        before { get(:show, params: { id: ticket }) }

        it 'ticket' do
          expect(controller.ticket).to eq(ticket)
        end

        it 'new_comment' do
          # criamos um novo comentário pra ser usado no form.

          get(:show, params: { id: ticket })

          expect(controller.new_comment).to be_present
          expect(controller.new_comment.commentable).to eq(ticket)
        end

        it 'new_answer' do
          # criamos um novo comentário pra ser usado no form.

          get(:show, params: { id: ticket })

          expect(controller.new_answer).to be_present
          expect(controller.new_answer.ticket).to eq(ticket)
        end

        it 'justification' do
          expect(controller.justification).to be_nil
        end

        context 'ticket_children' do

          it 'with parent' do
            get(:show, params: { id: ticket })

            expect(controller.ticket_children).to eq(ticket.sorted_tickets)
          end

          it 'with child' do
            get(:show, params: { id: ticket_child })

            expect(controller.ticket_children).to eq(ticket.sorted_tickets)
          end
        end
      end

      it 'build attendance_evaluation' do
        get(:show, params: { id: ticket })

        expect(controller.ticket.attendance_evaluation).not_to be_nil
      end
    end

    context 'forbbiden' do
      let(:sectoral_organ) { create(:executive_organ) }
      let(:internal_department) { create(:department) }

      let(:operator_cge) { create(:user, :operator_cge) }
      let(:operator_sectoral) { create(:user, :operator_sectoral, organ: sectoral_organ) }
      let(:operator_internal) { create(:user, :operator_internal, department: internal_department, organ: internal_department.organ) }

      let(:child_ticket) { create(:ticket, :with_parent) }
      let(:sectoral_ticket) { create(:ticket, :confirmed, :with_organ, organ: sectoral_organ, internal_status: :sectoral_attendance) }
      let(:internal_ticket) { create(:ticket, :confirmed, :with_organ, organ: sectoral_organ, internal_status: :internal_attendance) }

      context 'for operator_sectoral' do
        before do
          sign_in(operator_sectoral)
          get(:show, params: { id: child_ticket })
        end

        it { is_expected.to respond_with(:forbidden) }
      end

      context 'for operator_internal' do
        before do
          sign_in(operator_internal)
          get(:show, params: { id: sectoral_ticket })
        end

        it { is_expected.to respond_with(:forbidden) }
      end

    end

  end

  describe '#edit' do
    context 'unauthorized' do
      before { get(:edit, params: { id: ticket }) }

      it { is_expected.to redirect_to(new_user_session_path) }
    end

    context 'authorized' do
      before do
        ability_klass = "Abilities::Users::Operator::#{user.operator_type.classify}".constantize
        allow_any_instance_of(ability_klass).to receive(:can?).and_return(true)

        sign_in(user)
        get(:edit, params: { id: ticket })
      end

      context 'template' do
        render_views

        it { is_expected.to respond_with(:success) }
        it { is_expected.to render_template('operator/tickets/edit') }
        it { is_expected.to render_template('operator/tickets/_form') }
      end

      context 'helpers' do
        it 'ticket' do
          expect(controller.ticket).to eq(ticket)
        end
      end
    end
  end

  describe '#update' do
    let(:user) { create(:user, :operator_sou_sectoral) }

    let(:ticket) { create(:ticket, :with_parent, organ: user.organ) }
    let(:valid_ticket) { ticket }
    let(:invalid_ticket) do
      ticket = create(:ticket, :with_parent, organ: user.organ)
      ticket.description = nil
      ticket
    end
    let(:valid_ticket_with_organ) { create(:ticket, :with_organ, created_by: user) }


    let(:valid_ticket_with_organ_attributes) { valid_ticket_with_organ.attributes }
    let(:valid_ticket_with_organ_params) { { id: valid_ticket_with_organ, ticket: valid_ticket_with_organ_attributes } }

    let(:valid_ticket_attributes) { valid_ticket.attributes }
    let(:valid_ticket_params) { { id: ticket, ticket: valid_ticket_attributes } }
    let(:invalid_ticket_params) do
      { id: invalid_ticket, ticket: invalid_ticket.attributes }
    end

    context 'unauthorized' do
      before { patch(:update, params: valid_ticket_params) }

      it { is_expected.to redirect_to(new_user_session_path) }
    end

    context 'authorized' do
      before { sign_in(user) }

      it 'permits ticket params' do
        should permit(*permitted_params).for(:update, params: valid_ticket_params )
      end

      context 'valid' do
        it 'saves' do
          valid_ticket_params[:ticket][:name] = 'new name'
          patch(:update, params: valid_ticket_params)

          expect(response).to redirect_to(operator_ticket_path(ticket))

          valid_ticket.reload

          expected_flash = I18n.t("operator.tickets.update.#{ticket.ticket_type}.done",
            title: valid_ticket.title)

          expect(valid_ticket.name).to eq('new name')
          expect(controller).to set_flash.to(expected_flash)
        end

        it 'sets updated_by' do
          patch(:update, params: valid_ticket_params)

          valid_ticket.reload

          expect(valid_ticket.updated_by).to eq user
        end

        context 'register log' do
          it 'with ticket changes' do
            ticket_attributes = { name: 'name changed' }
            ticket_params = { id: ticket, ticket: ticket_attributes }
            ticket_params[:ticket]['name'] = 'name changed'

            ticket_changes = {
              "updated_by_id"=>[nil, user.id],
              "name"=>["Fulano de Tal", "name changed"]
            }

            data_attributes = {
              responsible_as_author: user.as_author,
              ticket_changes: ticket_changes
            }

            allow(RegisterTicketLog).to receive(:call)

            patch(:update, params: ticket_params)

            expect(RegisterTicketLog).to have_received(:call).with(ticket.parent, user, :update_ticket, { data: data_attributes })
          end

          it 'without ticket changes' do
            allow(RegisterTicketLog).to receive(:call)

            patch(:update, params: { id: ticket, ticket: { name: ticket.name } })

            expect(RegisterTicketLog).to_not have_received(:call)
          end
        end

        context 'saves with attachment' do
          let(:ticket_with_attachment_params) do
            valid_ticket_params[:ticket][:attachments_attributes] = {
              "1": {
                "document": attachment
              }
            }
            valid_ticket_params
          end

          before { patch(:update, params: ticket_with_attachment_params) }

          it { expect(controller.ticket.attachments.count).to eq(1) }
        end
      end

      context 'invalid' do
        render_views

        it 'does not save' do
          patch(:update, params: invalid_ticket_params)
          expect(response).to render_template('operator/tickets/edit')
        end
      end

      context 'before_validation' do
        it 'update cnpj' do
          valid_ticket_params[:ticket][:person_type] = :legal
          patch(:update, params: valid_ticket_params)

          expect(controller.ticket.document_type).to eq('cnpj')
        end

        it 'dont update cnpj' do
          valid_ticket_params[:ticket][:person_type] = :individual
          valid_ticket_params[:ticket][:document_type] = :other
          patch(:update, params: valid_ticket_params)

          expect(controller.ticket.document_type).to eq('other')
        end
      end

      context 'helpers' do
        it 'ticket' do
          patch(:update, params: valid_ticket_params)
          expect(controller.ticket).to eq(valid_ticket)
        end
      end
    end
  end

  describe '#history' do
    context 'unauthorized' do
      before { get(:history, params: { id: ticket }) }

      it { is_expected.to redirect_to(new_user_session_path) }
    end

    context 'authorized' do
      render_views
      before { sign_in(user) && get(:history, params: { id: ticket }) }

      it { is_expected.to render_template('shared/tickets/ticket_logs/_history') }

      it { expect(controller.ticket).to eq(ticket) }
    end

  end

  describe '#all_ticket_departments' do
    let(:operator_internal) { create(:user, :operator_internal) }
    let(:ticket) { create(:ticket) }
    let(:ticket_with_parent) { create(:ticket, :with_parent) }
    let(:ticket_department) { create(:ticket_department, ticket: ticket, department: operator_internal.department) }
    let(:ticket_department_with_parent) { create(:ticket_department, ticket: ticket_with_parent, department: operator_internal.department) }

    context 'when the ticket is a child and has department' do
      it 'return department' do
        get(:show, params: { id: ticket_department_with_parent.ticket })

        expect(controller.all_ticket_departments).to eq([ticket_department_with_parent])
      end
    end

    context 'when the ticket hasnt department' do
      it 'return department' do
        get(:show, params: { id: ticket })

        expect(controller.all_ticket_departments).to eq([])
      end
    end

    context 'when the ticket hasnt a child' do
      it 'return array empty' do
        get(:show, params: { id: ticket_department.ticket })
        expect(controller.all_ticket_departments).to eq([])
      end
    end

    context 'when the ticket hasnt a child but has childs with with department' do
      it 'return child department' do
        parent_ticket = ticket_department_with_parent.ticket.parent
        get(:show, params: { id: parent_ticket })

        expect(controller.all_ticket_departments).to eq([ticket_department_with_parent])
      end
    end
  end
end
