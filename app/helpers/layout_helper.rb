#
# Helper responsável por diversos aspectos de layout que são compartilhados
# entre diferentes layouts da aplicação. Aspectos como título, descrição,
# <head>, inclusão de webfonts padrão, etc.
#

module LayoutHelper

  STATIC_HEAD_DATA = {
    meta: {
      author: I18n.t('app.author'),
      viewport: 'width=device-width, initial-scale=1',
      'format-detection': 'telephone=no' # desabilita detecção automática de telefones
    }
  }

  def layout_head_data
    STATIC_HEAD_DATA.deep_merge({
      title: layout_title,
      meta: {
        description: layout_description
      },

      open_graph: open_graph_data,
      facebook: facebook_data
    })
  end


  private

  def app_title
    t('app.title')
  end

  def layout_title
    title = content_for(:title)

    ( title ? "#{title} - #{app_title}" : app_title )
  end

  def layout_description
    content_for(:description) || t('app.description')
  end

  def open_graph_data
    { url: request.original_url,
      site_name: layout_title,
      title: layout_title,
      description: layout_description,
      type: 'website',
      locale: 'pt_BR',
      image: asset_url('logos/og-logo-ceara.png') }
  end

  def facebook_data
    { app_id: ENV["FACEBOOK_APP_ID"] }
  end

  def noscript_include_tag
    content_tag('noscript', t('a11y.noscript'))
  end

end
