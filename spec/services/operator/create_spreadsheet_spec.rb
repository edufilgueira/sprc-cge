require 'rails_helper'

describe Operator::CreateSpreadsheet do

  it 'create list user file xlsx' do

    transparency_export = create(:transparency_export, :user, worksheet_format: 'xlsx')

    Operator::CreateSpreadsheet.call(transparency_export.id)

    dirpath = Rails.root.join('public', 'files', 'downloads', 'transparency', 'export', 'user')

    transparency_export.reload

    filename = transparency_export.filename
    expiration = transparency_export.expiration
    status = transparency_export.status

    filepath = "#{dirpath}/#{filename}"

    expect(File.exist?(filepath)).to be_truthy

    expect(expiration.to_date).to eq(Date.today + 2)
    expect(status).to eq("success")

    FileUtils.rm_rf(filepath)
  end

  it 'create list user file csv' do

    transparency_export = create(:transparency_export, :user, worksheet_format: 'csv')

    Operator::CreateSpreadsheet.call(transparency_export.id)

    dirpath = Rails.root.join('public', 'files', 'downloads', 'transparency', 'export', 'user')

    transparency_export.reload

    filename = transparency_export.filename
    expiration = transparency_export.expiration
    status = transparency_export.status

    filepath = "#{dirpath}/#{filename}"

    expect(File.exist?(filepath)).to be_truthy

    expect(expiration.to_date).to eq(Date.today + 2)
    expect(status).to eq("success")

    FileUtils.rm_rf(filepath)
  end

end
