class Reports::Tickets::Sou::DenunciationTypePresenter < Reports::Tickets::BasePresenter
  include ActionView::Helpers::NumberHelper

  attr_reader :service

  def initialize(scope, ticket_report)
    @scope = scope
    @ticket_report = ticket_report
  end

  def denunciation_type_count(name)
    send(name)
  end

  def against_the_state
    scope.denunciation
      .where(denunciation_type: :against_the_state, created_at: date_range)
      .where.not(parent_id: nil).count +

    scope.denunciation
      .where(denunciation_type: :against_the_state, created_at: date_range, parent_id: nil)
      .where('not exists(select 1 from tickets t2 where t2.parent_id = tickets.id and t2.parent_id is not null)').count
  end

  def in_favor_of_the_state
    scope.denunciation
      .where(denunciation_type: :in_favor_of_the_state, created_at: date_range)
      .where.not(parent_id: nil).count +

    scope.denunciation
      .where(denunciation_type: :in_favor_of_the_state, created_at: date_range, parent_id: nil)
      .where('not exists(select 1 from tickets t2 where t2.parent_id = tickets.id and t2.parent_id is not null)').count
  end

  def without_type
    scope.denunciation.where(denunciation_type: nil, created_at: date_range)
      .where.not(parent_id: nil).count +

    scope.denunciation
      .where(denunciation_type: nil, created_at: date_range, parent_id: nil)
      .where('not exists(select 1 from tickets t2 where t2.parent_id = tickets.id and t2.parent_id is not null)').count
  end

  def total
    against_the_state + in_favor_of_the_state + without_type
  end

  def denunciation_type_name(type_name)
    I18n.t("services.reports.tickets.sou.denunciation_type.rows.#{type_name}")
  end

  def denunciation_type_percentage(count)
    number_to_percentage(count.to_f * 100 / total, precision: 2) if total > 0
  end

  private

  def date_range
    beginning_date..end_date
  end
end
