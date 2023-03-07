require 'rails_helper'

describe AttendancesHelper do

  context 'attendance_service_types_for_select' do
    it 'order' do

      service_types = [
        :sou_forward,
        :sic_forward,
        :sic_completed,
        :sou_search,
        :sic_search,
        :no_communication,
        :no_characteristic,
        :prank_call,
        :noise,
        :immediate_hang_up,
        :hang_up,
        :technical_problems,
        :missing_data,
        :incorrect_click,
        :transferred_call
      ]

      expected = service_types.map do |type|
        [Attendance.human_attribute_name("service_type.#{type}"), type]
      end

      expect(attendance_service_types_for_select).to eq(expected)
    end

    it 'SERVICE_TYPES_ORDER match service_types' do
      expect(Attendance.service_types.keys.map(&:to_sym)).to match_array(AttendancesHelper::SERVICE_TYPES_ORDER)
    end
  end

  it 'attendance_created_by_for_select' do
    create_list(:user, 2, :operator_call_center)

    expected = User.call_center.sorted.pluck(:name, :id)

    expect(attendance_created_by_for_select).to eq(expected)
  end

  context 'attendance_scope_params' do
    let(:service_types) { [:sic_completed] }

    it 'when operator call_center' do
      user = create(:user, :operator_call_center)

      expected = { service_type: service_types, created_by_id: user.id }
      expect(attendance_scope_params(service_types, user)).to eq(expected)
    end

    it 'when operator supervisor call_center' do
      user = create(:user, :operator_call_center_supervisor)

      expected = { service_type: service_types }
      expect(attendance_scope_params(service_types, user)).to eq(expected)
    end
  end

  context 'attendance_waiting_feedback_count' do
    let(:user) { create(:user, :operator_call_center) }

    before do
      create(:ticket, :replied, :with_call_center_responsible, call_center_responsible_id: user.id)

      create(:ticket, :replied, :call_center)
      create(:ticket, :replied, :call_center, :feedback)
      create(:ticket, :replied, :call_center, :feedback, call_center_responsible_id: user.id)
    end

    it { expect(attendance_waiting_feedback_count(user)).to eq(1) }
  end

  describe 'check attendace filters params present' do
    context 'range filter' do
      it 'present' do
        params = { created_at: { start: 'any', end: 'any' } }
        expect(attendance_filter_params?(params)).to be_truthy
      end

      it 'only start' do
        params = { created_at: { start: 'any' } }
        expect(attendance_filter_params?(params)).to be_truthy
      end

      it 'only end' do
        params = { created_at: { end: 'any' } }
        expect(attendance_filter_params?(params)).to be_truthy
      end

      it 'blank' do
        params = {  }
        expect(attendance_filter_params?(params)).to be_falsey
      end
    end

    context 'other filters present' do
      it 'search' do
        params = { search: 'any' }
        expect(attendance_filter_params?(params)).to be_truthy
      end

      it 'parent_protocol' do
        params = { parent_protocol: 'any' }
        expect(attendance_filter_params?(params)).to be_truthy
      end

      it 'created_by_id' do
        params = { created_by_id: 'any' }
        expect(attendance_filter_params?(params)).to be_truthy
      end

      it 'ticket_type' do
        params = { ticket_type: 'any' }
        expect(attendance_filter_params?(params)).to be_truthy
      end

      it 'sou_type' do
        params = { sou_type: 'any' }
        expect(attendance_filter_params?(params)).to be_truthy
      end

      it 'internal_status' do
        params = { internal_status: 'any' }
        expect(attendance_filter_params?(params)).to be_truthy
      end

      it 'organ_id' do
        params = { organ_id: 'any' }
        expect(attendance_filter_params?(params)).to be_truthy
      end

      it 'answer_type' do
        params = { answer_type: 'any' }
        expect(attendance_filter_params?(params)).to be_truthy
      end

      it 'deadline' do
        params = { deadline: 'any' }
        expect(attendance_filter_params?(params)).to be_truthy
      end

      it 'service_type' do
        params = { service_type: 'any' }
        expect(attendance_filter_params?(params)).to be_truthy
      end

      it 'call_center_responsible_id' do
        params = { call_center_responsible_id: 'any' }
        expect(attendance_filter_params?(params)).to be_truthy
      end
    end
  end
end
