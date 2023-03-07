require 'rails_helper'

describe Transparency::ExportsController do

  let(:transparency_export) { create(:transparency_export) }

  describe '#download' do

    let(:transparency_export) { create(:transparency_export, :server_salary) }

    context 'xhr' do
      it 'render xlsx' do
        filename = transparency_export.filename

        path = Rails.root.to_s + "/public/files/downloads/transparency/export/integration_servers_server_salary/#{filename}"

        expect(controller).to receive(:send_file).with(path, { filename: "#{filename}", type: 'application/xlsx' }) do
          controller.render body: nil # to prevent a 'missing template' error
        end

        get(:download, xhr: true, format: :xlsx, params: { id: transparency_export })
      end
    end
  end
end
