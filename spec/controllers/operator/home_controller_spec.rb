require 'rails_helper'

describe Operator::HomeController do

  let(:sectoral_organ) { create(:executive_organ) }
  let(:internal_department) { create(:department) }

  let(:operator_cge) { create(:user, :operator_cge) }
  let(:operator_chief) { create(:user, :operator_chief) }
  let(:operator_sectoral) { create(:user, :operator_sectoral, organ: sectoral_organ) }
  let(:operator_internal) { create(:user, :operator_internal, department: internal_department, organ: internal_department.organ) }
  let(:operator_denunciation) { create(:user, :operator_cge_denunciation_tracking) }
  let(:operator_call_center_supervisor) { create(:user, :operator_call_center_supervisor) }
  let(:operator_coordination) { create(:user, :operator_coordination) }

  let(:parent_ticket) { create(:ticket, :invalidated) }
  let!(:sectoral_ticket) { create(:ticket, :with_organ, organ: sectoral_organ, parent: parent_ticket, internal_status: :sectoral_attendance) }
  let!(:internal_ticket) { create(:ticket, :with_organ, :with_parent, organ: sectoral_organ, internal_status: :internal_attendance) }

  let!(:ticket_department) { create(:ticket_department, department: internal_department, ticket: internal_ticket) }

  describe '#index' do
    context 'unauthorized' do
      before { get(:index) }

      it { is_expected.to redirect_to(new_user_session_path) }
    end

    context 'authorized' do

      context 'template' do
        before { sign_in(operator_cge) && get(:index) }
        render_views

        it { is_expected.to respond_with(:success) }
      end

      describe '#redirect_to_ticket_by_protocol' do
        User::OPERATOR_TYPES_FOR_SOU_OPERATORS.each do |operator_type|
          context "when ticket belongs to #{operator_type}" do
            it 'redirect to current organ child ticket index page' do
              operator_user = create(:user, "operator_#{operator_type}".to_sym)
              sign_in(operator_user)

              sectoral_ticket.organ_id = operator_user.organ_id
              sectoral_ticket.save(validate: false)
              get(:redirect_to_ticket_by_protocol, params: { protocol: parent_ticket.protocol })

              is_expected.to redirect_to(
                operator_ticket_path(parent_ticket.tickets.find_by(organ_id: operator_user.organ_id))
              )
            end
          end
        end

        [:operator_coordination, :operator_cge_denunciation_tracking, :operator_chief].each do |operator_type|
          context "when ticket belongs to #{operator_type}" do
            it 'redirect to current ticket index page' do
              operator_user = create(:user, operator_type)
              sign_in(operator_user)
              get(:redirect_to_ticket_by_protocol, params: { protocol: parent_ticket.protocol })
              is_expected.to redirect_to(
                operator_ticket_path(parent_ticket.id)
              )
            end
          end
        end

        context "when ticket belong to operator_security_organ" do
          let(:security_organ) { create(:organ, :security_organ) }
          let(:parent_ticket_security_organ) { create(:ticket, internal_status: :sectoral_attendance) }
          let(:ticket_security_organ) { create(:ticket, organ: security_organ, unknown_organ: false, parent: parent_ticket_security_organ, internal_status: :sectoral_attendance) }

          it 'redirect to ticket index page' do
            security_organ_user = create(:user, :operator_security_organ)
            sign_in(security_organ_user)

            ticket_security_organ.save

            get(:redirect_to_ticket_by_protocol, params: { protocol: parent_ticket_security_organ.protocol })
            is_expected.to redirect_to(
              operator_ticket_path(ticket_security_organ.id)
            )
          end
        end

      end

      describe 'helpers' do

        context 'supervisor 155' do
          before { sign_in(operator_call_center_supervisor) && get(:index) }

          it 'attendance_responses_by_operator' do
            attendance_response = create(:attendance_response)
            operator_call_center = create(:user, :operator_call_center)
            ticket_log = create(:ticket_log, resource: attendance_response, responsible: operator_call_center, action: :attendance_response)
            expected = [[ticket_log.responsible.title, TicketLog.attendance_response.count]]

            expect(controller.attendance_responses_by_operator).to eq(expected)
          end

          it 'attendances_by_operator' do
            operator_call_center = create(:user, :operator_call_center)
            attendance = create(:attendance, created_by: operator_call_center)
            expected = [[attendance.created_by.title, Attendance.count]]

            expect(controller.attendances_by_operator).to eq(expected)
          end
        end

        context 'cge operator' do
          before { sign_in(operator_cge) && get(:index) }

          context 'tickets_count' do

            context 'couvi' do
              it 'by deadline' do
                  organ = create(:executive_organ, :couvi)

                  create(:ticket, :confirmed, deadline: -13 )
                  create(:ticket, :confirmed, deadline: -16, organ_id: organ.id, unknown_organ: false)
                  create(:ticket, :confirmed, deadline: 13, organ_id: organ.id, unknown_organ: false)
                  create(:ticket, :confirmed, deadline: 16, organ_id: organ.id, unknown_organ: false)

                  expect(controller.tickets_couvi_deadline_count(:sou, :not_expired)).to eq(2)
                  expect(controller.tickets_couvi_deadline_count(:sou, :expired)).to eq(1)
              end

              it 'by internal status' do
                organ = create(:executive_organ, :couvi)

                create(:ticket, :confirmed, deadline: -13)
                create(:ticket, :confirmed, deadline: -16, organ_id: organ.id, unknown_organ: false, internal_status: :partial_answer)
                create(:ticket, :confirmed, deadline: 13, organ_id: organ.id, unknown_organ: false, internal_status: :partial_answer)

                expect(controller.tickets_couvi_by_internal_status_count(:sou, :partial_answer)).to eq(2)
              end

              it 'by reopened' do
                organ = create(:executive_organ, :couvi)

                create(:ticket, :confirmed, deadline: -13)
                create(:ticket, :confirmed, deadline: -16, organ_id: organ.id, unknown_organ: false, internal_status: :partial_answer)
                create(:ticket, :confirmed, deadline: 13, organ_id: organ.id, unknown_organ: false, internal_status: :partial_answer, reopened: 1)

                expect(controller.tickets_couvi_reopened_count(:sou)).to eq(1)
              end

              context 'when organ is not couvi' do
                it 'returns zero' do
                  create(:executive_organ, :couvi)

                  create(:ticket, internal_status: :partial_answer)

                  create(:ticket, :confirmed, deadline: -13 )
                  create(:ticket, :confirmed, deadline: -16 )
                  create(:ticket, :confirmed, :with_reopen )

                  create(:ticket, :replied)
                  create(:ticket, internal_status: :in_filling)
                  create(:ticket, internal_status: :invalidated)

                  create(:ticket, :confirmed)

                  expect(controller.tickets_couvi_deadline_count(:sou, :not_expired)).to eq(0)
                  expect(controller.tickets_couvi_reopened_count(:sou)).to eq(0)
                  expect(controller.tickets_couvi_by_internal_status_count(:sou, :partial_answer)).to eq(0)
                end
              end
            end

            context 'rede_ouvir' do
              it 'tickets_rede_ouvir_cge_count' do
                rede_ouvir_cge = create(:rede_ouvir_organ, :cge)
                create(:ticket, :with_rede_ouvir)
                create(:ticket, :with_rede_ouvir, organ: rede_ouvir_cge)

                expect(controller.tickets_rede_ouvir_cge_count(:sou)).to eq(1)
              end
            end

            context 'by deadline' do
              it 'not_expired' do
                # não deve considerar tickets com internal_status :partial_answer
                create(:ticket, internal_status: :partial_answer)

                create(:ticket, :confirmed, deadline: -13 )
                create(:ticket, :confirmed, deadline: -16 )

                create(:ticket, :replied)
                create(:ticket, internal_status: :in_filling)
                create(:ticket, internal_status: :invalidated)

                create(:ticket, :confirmed)

                expect(controller.tickets_deadline_count(:sou, :not_expired)).to eq(2)
              end

              it 'expired_can_extend' do
                # não deve considerar tickets com internal_status :partial_answer
                create(:ticket, internal_status: :partial_answer, deadline: 14)
                create(:ticket,:replied, deadline: 15)

                ticket_days = Ticket::LIMIT_TO_EXTEND_DEADLINE - 1
                in_limit = DateTime.now - ticket_days.days
                create(:ticket, :confirmed, deadline: Ticket::SOU_DEADLINE - ticket_days , confirmed_at: in_limit)

                expect(controller.tickets_deadline_count(:sou, :expired_can_extend)).to eq(1)
              end

              it 'expired' do
                # não deve considerar tickets com internal_status :partial_answer
                create(:ticket, internal_status: :partial_answer, deadline: Ticket::LIMIT_TO_EXTEND_DEADLINE-1)

                ticket = create(:ticket, :confirmed, deadline: -1 )
                create(:ticket, :confirmed, deadline: -1 )
                create(:ticket, :replied, deadline: Ticket::LIMIT_TO_EXTEND_DEADLINE-1 )

                create(:extension, ticket: ticket, status: :approved)

                expect(controller.tickets_deadline_count(:sou, :expired)).to eq(2)
              end

              it 'with not appeal' do
                # não deve considerar tickets com solicitação de recurso
                create(:ticket, internal_status: :appeal, deadline: Ticket::LIMIT_TO_EXTEND_DEADLINE-1)

                ticket = create(:ticket, :confirmed, deadline: -1 )
                create(:ticket, :confirmed, deadline: -1 )
                create(:ticket, :replied, deadline: Ticket::LIMIT_TO_EXTEND_DEADLINE-1 )

                create(:extension, ticket: ticket, status: :approved)

                expect(controller.tickets_deadline_count(:sou, :expired)).to eq(2)
              end
            end

            context 'by internal_status' do
              before do
                create(:ticket, internal_status: :partial_answer)
                create(:ticket, internal_status: :partial_answer, ticket_type: :sic)
                create(:ticket, internal_status: :sectoral_attendance)
                create(:ticket, :with_parent, internal_status: :awaiting_invalidation)
                create(:ticket, :with_parent, internal_status: :waiting_confirmation)
                ticket_sic = create(:ticket, :with_parent, :sic, internal_status: :awaiting_invalidation)
                parent_sic = ticket_sic.parent
                parent_sic.sic!
                ticket_validation = create(:ticket, :confirmed)
                create(:ticket_log, :with_awaiting_sectoral, ticket: ticket_validation)
              end

              it { expect(controller.tickets_by_internal_status_count(:sou, :partial_answer)).to eq(1) }
              it { expect(controller.tickets_by_internal_status_count(:sic, :partial_answer)).to eq(1) }

              it { expect(controller.tickets_by_internal_status_count(:sou, :awaiting_invalidation)).to eq(1) }
              it { expect(controller.tickets_by_internal_status_count(:sic, :awaiting_invalidation)).to eq(1) }

              it { expect(controller.tickets_by_internal_status_count(:sou, :cge_validation)).to eq(1) }
              it { expect(controller.attendances_waiting_confirmation_count).to eq(1) }
            end
          end

          it 'department pending answer' do
            expect(controller.departments).to eq([])
          end
        end

        context 'coordination operator' do
          before { sign_in(operator_coordination) && get(:index) }

          context 'tickets_count' do
            context 'by deadline' do

              it 'not_expired' do
                # não deve considerar tickets com internal_status :partial_answer
                create(:ticket, internal_status: :partial_answer)

                create(:ticket, :confirmed, deadline: -13 )
                create(:ticket, :confirmed, deadline: -16 )

                create(:ticket, :replied)
                create(:ticket, internal_status: :in_filling)
                create(:ticket, internal_status: :invalidated)

                create(:ticket, :confirmed)

                expect(controller.tickets_deadline_count(:sou, :not_expired)).to eq(2)
              end

              it 'expired_can_extend' do
                # não deve considerar tickets com internal_status :partial_answer
                create(:ticket, internal_status: :partial_answer, deadline: 14)
                create(:ticket,:replied, deadline: 15)

                ticket_days = Ticket::LIMIT_TO_EXTEND_DEADLINE - 1
                in_limit = DateTime.now - ticket_days.days
                create(:ticket, :confirmed, deadline: Ticket::SOU_DEADLINE - ticket_days , confirmed_at: in_limit)

                expect(controller.tickets_deadline_count(:sou, :expired_can_extend)).to eq(1)
              end

              it 'expired' do
                # não deve considerar tickets com internal_status :partial_answer
                create(:ticket, internal_status: :partial_answer, deadline: Ticket::LIMIT_TO_EXTEND_DEADLINE-1)

                ticket = create(:ticket, :confirmed, deadline: -1 )
                create(:ticket, :confirmed, deadline: -1 )
                create(:ticket, :replied, deadline: Ticket::LIMIT_TO_EXTEND_DEADLINE-1 )

                create(:extension, ticket: ticket, status: :approved)

                expect(controller.tickets_deadline_count(:sou, :expired)).to eq(2)
              end
            end

            context 'by internal_status' do
              before do
                create(:ticket, internal_status: :partial_answer)
                create(:ticket, internal_status: :partial_answer, ticket_type: :sic)
                create(:ticket, internal_status: :sectoral_attendance)
                create(:ticket, :with_parent, internal_status: :awaiting_invalidation)
                ticket_sic = create(:ticket, :with_parent, :sic, internal_status: :awaiting_invalidation)
                parent_sic = ticket_sic.parent
                parent_sic.sic!
                ticket_validation = create(:ticket, :confirmed)
                create(:ticket_log, :with_awaiting_sectoral, ticket: ticket_validation)
              end

              it { expect(controller.tickets_by_internal_status_count(:sou, :partial_answer)).to eq(1) }
              it { expect(controller.tickets_by_internal_status_count(:sic, :partial_answer)).to eq(1) }

              it { expect(controller.tickets_by_internal_status_count(:sou, :awaiting_invalidation)).to eq(1) }
              it { expect(controller.tickets_by_internal_status_count(:sic, :awaiting_invalidation)).to eq(1) }

              it { expect(controller.tickets_by_internal_status_count(:sou, :cge_validation)).to eq(1) }
            end
          end

          it 'department pending answer' do
            expect(controller.departments).to eq([])
          end
        end

        context 'denunciation_tracking operator' do
          it 'denunciation and others' do
            operator_cge_denunciation_tracking = create(:user, :operator_cge_denunciation_tracking)

            sign_in(operator_cge_denunciation_tracking) && get(:index)

            create(:ticket, :denunciation)
            create(:ticket)

            # Ira contar o ticket de denuncia juntamente com um ticket ja criado no inicio da classe
            expect(controller.tickets_deadline_count(:sou, :not_expired)).to eq(2)
          end
        end

        context 'sectoral operator' do
          before { sign_in(operator_sectoral) && get(:index) }

          context 'tickets_count' do
            context 'by deadline' do

              it 'default status scope' do
                sectoral_ticket
                internal_ticket
                create(:ticket, :with_organ, organ: sectoral_organ, internal_status: :subnet_attendance)
                create(:ticket, :with_organ, organ: sectoral_organ, internal_status: :sectoral_attendance)
                create(:ticket, :with_organ, organ: sectoral_organ, internal_status: :sectoral_validation)

                expect(controller.tickets_deadline_count(:sou, :not_expired)).to eq(5)
              end

              it 'not_expired' do
                create(:ticket, :with_organ, organ: sectoral_organ, internal_status: :sectoral_attendance)

                create(:ticket, :with_organ, organ: sectoral_organ, internal_status: :sectoral_attendance, deadline: -13 )
                create(:ticket, :with_organ, organ: sectoral_organ, internal_status: :sectoral_attendance, deadline: -16 )

                expect(controller.tickets_deadline_count(:sou, :not_expired)).to eq(3)
              end

              it 'expired_can_extend' do
                # não deve considerar tickets com internal_status :partial_answer
                create(:ticket, :with_organ, organ: sectoral_organ, internal_status: :partial_answer, deadline: -13)

                ticket_days = Ticket::LIMIT_TO_EXTEND_DEADLINE - 1
                in_limit = DateTime.now - ticket_days.days
                create(:ticket, :with_organ, organ: sectoral_organ, internal_status: :sectoral_attendance, deadline: Ticket::SOU_DEADLINE - ticket_days, confirmed_at: in_limit)

                expect(controller.tickets_deadline_count(:sou, :expired_can_extend)).to eq(1)
              end

              it 'expired' do
                # não deve considerar tickets com internal_status :partial_answer
                create(:ticket, :with_organ, organ: sectoral_organ, internal_status: :partial_answer, deadline: Ticket::LIMIT_TO_EXTEND_DEADLINE-1)

                ticket = create(:ticket, :with_organ, organ: sectoral_organ, internal_status: :sectoral_attendance, deadline: -2 )
                create(:ticket, :with_organ, organ: sectoral_organ, internal_status: :sectoral_attendance, deadline: -1 )

                create(:extension, ticket: ticket, status: :approved)

                expect(controller.tickets_deadline_count(:sou, :expired)).to eq(2)
              end
            end

            context 'by priority true' do
              before do
                create_list(:ticket, 2, :with_organ, organ: sectoral_organ, priority: true, internal_status: :subnet_attendance)
                create(:ticket, :with_organ, organ: sectoral_organ, priority: true, ticket_type: :sic, internal_status: :sectoral_attendance)
                create(:ticket, :with_organ, organ: sectoral_organ, priority: false, internal_status: :sectoral_attendance)
                create(:ticket, :with_organ, organ: sectoral_organ, priority: true, internal_status: :sectoral_attendance)
              end

              it { expect(controller.tickets_sectoral_priority_count(:sou)).to eq(3) }
              it { expect(controller.tickets_sectoral_priority_count(:sic)).to eq(1) }
            end
          end

          it 'department pending answer' do
            department = create(:department, organ: operator_sectoral.organ)
            other_department = create(:department, organ: operator_sectoral.organ)
            ticket = create(:ticket, :with_parent, organ: sectoral_organ, internal_status: :internal_attendance)
            ticket_department = create(:ticket_department, ticket: ticket, department: department)

            create(:ticket_department, :answered, department: department)
            create(:ticket_department, department: other_department)

            expect(controller.departments).to eq([department])
          end
        end

        context 'internal operator' do
          before { sign_in(operator_internal) && get(:index) }

          context 'tickets_count' do
            context 'by ticket_department.deadline' do
              let(:ticket_partial_answer) { create(:ticket, :with_organ, :with_parent, organ: sectoral_organ, internal_status: :partial_answer) }
              let(:internal_expired) { create(:ticket, :with_organ, :with_parent, organ: sectoral_organ, internal_status: :internal_attendance) }
              let(:internal_expired2) { create(:ticket, :with_organ, :with_parent, organ: sectoral_organ, internal_status: :internal_attendance) }

              it 'not_expired' do
                # não deve considerar tickets com internal_status :partial_answer
                create(:ticket_department, department: internal_department, ticket: ticket_partial_answer)

                create(:ticket_department, department: internal_department, ticket: internal_expired, deadline: -13)
                create(:ticket_department, department: internal_department, ticket: internal_expired2, deadline: -16)

                expect(controller.tickets_deadline_count(:sou, :not_expired)).to eq(1)
              end

              it 'expired_can_extend' do
                # não deve considerar tickets com internal_status :partial_answer
                create(:ticket_department, department: internal_department, ticket: ticket_partial_answer, deadline: Ticket::LIMIT_TO_EXTEND_DEADLINE)

                ticket_days = Ticket::LIMIT_TO_EXTEND_DEADLINE - 1
                in_limit = DateTime.now - ticket_days.days
                internal_expired = create(:ticket, :confirmed, organ: sectoral_organ, internal_status: :internal_attendance)
                create(:ticket_department, department: internal_department, ticket: internal_expired, deadline: Ticket::SOU_DEADLINE - ticket_days, created_at: in_limit)

                expect(controller.tickets_deadline_count(:sou, :expired_can_extend)).to eq(1)
              end

              it 'expired' do
                # não deve considerar tickets com internal_status :partial_answer
                create(:ticket_department, department: internal_department, ticket: ticket_partial_answer, deadline: Ticket::LIMIT_TO_EXTEND_DEADLINE-1)

                create(:ticket_department, department: internal_department, ticket: internal_expired, deadline: -1)
                create(:ticket_department, department: internal_department, ticket: internal_expired2, deadline: -1)

                create(:extension, ticket: internal_expired, status: :approved)

                expect(controller.tickets_deadline_count(:sou, :expired)).to eq(2)
              end
            end

            context 'by internal_status' do
              before do
                internal_expired = create(:ticket, :with_organ, :with_parent, organ: sectoral_organ, internal_status: :partial_answer )
                create(:ticket_department, department: internal_department, ticket: internal_expired)

                internal_expired2 = create(:ticket, :with_organ, :with_parent, organ: sectoral_organ, internal_status: :internal_attendance )
                create(:ticket_department, department: internal_department, ticket: internal_expired2)
              end

              it { expect(controller.tickets_by_internal_status_count(:sou, :partial_answer)).to eq(1) }
            end
          end
        end

        context 'internal operator' do
          before { sign_in(operator_chief) && get(:index) }

          context 'tickets_count' do
            it 'extension in progress' do
              ticket_extension_in_progress = create(:ticket, :with_parent, internal_status: :cge_validation, organ: operator_chief.organ)
              ticket_extension_approved = create(:ticket, :with_parent, internal_status: :cge_validation, organ: operator_chief.organ)

              create(:extension, ticket: ticket_extension_in_progress, status: :in_progress)
              create(:extension, ticket: ticket_extension_approved, status: :approved)

              ticket_extension_in_progress.reload
              ticket_extension_approved.reload

              expect(controller.tickets_extension_in_progress_count(:sou)).to eq(1)
            end
          end
        end
      end


      context 'denunciation counts' do
        let(:cosco) { create(:executive_organ, :cosco) }
        let!(:coordination) { create(:executive_organ, acronym: 'COUVI')}
        let(:denunciation_parent_in_attendance) { create(:ticket, :denunciation, :in_sectoral_attendance) }
        let!(:cosco_in_attendance) { create(:ticket, :denunciation, organ: cosco, parent: denunciation_parent_in_attendance) }
        let!(:denunciation_coordination) { create(:ticket, :denunciation, organ: coordination, parent: denunciation_parent_in_attendance) }
        let!(:denunciation_cge_validation) { create(:ticket, :denunciation, internal_status: :cge_validation) }
        let!(:denunciation_waiting_referral) { create(:ticket, :denunciation, internal_status: :waiting_referral) }
        let!(:parent_awaiting_invalidation) { create(:ticket, :denunciation, internal_status: :awaiting_invalidation) }
        let!(:denunciation_awaiting_invalidation) { create(:ticket, :denunciation, :with_parent, parent: parent_awaiting_invalidation, internal_status: :awaiting_invalidation) }

        before { sign_in(operator_denunciation) }

        it 'cosco_sectoral_attendance' do
          get(:index)

          expect(controller.tickets_denunciation_cards_counts[:cosco_sectoral_attendance][:count]).to eq(1)

          expected_path = operator_tickets_path(ticket_type: :sou, internal_status: :sectoral_attendance, organ: cosco.id, denunciation: 1)
          expect(controller.tickets_denunciation_cards_counts[:cosco_sectoral_attendance][:params]).to eq(expected_path)
        end

        it 'cge_validation' do
          get(:index)

          expect(controller.tickets_denunciation_cards_counts[:cge_validation][:count]).to eq(1)

          expected_path = operator_tickets_path(ticket_type: :sou, internal_status: :cge_validation, denunciation: 1)
          expect(controller.tickets_denunciation_cards_counts[:cge_validation][:params]).to eq(expected_path)
        end

        it 'awaiting_invalidation' do
          get(:index)

          expect(controller.tickets_denunciation_cards_counts[:awaiting_invalidation][:count]).to eq(1)

          expected_path = operator_tickets_path(ticket_type: :sou, internal_status: :awaiting_invalidation, denunciation: 1)
          expect(controller.tickets_denunciation_cards_counts[:awaiting_invalidation][:params]).to eq(expected_path)
        end

        it 'waiting_referral' do
          get(:index)

          expect(controller.tickets_denunciation_cards_counts[:waiting_referral][:count]).to eq(1)

          expected_path = operator_tickets_path(ticket_type: :sou, internal_status: :waiting_referral, denunciation: 1)
          expect(controller.tickets_denunciation_cards_counts[:waiting_referral][:params]).to eq(expected_path)
        end

        it 'coordination' do
          get(:index)

          expect(controller.tickets_denunciation_cards_counts[:coordination][:count]).to eq(1)

          expected_path = operator_tickets_path(ticket_type: :sou, internal_status: :sectoral_attendance, organ: coordination.id, denunciation: 1)
          expect(controller.tickets_denunciation_cards_counts[:coordination][:params]).to eq(expected_path)
        end
      end
    end
  end
end
