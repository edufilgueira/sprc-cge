class Reports::Tickets::Sic::PercentageOnTimePresenter < Reports::Tickets::Sic::BasePresenter
  include ActionView::Helpers::NumberHelper

  attr_reader :scope

  def initialize(scope, ticket_report)
    @scope = scope.left_joins(parent: :attendance)
    @ticket_report = ticket_report
  end

  def call_center_on_time_str
    translate :call_center_on_time
  end

  def csai_on_time_str
    translate :csai_on_time
  end

  def all_on_time_str
    translate :all_on_time
  end

  def total_count_str
    translate :total_count
  end

  def total_completed_count_str
    translate :total_completed_count
  end

  def call_center_on_time
    # Todas finalizadas pela central (como é finalizado na hora, sempre vai estar dentro do prazo)
    count = attendance_sic_completed(service.ticket_replied_not_expired).count.count +
      attendance_sic_completed(service.reopen_replied_not_expired).count.count


    calculate_percentage(count)
  end

  def csai_on_time
    # Todas finalizadas dentro do prazo que foram criadas pela 155 e encaminhadas ao órgão ou criado diretamente pelo órgão

    count = csai_only(service.ticket_replied_not_expired).count.count +
      csai_only(service.reopen_replied_not_expired).count.count

    calculate_percentage(count)
  end

  def all_on_time
    # Todas finalizadas dentro do prazo

    count = service.replied_and_not_expired_count

    calculate_percentage(count)
  end

  def total_count
    # Todas as solicitações de informação registradas
    service.total_count
  end

  def total_completed_count
    # Todas as solicitações de informação finalizadas
    service.replied_and_expired_count + service.replied_and_not_expired_count
  end

  private

  def service
    @service ||= Ticket::Solvability::SectoralService.new(scope, nil, beginning_date, end_date)
  end

  def calculate_percentage(count)
    percentage = count.to_f / total_completed_count.to_f * 100
    number_to_percentage(percentage, precision: 2)
  end

  def translate(method_name)
    I18n.t("services.reports.tickets.sic.percentage_on_time.rows.#{method_name}")
  end
end
