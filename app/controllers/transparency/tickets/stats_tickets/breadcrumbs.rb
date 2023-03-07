module Transparency::Tickets::StatsTickets::Breadcrumbs


  protected

  def index_breadcrumbs
    [
      [t('transparency.home.index.title'), transparency_root_path],
      [t('.title'), '']
    ]
  end

  def show_edit_update_breadcrumbs
    [
      [t('transparency.home.index.title'), transparency_root_path],
      [t('transparency.tickets.stats_tickets.index.title'), transparency_tickets_stats_tickets_path],
      [t('.title'), '']
    ]
  end

end

