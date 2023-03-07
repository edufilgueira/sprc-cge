require 'rails_helper'

describe User::NotificationRoles do

  it 'new with user_type' do
    user = User.new

    expect(user.notification_roles[:new_ticket]).to eq('email')
    expect(user.notification_roles[:attendance_allocation]).to eq('email')
    expect(user.notification_roles[:satisfaction_survey]).to eq('email')
  end

  it 'user' do
    user = User.new(user_type: :user)

    expect(user.notification_roles[:new_ticket]).to eq('email')
    expect(user.notification_roles[:attendance_allocation]).to eq('email')
    expect(user.notification_roles[:satisfaction_survey]).to eq('email')
    expect(user.notification_roles[:internal_comment]).to be_nil
    expect(user.notification_roles[:change_ticket_type]).to be_nil
  end

  it 'admin' do
    # o FactoryBot.build(:user, :admin) tem outro comportamento.
    # Para testar o initialize estamos usando User.new
    user = User.new(user_type: :admin)

    expect(user.notification_roles).to eq({})
  end

  it 'operator' do
    user = User.new(user_type: :operator)

    expect(user.notification_roles[:new_ticket]).to eq('email')
    expect(user.notification_roles[:internal_comment]).to eq('email')
    expect(user.notification_roles[:attendance_allocation]).to eq('email')
    expect(user.notification_roles[:change_ticket_type]).to eq('email')
    expect(user.notification_roles[:satisfaction_survey]).to eq('email')
  end
end
