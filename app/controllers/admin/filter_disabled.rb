module Admin::FilterDisabled

  private

  def filtered_by_disabled(scope)
    return scope.unscope(where: :disabled_at) if param_disabled

    scope.enabled
  end

  def param_disabled
    params[:disabled].present? && ActiveModel::Type::Boolean.new.cast(params[:disabled])
  end

  def filtered_resources
    filtered = sorted_resources
    filtered = filtered_by_disabled(filtered)
    filtered(resource_klass, filtered)
  end
end
