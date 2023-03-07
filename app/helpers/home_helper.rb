module HomeHelper

  def corona_expenses_url
    transparency_page_path(id: 'coronavirus-despesas')
  end

  def corona_btn_title
      t('.coronavirus.btn')
  end

  def corona_expenses_title
    t('.coronavirus.expenses.title')
  end

  def corona_law_title
    t('.coronavirus.law.title')
  end

  def corona_law_url
    transparency_page_path(id: 'coronavirus-legislacao')
  end

  def coronavirus_img_path
    'views/transparency/coronavirus2020_v2.jpg'
  end

  def coronavirus_main_url
    transparency_page_path(id: 'coronavirus')
  end

  def denunciation_img_path
    'views/transparency/denunciation.jpg'
  end

  def denunciation_main_url
    new_user_session_path(ticket_type: :denunciation)
  end

  def is_controller_transparency_home?
    controller.class == Transparency::HomeController
  end

  def ppa_img_path
    'views/transparency/banner_priorizacao_ppa.jpg'
  end

end
