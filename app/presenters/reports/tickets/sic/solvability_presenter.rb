class Reports::Tickets::Sic::SolvabilityPresenter < Reports::Tickets::Sic::BasePresenter

  attr_reader :scope, :default_scope

  def organs_solvability
    default_scope.distinct.pluck('organs.acronym', 'organs.id').map do |organ|

      service = solvability_service(organ[1])

      next if service.total_count == 0

      [organ[0], service.call, service.total_count]

    end.compact.sort { |a, b| b[1] <=> a[1] }
  end

  def total_unscoped_count
    default_scope.count
  end

  private

  def solvability_service(id)
    Ticket::Solvability::SectoralService.new(default_scope, id, beginning_date, end_date)
  end
  def default_scope
    csai_only(scope).joins(:organ).left_joins(parent: :attendance)
  end

end
