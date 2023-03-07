class Reports::Tickets::Sou::PerceptionDenouncedFactPresenter < Reports::Tickets::BasePresenter
  include ActionView::Helpers::NumberHelper

  def denunciation_assurance_count(denunciation_assurance)
    tickets = scope.with_denunciation_assurance(denunciation_assurance)

    within_confirmed_at(tickets).count
  end

  def denunciation_assurance_str(denunciation_assurance)
    Ticket.human_attribute_name("denunciation_assurance.#{denunciation_assurance}")
  end

  def denunciation_assurance_percentage(denunciation_assurance)
    total_denun = denunciation_assurance_count(denunciation_assurance)

    return '0.00%' if total_count == 0

    percentage = (total_denun.to_f * 100)/total_count
    number_to_percentage(percentage, precision: 2)
  end

  def total_count
    @total_count ||= within_confirmed_at(scope.with_all_denunciation_assurance).count
  end
end
