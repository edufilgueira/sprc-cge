require 'rails_helper'

describe AttendanceReport::Search do

  describe 'title' do
    let(:attendance) { create(:attendance, description: 'abcdef') }
    let(:another_attendance) { create(:attendance, description: 'ghij') }

    it do
      attendance
      another_attendance

      expect(Attendance.search('a d f')).to eq([attendance])
    end
  end
end
