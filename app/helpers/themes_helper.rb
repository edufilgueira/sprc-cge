module ThemesHelper
  def admin_themes_for_select  
    Theme.all.order(name: :asc)
  end 
end