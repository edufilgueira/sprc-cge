require 'rails_helper'

describe Transparency::ServerSalariesController do

  let(:resource) { create(:integration_servers_server_salary) }

  describe '#index' do
    it_behaves_like 'controllers/transparency/server_salaries/index'
  end

  describe '#index respond_to xlsx format' do
    let(:another_resource) { create(:integration_servers_server_salary) }
    let(:filtered_organ) { resource.organ }

    let(:resource_filter_param) do
      { 'integration_servers_registrations.cod_orgao': filtered_organ.codigo_folha_pagamento }
    end

    it_behaves_like 'controllers/transparency/exports/index'
  end

  describe '#show' do
    it_behaves_like 'controllers/transparency/server_salaries/show'

    it 'print' do
      get(:show, params: { id: resource, print: true })

      is_expected.to render_template('shared/transparency/server_salaries/print')
    end
  end
end
