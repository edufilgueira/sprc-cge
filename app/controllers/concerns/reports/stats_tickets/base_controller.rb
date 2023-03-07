module ::Reports::StatsTickets::BaseController
  extend ActiveSupport::Concern

  included do

    helper_method [
      :current_stats_ticket,
      :title,
      :filters,
      :stats_ticket,
      :stats_tabs,
      :filter_sectoral_organ_sectoral?
    ]

    # helper method

    def stats_ticket
      @stats_ticket ||= Stats::Ticket.find(params[:id])
    end

    def current_stats_ticket(ticket_type)
      Stats::Ticket.current_by_scope!(current_scope(ticket_type))
    end

    def title
      I18n.t('shared.reports.stats_tickets.index.title')
    end

    def filters
      return params if required_filters_present?
      default_filters
    end

    def stats_tabs
      tabs = [:sic, :sou]
      (current_user&.sou_operator? ? tabs.reverse : tabs)
    end

    def filter_organ
      return filters[:organ] if current_user&.cge? && filters[:organ].present?
      current_user&.organ_id if filter_sectoral_organ_sectoral?
    end

    def filter_subnet
      current_user&.subnet_id if filter_sectoral_subnet_sectoral?
    end

    def filter_sectoral_organ
      filters[:sectoral_organ] if filters[:sectoral_organ].present?
    end

    def filter_sectoral_subnet
      filters[:sectoral_subnet] if filters[:sectoral_subnet].present?
    end

    def filter_sectoral_organ_sectoral?
      filter_sectoral_organ == 'sectoral'
    end

    def filter_sectoral_subnet_sectoral?
      filter_sectoral_subnet == 'sectoral'
    end

    def required_filters_present?
      params[:month_start].present? && params[:month_end].present? && params[:year].present?
    end

    def default_filters
      {
        month_start: Date.today.beginning_of_year.month,
        month_end: Date.today.month,
        year: Date.today.year
      }
    end

    def current_scope(ticket_type)
      {
        ticket_type: ticket_type,
        month_start: filters[:month_start],
        month_end: filters[:month_end],
        year: filters[:year],
        organ_id: filter_organ,
        subnet_id: filter_subnet
      }
    end
  end
end


