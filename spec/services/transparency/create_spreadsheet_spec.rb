require 'rails_helper'

describe Transparency::CreateSpreadsheet do

  it 'server_salary' do
    server_salary = create(:integration_servers_server_salary)

    transparency_export = create(:transparency_export, :server_salary, worksheet_format: 'xlsx')

    Transparency::CreateSpreadsheet.call(transparency_export.id)

    dirpath = Rails.root.join('public', 'files', 'downloads', 'transparency', 'export', 'integration_servers_server_salary')

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

  it 'revenue_accounts with tree_structure' do
    revenues_account = create(:integration_revenues_account)

    transparency_export = create(:transparency_export, :revenues_account)

    Transparency::CreateSpreadsheet.call(transparency_export.id)

    dirpath = Rails.root.join('public', 'files', 'downloads', 'transparency', 'export', 'integration_revenues_account')

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

  it 'csv' do
    server_salary = create(:integration_servers_server_salary)

    transparency_export = create(:transparency_export, :server_salary, worksheet_format: 'csv')

    Transparency::CreateSpreadsheet.call(transparency_export.id)

    dirpath = Rails.root.join('public', 'files', 'downloads', 'transparency', 'export', 'integration_servers_server_salary')

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


  describe 'transparency export already creaded' do
    it 'already success' do
      server_salary = create(:integration_servers_server_salary)

      transparency_export = create(:transparency_export, :server_salary, worksheet_format: 'xlsx')

      Transparency::CreateSpreadsheet.call(transparency_export.id)

      dirpath = Rails.root.join('public', 'files', 'downloads', 'transparency', 'export', 'integration_servers_server_salary')
      transparency_export.reload
      transparency_export_filename = transparency_export.filename
      transparency_export_expiration = transparency_export.expiration
      transparency_export_status = transparency_export.status
      transparency_export_filepath = "#{dirpath}/#{transparency_export_filename}"

      expect(File.exist?(transparency_export_filepath)).to be_truthy

      # other with the same filter on the same day
      same_transparency_export = create(:transparency_export, :server_salary, worksheet_format: 'xlsx')

      Transparency::CreateSpreadsheet.call(same_transparency_export.id)

      same_transparency_export.reload
      expect(transparency_export.filename).to eq(same_transparency_export.filename)

      same_transparency_export_filename = same_transparency_export.filename
      same_transparency_export_expiration = same_transparency_export.expiration
      same_transparency_export_status = same_transparency_export.status
      same_transparency_export_filepath = "#{dirpath}/#{same_transparency_export_filename}"
      expect(File.exist?(same_transparency_export_filepath)).to be_truthy
    end

    it 'other day' do
      server_salary = create(:integration_servers_server_salary)

      transparency_export = create(:transparency_export, :server_salary, worksheet_format: 'xlsx')

      Transparency::CreateSpreadsheet.call(transparency_export.id)

      dirpath = Rails.root.join('public', 'files', 'downloads', 'transparency', 'export', 'integration_servers_server_salary')

      transparency_export.update_column(:created_at, Date.today - 1)
      transparency_export.reload

      # other with the same filter on the same day
      same_transparency_export = create(:transparency_export, :server_salary, worksheet_format: 'xlsx')

      Transparency::CreateSpreadsheet.call(same_transparency_export.id)

      same_transparency_export.reload
      expect(transparency_export.filename).to_not eq(same_transparency_export.filename)
    end

    it 'in_progress' do
      #
      # XXX
      # XXX para teste descomentar aqui abaixo e algumas linhas do método filename de Transparency::CreateSpreadsheet
      # XXX
      #
      #
      # server_salary = create(:integration_servers_server_salary)

      # transparency_export = create(:transparency_export, :server_salary, worksheet_format: 'xlsx')

      # Transparency::CreateSpreadsheet.call(transparency_export.id)

      # dirpath = Rails.root.join('public', 'files', 'downloads', 'transparency', 'export', 'integration_servers_server_salary')

      # transparency_export.update(status: :in_progress)
      # transparency_export.reload

      # # other with the same filter on the same day
      # same_transparency_export = create(:transparency_export, :server_salary, worksheet_format: 'xlsx')

      # Transparency::CreateSpreadsheet.call(same_transparency_export.id)

      # same_transparency_export.reload
      # expect(transparency_export.filename).to eq(same_transparency_export.filename)
    end
  end
end
