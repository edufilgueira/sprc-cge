require 'rails_helper'

describe LayoutHelper do

  let(:request) { OpenStruct.new(original_url: 'http://test.host') }

  it 'returns layout head data' do

    # Para garantir que os diversos aspectos importantes da seção <head>
    # possam ser testados.

    head_data = {
      title: t('app.title'),
      meta: {
        description: t('app.description'),
        author: t('app.author'),
        viewport: 'width=device-width, initial-scale=1',
        'format-detection': 'telephone=no' # desabilita detecção automática de telefones
      },

      open_graph: {
        url: request.original_url,
        site_name: t('app.title'),
        title: t('app.title'),
        description: t('app.description'),
        type: 'website',
        locale: 'pt_BR',
        image: helper.asset_url('logos/og-logo-ceara.png')
      },

      facebook: {
        app_id: ENV["FACEBOOK_APP_ID"]
      }
    }

    result = helper.layout_head_data

    expect(result).to eq(head_data)
  end

  it 'returns specific title for pages' do
    # Caso determinada página forneça valor para title, via content_for, devemos
    # concatenar ao nome da aplicação para sempre seguir o padrão.

    title = 'test'

    allow(helper).to receive(:content_for)
    allow(helper).to receive(:content_for).with(:title).and_return(title)

    expected = "#{title} - #{t('app.title')}"

    expect(helper.layout_head_data[:title]).to eq(expected)
  end

  it 'returns specific description for pages' do
    # A descrição da página é usada para diversas questões, como fornecer
    # informações a crawlers, ser exibida em compartilhamento de redes sociais,
    # entre outros...

    # Cada página específica pode sobrescrever esse valor no layout através do
    # content_for(:description).
    #
    # Caso a página não forneça a descrição específica, é usada a descrição
    # padrão da aplicação, definida em app.pt-BR.yml.

    description = 'test'

    allow(helper).to receive(:content_for)
    allow(helper).to receive(:content_for).with(:description).and_return(description)

    expect(helper.layout_head_data[:meta][:description]).to eq(description)
  end

  context 'open_graph data' do
    # Definimos as diversas informações que uma página passa à API de open_graph
    # para serem usadas em compatilhamentos, por ex.

    it 'url' do
      allow(helper).to receive(:request).and_return(request)

      og_data = helper.layout_head_data[:open_graph]

      expect(og_data[:url]).to eq(request.original_url)
    end

    it 'returns specific title for pages' do
      title = 'test'

      allow(helper).to receive(:content_for)
      allow(helper).to receive(:content_for).with(:title).and_return(title)

      expected = "#{title} - #{t('app.title')}"

      og_data = helper.layout_head_data[:open_graph]

      expect(og_data[:title]).to eq(expected)
    end

    it 'returns specific description for pages' do
      description = 'test'

      allow(helper).to receive(:content_for)
      allow(helper).to receive(:content_for).with(:description).and_return(description)

      og_data = helper.layout_head_data[:open_graph]

      expect(og_data[:description]).to eq(description)
    end
  end

end
