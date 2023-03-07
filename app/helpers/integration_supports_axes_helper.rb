module IntegrationSupportsAxesHelper

  def supports_axes_for_select
    sorted_supports_axes.map { |axis| [axis.title, axis.id] }
  end

  def supports_axes_for_select_with_all_option
    supports_axes_for_select.insert(0, [I18n.t('axis.select.all'), ' '])
  end


  private

  def sorted_supports_axes
    Integration::Supports::Axis.order(:descricao_eixo)
  end
end
