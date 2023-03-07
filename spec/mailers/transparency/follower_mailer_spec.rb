require 'rails_helper'

describe Transparency::FollowerMailer do
  it 'citizen_following' do
    content = {
      subject: 'subject',
      body: 'body'
    }

    emails = ['test1@example.com', 'test2@example.com']

    mail = Transparency::FollowerMailer.citizen_following(content, emails)

    expect(mail.to).to eq(emails)
    expect(mail.subject).to eq(content[:subject])
  end
end
