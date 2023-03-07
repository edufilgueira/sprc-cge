module Transparency::BaseFilters

  private

  def filtered_by_date_range(key, scope, date)
    return scope unless date.present?
    start_date, end_date = splitted_date(date)
    scope.send("#{key}_in_range", start_date, end_date)
  end

  def splitted_date(date)
    splitted_date = date.split(' - ')

    [splitted_date[0].to_date, splitted_date[1].to_date]
  end

end
