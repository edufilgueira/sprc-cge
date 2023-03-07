require 'rails_helper'

describe Attendance::Search do

  let(:attendance) { create(:attendance, ticket: ticket) }
  let(:another_attendance) { create(:attendance, ticket: another_ticket) }

  let(:ticket) { create(:ticket) }
  let(:another_ticket) { create(:ticket) }

  it 'protocol' do
    # precisa do reload pois o protocol é gerado como seq.
    # no banco de dados
    attendance.reload
    another_attendance.reload

    attendances = Attendance.search(attendance.protocol)
    expect(attendances).to eq([attendance])
  end

  describe 'description' do
    let(:attendance) { create(:attendance, description: 'abcdef') }
    let(:another_attendance) { create(:attendance, description: 'ghij') }

    it do
      ticket
      another_ticket

      attendances = Attendance.search('a d f')
      expect(attendances).to eq([attendance])
    end
  end

  describe 'name' do
    let(:ticket) { create(:ticket, name: 'abcdef') }
    let(:another_ticket) { create(:ticket, name: 'ghij') }

    it do
      ticket
      another_ticket

      attendances = Attendance.search('a d f')
      expect(attendances).to eq([attendance])
    end
  end

  describe 'document' do
    let(:ticket) { create(:ticket, document: 'abcdef') }
    let(:another_ticket) { create(:ticket, document: 'ghij') }

    it do
      ticket
      another_ticket

      attendances = Attendance.search('a d f')
      expect(attendances).to eq([attendance])
    end
  end

  describe 'email' do
    let(:ticket) { create(:ticket, email: '123456@example.com') }
    let(:another_ticket) { create(:ticket, email: '7890@example.com') }

    it do
      ticket
      another_ticket

      attendances = Attendance.search('1 4 6 @')
      expect(attendances).to eq([attendance])
    end
  end
end
