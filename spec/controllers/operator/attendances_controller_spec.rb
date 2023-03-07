require 'rails_helper'

describe Operator::AttendancesController do

  let(:user) { create(:user, :operator_call_center) }
  let(:attendance) do
    att = build(:attendance)
    att.save(validate: false)
    att.reload
  end

  let(:permitted_params) do
    [
      :id,
      :protocol,
      :description,
      :service_type,
      :answer,
      :unknown_organ,

      attendance_organ_subnets_attributes: [
        :id,
        :organ_id,
        :subnet_id,
        :unknown_subnet,
        :_destroy
      ],

      ticket_attributes: [
        :id,
        :name,
        :social_name,
        :gender,
        :email,
        :sou_type,
        :status,
        :priority,

        :answer_type,
        :answer_phone,
        :answer_cell_phone,
        :answer_whatsapp,

        :city_id,
        :answer_address_street,
        :answer_address_number,
        :answer_address_zipcode,
        :answer_address_neighborhood,
        :answer_address_complement,
        :answer_twitter,
        :answer_facebook,
        :answer_instagram,

        :document_type,
        :document,
        :person_type,
        :used_input,
        :used_input_url,
        :anonymous,

        :denunciation_description,
        :denunciation_organ_id,
        :denunciation_date,
        :denunciation_place,
        :denunciation_witness,
        :denunciation_evidence,
        :denunciation_assurance,

        :target_address_zipcode,
        :target_city_id,
        :target_address_street,
        :target_address_number,
        :target_address_neighborhood,
        :target_address_complement,

        classification_attributes: [
          :other_organs
        ]
      ]
    ]
  end

  describe '#index' do
    context 'unauthorized' do
      before { get(:index) }

      it { is_expected.to redirect_to(new_user_session_path) }
    end

    context 'authorized' do
      before { sign_in(user) && get(:index) }

      context 'template' do
        render_views

        it { is_expected.to respond_with(:success) }
      end

      describe 'helper methods' do
        it 'attendances' do
          expect(controller.attendances).to eq([attendance])
        end
      end

      context 'pagination' do
        it 'calls kaminari methods' do
          allow(Attendance).to receive(:page).and_call_original
          expect(Attendance).to receive(:page).and_call_original

          get(:index)

          # para poder acionar o método page que estamos testando

          controller.attendances
        end
      end

      context 'search' do
        it 'protocol' do
          attendance = create(:attendance, protocol: '1234')
          other_attendance = create(:attendance, protocol: '4321')

          get(:index, params: { parent_protocol: attendance.protocol })

          expect(controller.attendances).to eq([attendance])
        end

        it 'dont show with partial protocol' do
          attendance = create(:attendance, protocol: '1234')
          other_attendance = create(:attendance, protocol: '4321')
          partial_protocol = attendance.protocol.to_s.first(3)

          get(:index, params: { search: attendance.protocol, parent_protocol: partial_protocol })

          expect(controller.attendances).to eq([])
        end
      end

      context 'filters' do

        it 'service_type' do
          attendance = create(:attendance, service_type: :incorrect_click)
          other_attendance = create(:attendance, service_type: :noise)
          create(:attendance)

          get(:index, params: { service_type: [:incorrect_click, :noise] })
          expect(controller.attendances).to match_array([attendance, other_attendance])
        end

        it 'created_by' do
          attendance = create(:attendance, created_by: user)
          create(:attendance)

          get(:index, params: { created_by_id: user.id })
          expect(controller.attendances).to eq([attendance])
        end

        it 'ticket_type' do
          sou_ticket = create(:ticket, ticket_type: :sou)
          another_type_ticket = create(:ticket, ticket_type: :sic)

          attendance = create(:attendance, ticket: sou_ticket)
          create(:attendance, ticket: another_type_ticket)

          get(:index, params: { ticket_type: :sou })
          expect(controller.attendances).to eq([attendance])
        end

        it 'sou_type' do
          ticket_compliment = create(:ticket, :confirmed, sou_type: :compliment)
          ticket_suggestion = create(:ticket, :confirmed, sou_type: :suggestion)

          attendance = create(:attendance, ticket: ticket_compliment)
          create(:attendance, ticket: ticket_suggestion)

          get(:index, params: { sou_type: :compliment})

          expect(controller.attendances).to eq([attendance])
        end

        it 'organ_id' do
          ticket = create(:ticket, :with_parent)

          attendance = create(:attendance, ticket: ticket.parent)
          create(:attendance)

          get(:index, params: { organ_id: ticket.organ_id })
          expect(controller.attendances).to eq([attendance])
        end

        it 'internal_status' do
          ticket = create(:ticket, internal_status: :sectoral_attendance)
          another_ticket = create(:ticket)

          attendance = create(:attendance, ticket: ticket)
          create(:attendance, ticket: another_ticket)

          get(:index, params: { internal_status: :sectoral_attendance })
          expect(controller.attendances).to eq([attendance])
        end

        it 'call_center_responsible_id' do
          ticket = create(:ticket, call_center_responsible: user)
          another_ticket = create(:ticket)

          attendance = create(:attendance, ticket: ticket)
          create(:attendance, ticket: another_ticket)

          get(:index, params: { call_center_responsible_id: user.id })
          expect(controller.attendances).to eq([attendance])

        end

        it 'answer_type' do
          ticket = create(:ticket, :confirmed, answer_type: :phone)
          another_ticket = create(:ticket, answer_type: :default)

          attendance = create(:attendance, ticket: ticket)
          create(:attendance, ticket: another_ticket)

          get(:index, params: { answer_type: :phone })

          expect(controller.attendances).to eq([attendance])
        end

        it 'deadline' do
          ticket = create(:ticket, :confirmed, deadline: -15)
          another_ticket = create(:ticket, deadline: 10)

          attendance = create(:attendance, ticket: ticket)
          create(:attendance, ticket: another_ticket)

          get(:index, params: { deadline: :expired_can_extend })

          expect(controller.attendances).to eq([attendance])
        end

        context 'created_at' do

          before do
            ticket_one = create(:ticket, :confirmed, created_at: Date.new(2001,2,3))
            ticket_two = create(:ticket, :confirmed, created_at: Date.new(2002,2,3))
            ticket_three = create(:ticket, :confirmed, created_at: Date.new(2005,2,3))

            create(:attendance, ticket: ticket_one, created_at: Time.zone.parse('2001-2-3 1:00'))
            create(:attendance, ticket: ticket_two, created_at: Time.zone.parse('2002-2-3 1:00'))
            create(:attendance, ticket: ticket_three, created_at: Time.zone.parse('2005-2-3 1:00'))
          end

          it 'after date' do
            created_at = {
              start: '01/01/2016',
              end: ''
            }

            get(:index, params: { created_at: created_at })

            expect(controller.attendances.size).to eq(0)
          end

          it 'in date' do
            created_at = {
              start: '01/01/2000',
              end: '01/01/2004'
            }

            get(:index, params: { created_at: created_at })

            expect(controller.attendances.size).to eq(2)
          end

          it 'before date' do
            created_at = {
              start: '',
              end: '01/01/2000'
            }

            get(:index, params: { created_at: created_at })

            expect(controller.attendances.size).to eq(0)
          end

          it 'same day' do
            created_at = {
              start: '03/02/2001',
              end: '03/02/2001'
            }

            get(:index, params: { created_at: created_at })

            expect(controller.attendances.size).to eq(1)
          end
        end
      end

      describe '#sort' do

        it 'sort_columns helper' do
          expected = [
            'attendances.created_at',
            'attendances.protocol',
            'attendances.service_type'
          ]

          expect(controller.sort_columns).to eq(expected)
        end

        it 'default' do
          first_unsorted = create(:attendance, protocol: '321')
          last_unsorted = create(:attendance, protocol: '123')

          first_unsorted
          last_unsorted

          get(:index)

          expect(controller.attendances).to eq([first_unsorted, last_unsorted])
        end

        it 'sort_column param' do
          get(:index, params: { sort_column: 'attendances.protocol'})

          join = Attendance.includes(:ticket).references(:ticket)
          sorted = join.sorted('attendances.protocol', 'desc')
          filtered = sorted
          paginated = filtered.page(controller.params[:page]).per(controller.class::PER_PAGE)
          expected = paginated.to_sql

          result = controller.attendances.to_sql

          expect(result).to eq(expected)
        end

        it 'sort_direction param' do
          get(:index, params: { sort_column: 'attendances.protocol', sort_direction: :asc })

          join = Attendance.includes(:ticket).references(:ticket)
          sorted = join.sorted('attendances.protocol')
          filtered = sorted
          paginated = filtered.page(controller.params[:page]).per(controller.class::PER_PAGE)
          expected = paginated.to_sql

          result = controller.attendances.to_sql

          expect(result).to eq(expected)
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
      before { sign_in(user) && get(:new) }

      context 'template' do
        it { is_expected.to redirect_to(edit_operator_attendance_path(controller.attendance)) }
      end

      context 'default attributes' do
        it 'created_by' do
          expect(controller.attendance.created_by).to eq(user)
        end

        it 'service_type' do
          expect(controller.attendance.incorrect_click?).to be_truthy
        end
      end

      context 'helpers' do
        it 'attendance' do
          expect(controller.attendance).to be_persisted
        end

        it 'occurrences' do
          expect(controller.occurrences.count).to eq(1)
        end
      end
    end
  end

  describe '#show' do
    context 'unauthorized' do
      before { get(:show, params: { id: attendance }) }

      it { is_expected.to redirect_to(new_user_session_path) }
    end

    context 'authorized' do
      let(:attendance) {  create(:attendance, :with_confirmed_ticket) }

      render_views

      before { sign_in(user) }

      context 'confirmed' do

      before { get(:show, params: { id: attendance }) }

        it { is_expected.to render_template('operator/attendances/show') }
        it { is_expected.to render_template('operator/attendances/_show') }
        it { is_expected.to render_template('operator/attendances/_confirmed') }
        it { is_expected.to render_template('operator/attendances/_ticket') }
      end

      context 'unconfirmed' do
        let(:attendance) {  create(:attendance, :with_ticket) }

        before { get(:show, params: { id: attendance }) }

        it { is_expected.to render_template('operator/attendances/show') }
        it { is_expected.to render_template('operator/attendances/_show') }
        it { is_expected.to render_template('operator/attendances/_unconfirmed') }
        it { is_expected.to render_template('operator/attendances/_ticket') }
      end

      context 'helpers' do

        before { get(:show, params: { id: attendance }) }

        it 'attendance' do
          expect(controller.attendance).to eq(attendance)
        end

        it 'ticket' do
          expect(controller.ticket).to eq(attendance.ticket)
        end

        it 'occurrence' do
          expect(controller.new_occurrence).to be_kind_of(Occurrence)
        end

        it 'comment' do
          expect(controller.new_comment).to be_new_record
          expect(controller.new_comment.commentable).to eq(attendance.ticket)
        end

        context 'readonly?' do
          it { expect(controller.readonly?).to be_falsey }
        end

        it 'new_evaluation' do
          get(:show, params: { id: attendance })

          expect(controller.new_evaluation).to be_present
          expect(controller.new_evaluation.call_center?).to be_truthy
        end
      end

      context 'ticket password' do

        context 'confirmed' do

          let(:attendance) {  create(:attendance, :with_confirmed_ticket) }
          let(:ticket) {  attendance.ticket }

          context 'with empty password' do

            before { ticket.update_attribute(:password, '') }

            context 'generates password' do
              let(:service) { double }

              before do
                allow(Notifier::NewTicket).to receive(:delay) { service }
                allow(service).to receive(:call)

                get(:show, params: { id: attendance })
              end

              it { expect(controller.ticket.password).not_to be_empty }

              it 'notify' do
                expect(service).to have_received(:call).with(attendance.ticket.id)
              end
            end
          end

          context 'already with password' do

            before { ticket.update_attribute(:password, 'password') }

            context 'not generate password' do
              let(:service) { double }

              before do
                allow(Notifier::NewTicket).to receive(:delay) { service }
                allow(service).to receive(:call)

                get(:show, params: { id: attendance })
              end

              it { expect(controller.ticket.password).to eq(nil) }

              it 'notify' do
                expect(service).not_to have_received(:call).with(attendance.ticket.id)
              end
            end
          end
        end

        context 'unconfirmed' do

          let(:attendance) {  create(:attendance, :with_ticket) }
          let(:ticket) {  attendance.ticket }

          it 'not generate password' do
            get(:show, params: { id: attendance })

            expect(controller.ticket.password).to eq(nil)
          end
        end
      end
    end
  end


  describe '#edit' do
    context 'unauthorized' do
      before { get(:edit, params: { id: attendance }) }

      it { is_expected.to redirect_to(new_user_session_path) }
    end

    context 'authorized' do
      before { sign_in(user) }

      context 'template' do
        before { get(:edit, params: { id: attendance }) }

        render_views

        it { is_expected.to respond_with(:success) }
        it { is_expected.to render_template('operator/attendances/edit') }
        it { is_expected.to render_template('operator/attendances/_form') }
      end

      context 'clone attendance' do
        let(:cloned_attendance) { create(:attendance) }
        let(:new_attendance) { Attendance.create(service_type: :incorrect_click) }

        context 'redirect to #edit' do

          before { get(:new, params: { clone_id: cloned_attendance.id }) }

          it { expect(controller).to redirect_to(edit_operator_attendance_path(controller.attendance, clone_id: cloned_attendance.id)) }
        end

        context 'invoke service' do
          before do
            allow(Attendance::CloneService).to receive(:call)
            get(:edit, params: { id: new_attendance, clone_id: cloned_attendance.id })
          end

          it { expect(Attendance::CloneService).to have_received(:call).with(user, cloned_attendance.id.to_s, new_attendance.id) }
          it { expect(controller).to set_flash.to(I18n.t('operator.attendances.edit.clone.done')) }
        end
      end

      context 'helpers' do
        before { get(:edit, params: { id: attendance }) }

        it 'attendance' do
          expect(controller.attendance).to eq(attendance)
        end

        it 'ticket' do
          expect(controller.ticket).not_to be_nil
          expect(controller.ticket.answer_type).to eq('phone')
          expect(controller.ticket.used_input).to eq('phone_155')
          expect(controller.ticket.internal_status).not_to eq(nil)
          expect(controller.ticket.classification).to be_present
        end
      end
    end
  end

  describe '#update' do
    let(:invalid_attendance) do
      attendance = create(:attendance)
      attendance.description = nil
      attendance
    end
    let(:invalid_attendance_attributes) do
      attributes = invalid_attendance.attributes
      attributes[:ticket_attributes] = ticket_with_organ_attributes
      attributes
    end

    let(:ticket_with_organ) { create(:ticket, :with_classification, created_by: user) }
    let(:ticket) { create(:ticket) }


    let(:ticket_with_organ_attributes) { ticket_with_organ.attributes.except('id') }

    let(:attendance_organ_subnet_attributes) do
      attributes = {}
      attributes[0] = create(:attendance_organ_subnet, attendance: attendance).attributes
      attributes
    end

    let(:valid_attendance_attributes) do
      attributes = attributes_for(:attendance)
      attributes[:unknown_organ] = false
      attributes[:attendance_organ_subnets_attributes] = attendance_organ_subnet_attributes
      attributes[:ticket_attributes] = ticket_with_organ_attributes.merge(classification_attributes)
      attributes
    end

    let(:classification_attributes) do
      {
        classification_attributes: {
          other_organs: 0
        }
      }
    end
    let(:valid_attendance_params) { { id: attendance, attendance: valid_attendance_attributes } }

    let(:attendance_denunciation) do
      att = build(:attendance)
      att.save(validate: false)
      att.reload
    end
    let(:valid_attendance_denunciation_params) { { id: attendance_denunciation, attendance: valid_attendance_attributes } }

    let(:invalid_attendance_params) do
      { id: invalid_attendance, attendance: invalid_attendance_attributes }
    end

    let(:tickets_with_organs_attributes) do
      attributes = []
      attendance = create(:attendance, :with_ticket)
      attributes << create(:ticket, :with_parent, parent: attendance.ticket).attributes
      attributes << create(:ticket, :with_parent, parent: attendance.ticket).attributes

      attributes
    end

    context 'unauthorized' do
      before { patch(:update, params: valid_attendance_params) }

      it { is_expected.to redirect_to(new_user_session_path) }
    end

    context 'authorized' do
      before { sign_in(user) }

      it 'permits attendance params' do
        should permit(*permitted_params).
          for(:update, params: valid_attendance_params ).on(:attendance)
      end

      context 'valid' do

        context 'when other_organs true' do

          let(:classification_attributes) do
            {
              classification_attributes: {
                other_organs: 1
              }
            }
          end

          it 'saves' do
            valid_attendance_params
            create(:classification, :other_organs)

            expect do
              patch(:update, params: valid_attendance_params)
            end.to change(Ticket, :count).by(1)

            ticket = attendance.reload.ticket
            classification = ticket.classification

            expect(ticket).to be_classified
            expect(classification).to be_present
            expect(classification).to be_other_organs
          end
        end

        it 'saves' do
          valid_attendance_params[:attendance][:description] = 'new description'

          expect do
            patch(:update, params: valid_attendance_params)
          end.to change(Ticket, :count).by(1)

          expect(response).to redirect_to(operator_attendance_path(attendance))

          attendance.reload

          expected_flash = I18n.t("operator.attendances.update.done",
            title: attendance.protocol)

          expect(attendance.description).to eq('new description')
          expect(attendance.ticket.description).to eq('new description')
          expect(attendance.ticket.protocol).to eq(attendance.protocol)
          expect(attendance.ticket.internal_status).to eq("waiting_confirmation")
          expect(attendance.ticket.classification).to be_nil
          expect(controller).to set_flash.to(expected_flash)
          expect(controller.attendance.updated_by).to eq(user)
        end

        context 'saves denunciation' do

          before do
            valid_attendance_denunciation_params[:attendance][:attendance_organ_subnets_attributes] = []

            valid_attendance_denunciation_params[:attendance][:description] = 'denunciation description'
            valid_attendance_denunciation_params[:attendance][:ticket_attributes][:sou_type] = 'denunciation'
            valid_attendance_denunciation_params[:attendance][:ticket_attributes][:denunciation_date] = 'last week'
            valid_attendance_denunciation_params[:attendance][:ticket_attributes][:denunciation_place] = 'street 4'
            valid_attendance_denunciation_params[:attendance][:ticket_attributes][:denunciation_witness] = 'Joao'
            valid_attendance_denunciation_params[:attendance][:ticket_attributes][:denunciation_evidence] = 'yes'
            valid_attendance_denunciation_params[:attendance][:ticket_attributes][:denunciation_assurance] = 'rumor'
            valid_attendance_denunciation_params[:confirmation] = true
            patch(:update, params: valid_attendance_denunciation_params)
          end

          it 'description' do
            valid_attendance_denunciation_params[:confirmation] = false
            patch(:update, params: valid_attendance_denunciation_params)

            attendance_denunciation.reload

            expect(attendance_denunciation.ticket.denunciation_description).to eq('denunciation description')
          end

          it 'internal_status' do
            valid_attendance_denunciation_params[:confirmation] = false
            patch(:update, params: valid_attendance_denunciation_params)

            attendance_denunciation.reload

            expect(attendance_denunciation.ticket.internal_status).to eq('waiting_referral')
            expect(attendance_denunciation.unknown_organ?).to be_truthy
          end
        end

        describe 'set_ticket_user' do
          it 'call set ticket_user' do
            attendance.ticket = ticket
            attendance.save(validate: false)
            valid_attendance_params[:attendance][:ticket_attributes]['id'] = ticket.id

            service = double
            allow(SetTicketUser).to receive(:delay) { service }
            allow(service).to receive(:call)

            patch(:update, params: valid_attendance_params)

            expect(service).to have_received(:call).with(ticket.id)
          end
        end

        context 'service_type' do
          context 'when incorrect_click' do
            before { valid_attendance_params[:attendance][:service_type] = :incorrect_click }
            it 'saves and reject ticket' do
              expect do
                patch(:update, params: valid_attendance_params)
              end.to change(Ticket, :count).by(0)
            end

            it 'dont create answer' do
              expect do
                patch(:update, params: valid_attendance_params)
              end.to change(Answer, :count).by(0)
            end
          end

          context 'when sic_completed' do
            before do
              valid_attendance_params[:attendance][:service_type] = :sic_completed
              valid_attendance_params[:attendance][:answer] = 'answer'
              valid_attendance_params[:attendance][:ticket_attributes]['status'] = :confirmed
              valid_attendance_params[:confirmation] = true
            end

            context 'with empty name and document' do
              before do
                valid_attendance_params[:attendance][:ticket_attributes]['name'] = nil
                valid_attendance_params[:attendance][:ticket_attributes]['document'] = nil
              end

              it 'saves and complete ticket' do
                expect do
                  patch(:update, params: valid_attendance_params)
                end.to change(Ticket, :count).by(2)

                ticket = attendance.reload.ticket

                expect(attendance.answer).to eq('answer')
                expect(attendance.answered?).to be_truthy
                expect(ticket).to be_final_answer
                expect(ticket.tickets.first).to be_final_answer
                expect(ticket).to be_replied
                expect(ticket.responded_at).not_to eq(nil)
                expect(ticket).to be_with_feedback
              end

              it 'create answer and log' do
                expect do
                  patch(:update, params: valid_attendance_params)
                end.to change(Answer, :count).by(1)

                answer = TicketLog.last.resource

                expect(answer.description).to eq('answer')
                expect(answer.user).to eq(user)
                expect(answer.answer_type).to eq('final')
                expect(answer.answer_scope).to eq('call_center')
                expect(answer.status).to eq('call_center_approved')
              end
            end

            context 'with more than one organ' do

              before do
                valid_attendance_params[:attendance][:service_type] = :sic_completed
                valid_attendance_params[:attendance][:answer] = 'answer for two ticket child'
                valid_attendance_params[:confirmation] = true
                valid_attendance_params[:attendance][:ticket_attributes][0] = tickets_with_organs_attributes.first
                valid_attendance_params[:attendance][:ticket_attributes][1] = tickets_with_organs_attributes.second
              end

              it 'create answers and logs' do
                patch(:update, params: valid_attendance_params)

                ticket = Ticket.last
                answer = ticket.answers.first

                expect(answer.description).to eq('answer for two ticket child')
                expect(answer.user).to eq(user)
                expect(answer.answer_type).to eq('final')
                expect(answer.answer_scope).to eq('call_center')
                expect(answer.status).to eq('call_center_approved')
                expect(answer.deadline).to eq(ticket.deadline)
                expect(ticket.responded_at).not_to eq(nil)
              end
            end

            it 'set ticket.immediate_answer = true' do
              expect do
                patch(:update, params: valid_attendance_params)
              end.to change(Ticket, :count).by(2)

              parent = attendance.reload.ticket
              child = parent.tickets.first

              expect(parent).to be_immediate_answer
              expect(child).to be_immediate_answer
            end
          end

          context 'when sou_forward' do
            let(:organ_attendance) { build(:attendance_organ_subnet) }
            before do
              valid_attendance_params[:attendance][:service_type] = :sou_forward
              valid_attendance_params[:attendance][:ticket_attributes]['status'] = :confirmed
              valid_attendance_params[:confirmation] = true
              valid_attendance_params[:attendance][:attendance_organ_subnets_attributes][1] = organ_attendance.attributes

            end

            it 'saves and complete ticket' do
              expect do
                patch(:update, params: valid_attendance_params)
              end.to change(Ticket, :count).by(3)
            end

            context 'ticket_log' do
              it 'register ticket log' do
                allow(RegisterTicketLog).to receive(:call)

                patch(:update, params: valid_attendance_params)

                attendance_updated = Attendance.find(attendance.id)

                ticket_parent = attendance_updated.ticket

                ticket1 = ticket_parent.tickets.first
                ticket2 = ticket_parent.tickets.second

                resource1 = ticket1.organ
                resource2 = ticket2.organ

                expect(RegisterTicketLog).to have_received(:call).with(ticket_parent, user, :share, { resource: resource1 })
                expect(RegisterTicketLog).to have_received(:call).with(ticket_parent, user, :share, { resource: resource2 })
              end

              it 'register log for priority ticket' do
                allow(RegisterTicketLog).to receive(:call)

                valid_attendance_params[:attendance][:ticket_attributes]['priority'] = '1'

                patch(:update, params: valid_attendance_params)

                attendance_updated = Attendance.find(attendance.id)

                ticket_parent = attendance_updated.ticket
                ticket_child = ticket_parent.tickets.first

                expect(RegisterTicketLog).to have_received(:call).with(ticket_child, user, :priority, { resource: ticket_child })
                expect(RegisterTicketLog).to have_received(:call).with(ticket_parent, user, :priority, { resource: ticket_parent })
              end

              it 'attendance_updated' do
                allow(RegisterTicketLog).to receive(:call)

                attendance = create(:attendance, :with_confirmed_ticket)
                ticket_parent = attendance.ticket

                valid_attendance_params = { id: attendance, attendance: attendance.attributes }
                valid_attendance_params[:confirmation] = false

                patch(:update, params: valid_attendance_params)

                data_attributes = {
                  responsible_as_author: user.as_author
                }

                expect(RegisterTicketLog).to have_received(:call).with(ticket_parent, user, :attendance_updated, { resource: attendance, data: data_attributes })
              end

              context 'confirm' do
                it 'register ticket log' do
                  allow(RegisterTicketLog).to receive(:call)

                  patch(:update, params: valid_attendance_params)

                  attendance_updated = Attendance.find(attendance.id)

                  ticket_parent = attendance_updated.ticket

                  data = { data: { responsible_as_author: user.as_author }}

                  expect(RegisterTicketLog).to have_received(:call).with(ticket_parent, user, :confirm, data)
                end

                it 'do not register when ticket was confirmed' do
                  allow(RegisterTicketLog).to receive(:call)

                  attendance = create(:attendance, :with_confirmed_ticket)

                  valid_attendance_params = { id: attendance, attendance: attendance.attributes }
                  valid_attendance_params[:confirmation] = true

                  patch(:update, params: valid_attendance_params)

                  attendance_updated = Attendance.find(attendance.id)

                  ticket_parent = attendance_updated.ticket

                  data = { data: { responsible_as_author: user.as_author }}

                  expect(RegisterTicketLog).not_to have_received(:call).with(ticket_parent, user, :confirm, data)
                end
              end
            end
          end
        end

        context 'saves confirmation' do
          # quando o usuário salva o form de confirmação, precisamos setar o
          # flash 'from_confirmation' para que o show possa exibir
          # a mensagem de sucesso para o usuário.

          before do
            valid_attendance_params[:attendance][:ticket_attributes] = {}
            valid_attendance_params[:attendance][:ticket_attributes]['status'] = :confirmed
            valid_attendance_params[:confirmation] = true
          end

          it 'unknown organ' do
            attendance.ticket = ticket
            attendance.save(validate: false)
            valid_attendance_params[:attendance][:ticket_attributes]['id'] = ticket.id
            valid_attendance_params[:attendance][:unknown_organ] = true

            patch(:update, params: valid_attendance_params)

            attendance.reload

            # o flash é usado para exibir a mensagem específica avisando ao usuário
            # que sua manifestação foi recebida!

            expect(controller).to set_flash[:from_confirmation].to(true)
            expect(response).to redirect_to(operator_attendance_path(attendance))
            expect(attendance.ticket).to be_confirmed
            expect(attendance.ticket).to be_waiting_referral
            expect(attendance.ticket.tickets.count).to eq(0)
            expect(attendance.ticket.parent_unknown_organ).to be_truthy

            expect(attendance.ticket.ticket_logs.count).to eq(1)
            expect(attendance.ticket.ticket_logs.first.confirm?).to be_truthy
          end

          it 'knowledge organ' do
            attendance.ticket = ticket_with_organ
            attendance.save(validate: false)
            valid_attendance_params[:attendance][:ticket_attributes]['id'] = ticket_with_organ.id
            patch(:update, params: valid_attendance_params)
            attendance.reload

            expect(attendance.ticket).to be_confirmed
            expect(attendance.ticket).to be_sectoral_attendance
            expect(attendance.ticket.tickets.count).to eq(1)
            expect(attendance.ticket.parent_unknown_organ).to be_falsey

            # ticket_logs criados:
            # - confirm
            # - share
            expect(attendance.ticket.ticket_logs.count).to eq(2)
          end

          it 'set_deadline for sou' do
            sou_deadline = 15
            deadline_ends_at = Date.today + Holiday.next_weekday(sou_deadline)
            valid_attendance_params[:attendance][:service_type] = 'sou_forward'

            patch(:update, params: valid_attendance_params)

            expect(controller.ticket.deadline_ends_at).to eq(deadline_ends_at)
          end

          it 'set_deadline for sic' do
            sic_deadline = 20
            deadline_ends_at = Date.today + Holiday.next_weekday(sic_deadline)

            valid_attendance_params[:attendance][:service_type] = 'sic_forward'

            patch(:update, params: valid_attendance_params)

            expect(controller.ticket.deadline_ends_at).to eq(deadline_ends_at)
          end
        end

        context 'edit before confirm' do
          context 'change service_type' do
            context 'from sic_forward' do
              let(:attendance) { create(:attendance, :sic_forward) }
              let(:ticket) { attendance.ticket }

              let(:valid_attendance_attributes) do
                attributes = attendance.attributes.symbolize_keys
                attributes[:unknown_organ] = true
                attributes[:ticket_attributes] = ticket.attributes
                attributes
              end

              context 'to sou_forward' do
                before do
                  valid_attendance_attributes[:service_type] = :sou_forward
                  valid_attendance_attributes[:ticket_attributes][:sou_type] = :complaint

                  patch(:update, params: valid_attendance_params)
                end

                it { expect(ticket.reload).to be_sou }
              end
            end
          end
        end

        context 'edit after confirm' do
          let(:attendance) { create(:attendance, :sou_forward, protocol: ticket.protocol) }
          let(:ticket) { child_ticket.parent }
          let(:child_ticket) { create(:ticket, :with_parent) }
          let(:change_params) do
            {
              id: attendance.id,
              attendance: {
                description: 'NEW DESCRIPTION',
                ticket_attributes: {
                  id: attendance.ticket_id,
                  anonymous: true
                }
              }
            }
          end

          let(:update_params) do
            {
              id: attendance.id,
              attendance: {
                attendance_organ_subnets_attributes: {
                  '1': build(:attendance_organ_subnet).attributes
                }
              }

            }
          end
          let(:delete_params) do
            sharing = attendance.attendance_organ_subnets.first
            {
              id: attendance.id,
              attendance: {
                unknown_organ: true,
                attendance_organ_subnets_attributes: {
                  '1': {
                    id: sharing.id,
                    _destroy: 1,
                    organ_id: sharing.organ_id
                  }
                }
              }

            }
          end

          before do
            attendance.attendance_organ_subnets.create(organ_id: child_ticket.organ_id, unknown_subnet: true)
            attendance.ticket = child_ticket.parent
            attendance.unknown_organ = false
            attendance.save
          end

          it 'reflects on children attributes' do
            patch(:update, params: change_params)

            ticket.reload
            child = ticket.tickets.first
            expect(ticket.description).to eq('NEW DESCRIPTION')
            expect(ticket.anonymous).to eq(true)
            expect(child.description).to eq('NEW DESCRIPTION')
            expect(child.anonymous).to eq(true)
          end

          it 'share ticket to new organs' do
            expect do
              patch(:update, params: update_params)
            end.to change(ticket.tickets, :count).by(1)
          end

          it 'share ticket to new organs' do
            expect do
              patch(:update, params: delete_params)
            end.to change(ticket.tickets, :count).by(-1)
          end
        end
      end

      context 'invalid' do
        render_views

        it 'does not save' do
          patch(:update, params: invalid_attendance_params)
          expect(response).to render_template('operator/attendances/edit')
        end
      end

      context 'helpers' do
        it 'attendance' do
          patch(:update, params: valid_attendance_params)
          expect(controller.attendance).to eq(attendance)
        end
      end
    end
  end
end
